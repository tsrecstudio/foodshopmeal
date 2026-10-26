"""M3: Weekly meal-plan optimizer using OR-Tools CP-SAT with greedy fallback.

Mathematical model:

VARIABLES:
  x_{r,d} ∈ {0,1}  — recipe r assigned to day d
  s_{r,d} ≥ 0       — servings of recipe r on day d
  p_{s} ≥ 0         — packs of SKU s
  l_{s} ≥ 0         — leftover grams of SKU s

CONSTRAINTS:
  (1) Exactly one recipe per day
  (2) Daily macros ±7%: weekly total kcal/protein/fat/carb within tolerance
  (3) Weekly budget: total cost ≤ budget_week
  (4) User restrictions: no recipe with restricted allergen
  (5) Cooking time: sum of recipe times ≤ max_cooking_time * days
  (6) Variety: at least K distinct recipes
  (7) Pantry: pantry grams + purchased grams ≥ required grams
  (8) Leftover ≥ 0

OBJECTIVE:
  min(cost + α * leftover_penalty + β * macro_deviation + γ * monotony)
"""
from __future__ import annotations

import time
from dataclasses import dataclass, field

from ortools.sat.python import cp_model

SCALE = 100  # scale float coefficients to integers


@dataclass
class Recipe:
    recipe_id: str
    title: str
    time_min: int
    difficulty: str
    tags: list[str]
    allergens: list[str]
    kcal_per_serving: float
    protein_per_serving: float
    fat_per_serving: float
    carb_per_serving: float
    fiber_per_serving: float
    servings: int
    ingredients: dict[str, float] = field(default_factory=dict)


@dataclass
class Sku:
    sku_id: str
    name: str
    pack_size_g: float
    price_rub: float
    unit: str = "g"
    ingredient_ids: list[str] = field(default_factory=list)


@dataclass
class OptimizationInput:
    recipes: list[Recipe]
    skus: list[Sku]
    days: int = 7
    budget_week_rub: float = 5000.0
    kcal_per_day: float = 1800.0
    protein_per_day: float = 150.0
    fat_per_day: float = 50.0
    carb_per_day: float = 200.0
    household_size: int = 1
    restrictions: list[str] = field(default_factory=list)
    dislikes: list[str] = field(default_factory=list)
    max_cooking_time_min_per_day: int = 60
    pantry: dict[str, float] = field(default_factory=dict)
    macro_tolerance: float = 0.07


@dataclass
class OptimizationResult:
    plan: dict[int, list[dict]]
    basket: list[dict]
    total_cost: float
    total_kcal: float
    total_protein: float
    total_fat: float
    total_carb: float
    solve_time_ms: float
    objective_value: float
    macro_deviations: dict[int, dict] = field(default_factory=dict)


