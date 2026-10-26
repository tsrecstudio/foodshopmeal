"""M1 nutrition calculator — Python mirror of the Kotlin NutritionCalculator.

Deterministic KBZHU (КБЖУ) computation from the ingredient graph:
  * nutrients_per_100g are per 100 g of edible raw portion;
  * grams_gross   = grams_raw / (1 - waste_factor)   (purchase weight incl. waste)
  * grams_cooked  = grams_raw * yield_factor_cooked  (weight after cooking)
  * nutrients     = grams_raw / 100 * n_per_100g
  * per_serving   = total_batch / servings
  * per_100g_cooked = total_batch / cooked_weight * 100

Recipes never store nutrients — they are always derived from ingredients here.
All arithmetic uses decimal.Decimal with ROUND_HALF_UP to 2 places.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from decimal import Decimal, ROUND_HALF_UP
from typing import Iterable, Mapping

SCALE = Decimal("100")
TWO_PLACES = Decimal("0.01")


def round2(value: Decimal) -> Decimal:
    return value.quantize(TWO_PLACES, rounding=ROUND_HALF_UP)


@dataclass(frozen=True)
class IngredientNutrients:
    kcal_per_100g: Decimal
    protein_per_100g: Decimal
    fat_per_100g: Decimal
    carb_per_100g: Decimal
    fiber_per_100g: Decimal
    density_g_per_ml: Decimal
    yield_factor_cooked: Decimal
    waste_factor: Decimal


@dataclass(frozen=True)
class NutrientsBatch:
    kcal: Decimal
    protein: Decimal
    fat: Decimal
    carb: Decimal
    fiber: Decimal


@dataclass(frozen=True)
class RawComponent:
    ingredient_name: str
    grams_raw: Decimal
    grams_gross: Decimal
    grams_cooked: Decimal
    nutrients: NutrientsBatch


@dataclass(frozen=True)
class RecipeNutrition:
    total_batch: NutrientsBatch
    raw_edible_weight_g: Decimal
    gross_purchase_weight_g: Decimal
    cooked_weight_g: Decimal
    per_serving: NutrientsBatch
    per100g_cooked: NutrientsBatch
    components: list[RawComponent] = field(default_factory=list)


def _d(v: str | float | int | Decimal) -> Decimal:
    if isinstance(v, Decimal):
        return v
    return Decimal(str(v))


def compute_recipe_nutrition(
    components: list[tuple[str, Decimal]],
    ingredients: Mapping[str, IngredientNutrients],
    servings: int,
) -> RecipeNutrition:
    scale = _d(servings)
    total_kcal = Decimal("0")
    total_protein = Decimal("0")
    total_fat = Decimal("0")
    total_carb = Decimal("0")
    total_fiber = Decimal("0")
    total_raw = Decimal("0")
    total_gross = Decimal("0")
    total_cooked = Decimal("0")
    computed: list[RawComponent] = []

    for name, base_grams in components:
        ing = ingredients.get(name)
        if ing is None:
            raise ValueError(f"Unknown ingredient: {name}")
        grams_raw = _d(base_grams) * scale
        grams_gross = grams_raw / (Decimal("1") - ing.waste_factor)
        grams_cooked = grams_raw * ing.yield_factor_cooked

        factor = grams_raw / SCALE
        n = NutrientsBatch(
            kcal=factor * ing.kcal_per_100g,
            protein=factor * ing.protein_per_100g,
            fat=factor * ing.fat_per_100g,
            carb=factor * ing.carb_per_100g,
            fiber=factor * ing.fiber_per_100g,
        )

        total_kcal += n.kcal
        total_protein += n.protein
        total_fat += n.fat
        total_carb += n.carb
        total_fiber += n.fiber
        total_raw += grams_raw
        total_gross += grams_gross
        total_cooked += grams_cooked

        computed.append(
            RawComponent(
                ingredient_name=name,
                grams_raw=round2(grams_raw),
                grams_gross=round2(grams_gross),
                grams_cooked=round2(grams_cooked),
                nutrients=n,
            )
        )

    per_serving = NutrientsBatch(
        kcal=round2(total_kcal / scale),
        protein=round2(total_protein / scale),
        fat=round2(total_fat / scale),
        carb=round2(total_carb / scale),
        fiber=round2(total_fiber / scale),
    )

    cooked_for_100g = total_cooked if total_cooked > Decimal("0") else Decimal("1")
    per100g_cooked = NutrientsBatch(
        kcal=round2(total_kcal * SCALE / cooked_for_100g),
        protein=round2(total_protein * SCALE / cooked_for_100g),
        fat=round2(total_fat * SCALE / cooked_for_100g),
        carb=round2(total_carb * SCALE / cooked_for_100g),
        fiber=round2(total_fiber * SCALE / cooked_for_100g),
    )

    return RecipeNutrition(
        total_batch=NutrientsBatch(
            kcal=round2(total_kcal),
            protein=round2(total_protein),
            fat=round2(total_fat),
            carb=round2(total_carb),
            fiber=round2(total_fiber),
        ),
        raw_edible_weight_g=round2(total_raw),
        gross_purchase_weight_g=round2(total_gross),
        cooked_weight_g=round2(total_cooked),
        per_serving=per_serving,
        per100g_cooked=per100g_cooked,
        components=computed,
    )


def load_ingredients_from_tsv(path: str) -> dict[str, IngredientNutrients]:
    """Load ingredients from a TSV (same format as tools/m1_ingredients_*.tsv)."""
    out: dict[str, IngredientNutrients] = {}
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split("|")
            if len(parts) < 11:
                continue
            name = parts[0].strip()
            out[name] = IngredientNutrients(
                kcal_per_100g=_d(parts[2]),
                protein_per_100g=_d(parts[3]),
                fat_per_100g=_d(parts[4]),
                carb_per_100g=_d(parts[5]),
                fiber_per_100g=_d(parts[6]),
                density_g_per_ml=_d(parts[7]),
                yield_factor_cooked=_d(parts[8]),
                waste_factor=_d(parts[9]),
            )
    return out


def load_ingredients_from_all(tsv_dir: str) -> dict[str, IngredientNutrients]:
    """Load ingredients from tools/m1_ingredients_{a,b,c}.tsv in a directory."""
    import os
    out: dict[str, IngredientNutrients] = {}
    for fn in ("m1_ingredients_a.tsv", "m1_ingredients_b.tsv", "m1_ingredients_c.tsv"):
        p = os.path.join(tsv_dir, fn)
        if os.path.exists(p):
            out.update(load_ingredients_from_tsv(p))
    return out