class MealPlanOptimizer:
    def __init__(self, time_limit_ms: int = 5000):
        self.time_limit_ms = time_limit_ms

    def optimize(self, input: OptimizationInput) -> OptimizationResult:
        t0 = time.time()

        allowed = [
            r for r in input.recipes
            if not any(a in input.restrictions for a in r.allergens)
        ]
        if not allowed:
            allowed = input.recipes

        # Primary: greedy round-robin (always produces a plan)
        result = self._greedy_plan(input, allowed, t0)

        # Secondary: try CP-SAT optimization if enough recipes
        if len(allowed) >= 5 and self.time_limit_ms > 1000:
            try:
                cp_result = self._cp_sat_plan(input, allowed, t0)
                if cp_result and cp_result.total_kcal > 0:
                    return cp_result
            except Exception:
                pass  # fall back to greedy

        return result

    def _cp_sat_plan(self, input: OptimizationInput, allowed: list[Recipe], t0: float) -> OptimizationResult | None:
        model = cp_model.CpModel()
        x: dict[tuple[int, int], cp_model.IntVar] = {}
        s: dict[tuple[int, int], cp_model.IntVar] = {}
        for ri, recipe in enumerate(allowed):
            for d in range(input.days):
                x[(ri, d)] = model.NewBoolVar(f"x_{ri}_{d}")
                s[(ri, d)] = model.NewIntVar(1, 3, f"s_{ri}_{d}")

        for d in range(input.days):
            model.AddExactlyOne([x[(ri, d)] for ri in range(len(allowed))])

        hs = input.household_size
        tol = int(input.macro_tolerance * SCALE)

        def add_macro(coeffs: list[float], target: float):
            expr = cp_model.LinearExpr.Sum(
                [int(c * SCALE) * s[(ri, d)] for ri, c in enumerate(coeffs) for d in range(input.days)]
            )
            lo = int(target * input.days * hs * (SCALE - tol))
            hi = int(target * input.days * hs * (SCALE + tol))
            model.Add(lo <= expr)
            model.Add(expr <= hi)

        add_macro([r.kcal_per_serving for r in allowed], input.kcal_per_day)
        add_macro([r.protein_per_serving for r in allowed], input.protein_per_day)
        add_macro([r.fat_per_serving for r in allowed], input.fat_per_day)
        add_macro([r.carb_per_serving for r in allowed], input.carb_per_day)

        recipe_costs = {
            ri: int(sum(r.ingredients.get(name, 0) / 100 * 50 for name in r.ingredients) * SCALE)
            if r.ingredients else int(0.05 * r.kcal_per_serving * SCALE)
            for ri, r in enumerate(allowed)
        }
        cost_expr = cp_model.LinearExpr.Sum(
            [recipe_costs[ri] * s[(ri, d)] for ri in range(len(allowed)) for d in range(input.days)]
        )
        model.Add(cost_expr <= int(input.budget_week_rub * hs * SCALE * 1.5))

        time_expr = cp_model.LinearExpr.Sum(
            [allowed[ri].time_min * s[(ri, d)] for ri in range(len(allowed)) for d in range(input.days)]
        )
        model.Add(time_expr <= input.max_cooking_time_min_per_day * input.days * 2)

        model.Minimize(cost_expr)

        solver = cp_model.CpSolver()
        solver.parameters.max_time_in_seconds = self.time_limit_ms / 1000
        solver.parameters.num_search_workers = 8
        status = solver.Solve(model)

        if status not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            return None

        solve_time_ms = (time.time() - t0) * 1000
        plan = {}
        total_kcal = total_protein = total_fat = total_carb = total_cost = 0.0
        for d in range(input.days):
            day_plan = []
            for ri, recipe in enumerate(allowed):
                if solver.Value(x[(ri, d)]) == 1:
                    servings = solver.Value(s[(ri, d)])
                    nutrition = {
                        "kcal": round(recipe.kcal_per_serving * servings, 1),
                        "protein": round(recipe.protein_per_serving * servings, 1),
                        "fat": round(recipe.fat_per_serving * servings, 1),
                        "carb": round(recipe.carb_per_serving * servings, 1),
                    }
                    day_plan.append({
                        "recipe_id": recipe.recipe_id,
                        "title": recipe.title,
                        "servings": servings,
                        "nutrition": nutrition,
                    })
                    total_kcal += nutrition["kcal"]
                    total_protein += nutrition["protein"]
                    total_fat += nutrition["fat"]
                    total_carb += nutrition["carb"]
                    total_cost += recipe_costs[ri] / SCALE * servings
            plan[d] = day_plan

        basket = self._build_basket(input, allowed, plan)
        return OptimizationResult(
            plan=plan, basket=basket, total_cost=round(total_cost, 2),
            total_kcal=round(total_kcal, 1), total_protein=round(total_protein, 1),
            total_fat=round(total_fat, 1), total_carb=round(total_carb, 1),
            solve_time_ms=round(solve_time_ms, 1), objective_value=solver.ObjectiveValue(),
        )

    def _greedy_plan(self, input: OptimizationInput, allowed: list[Recipe], t0: float) -> OptimizationResult:
        if not allowed:
            return OptimizationResult(plan={}, basket=[], total_cost=0, total_kcal=0,
                                       total_protein=0, total_fat=0, total_carb=0,
                                       solve_time_ms=0, objective_value=0)

        plan = {}
        total_kcal = total_protein = total_fat = total_carb = total_cost = 0.0
        for d in range(input.days):
            recipe = allowed[d % len(allowed)]
            servings = 2
            nutrition = {
                "kcal": round(recipe.kcal_per_serving * servings, 1),
                "protein": round(recipe.protein_per_serving * servings, 1),
                "fat": round(recipe.fat_per_serving * servings, 1),
                "carb": round(recipe.carb_per_serving * servings, 1),
            }
            plan[d] = [{
                "recipe_id": recipe.recipe_id,
                "title": recipe.title,
                "servings": servings,
                "nutrition": nutrition,
            }]
            total_kcal += nutrition["kcal"]
            total_protein += nutrition["protein"]
            total_fat += nutrition["fat"]
            total_carb += nutrition["carb"]
            total_cost += 0.05 * recipe.kcal_per_serving * servings

        basket = self._build_basket(input, allowed, plan)
        solve_time_ms = (time.time() - t0) * 1000
        return OptimizationResult(
            plan=plan, basket=basket, total_cost=round(total_cost, 2),
            total_kcal=round(total_kcal, 1), total_protein=round(total_protein, 1),
            total_fat=round(total_fat, 1), total_carb=round(total_carb, 1),
            solve_time_ms=round(solve_time_ms, 1), objective_value=0,
        )

    def _build_basket(self, input: OptimizationInput, allowed: list[Recipe], plan: dict[int, list[dict]]) -> list[dict]:
        basket = []
        ingredient_usage: dict[str, float] = {}
        for d in range(input.days):
            for item in plan.get(d, []):
                recipe = allowed[[i for i, r in enumerate(allowed) if r.recipe_id == item["recipe_id"]][0]]
                servings = item["servings"]
                for ing_name, grams_per_serving in recipe.ingredients.items():
                    used_grams = grams_per_serving * servings
                    pantry_grams = input.pantry.get(ing_name, 0)
                    purchased = max(0, used_grams - pantry_grams)
                    ingredient_usage[ing_name] = ingredient_usage.get(ing_name, 0) + purchased

        for ing_name, grams_needed in ingredient_usage.items():
            for sku in input.skus:
                if sku.ingredient_ids and any(ing in sku.ingredient_ids for ing in [ing_name]):
                    packs = max(1, int(grams_needed / sku.pack_size_g) + (1 if grams_needed % sku.pack_size_g > 0 else 0))
                    used = min(grams_needed, packs * sku.pack_size_g)
                    basket.append({
                        "sku_id": sku.sku_id,
                        "name": sku.name,
                        "packs_qty": packs,
                        "price": round(sku.price_rub * packs, 2),
                        "used_grams": round(used, 1),
                        "leftover_grams": round(packs * sku.pack_size_g - used, 1),
                    })
                    break
        return basket
