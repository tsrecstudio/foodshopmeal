"""M4: Substitution Engine — per-basket-line policy + ranked alternatives.

Policies:
  strict       — only same-ingredient SKUs (identical ingredient graph node)
  same-ingredient — same ingredient, different brand/pack
  similar      — same category, similar nutrients within macro tolerance
  any          — any SKU in the same category

Default for protein items: strict.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Iterable


@dataclass(frozen=True)
class SubstitutionPolicy:
    name: str
    allowed_sku_ids: list[str] = field(default_factory=list)
    macro_tolerance: float = 0.15  # ±15% by default


POLICY_STRICT = "strict"
POLICY_SAME_INGREDIENT = "same-ingredient"
POLICY_SIMILAR = "similar"
POLICY_ANY = "any"

DEFAULT_PROTEIN_POLICY = POLICY_STRICT


@dataclass(frozen=True)
class SkuInfo:
    sku_id: str
    name: str
    ingredient_id: str
    ingredient_name: str
    category: str
    kcal_per_100g: float
    protein_per_100g: float
    fat_per_100g: float
    carb_per_100g: float
    pack_size_g: float
    price_rub: float
    brand: str | None = None


@dataclass(frozen=True)
class BasketLine:
    sku_id: str
    ingredient_id: str
    ingredient_name: str
    packs_qty: int
    used_grams: float
    price: float
    policy: str = POLICY_STRICT


@dataclass(frozen=True)
class SubstitutionCandidate:
    sku_id: str
    name: str
    ingredient_id: str
    ingredient_name: str
    category: str
    kcal_per_100g: float
    protein_per_100g: float
    fat_per_100g: float
    carb_per_100g: float
    pack_size_g: float
    price_rub: float
    brand: str | None
    kbzh_delta: dict[str, float]  # kcal/protein/fat/carb delta per 100g
    score: float


class SubstitutionEngine:
    def __init__(self, default_protein_policy: str = DEFAULT_PROTEIN_POLICY):
        self.default_protein_policy = default_protein_policy

    def get_alternatives(
        self,
        line: BasketLine,
        all_skus: Iterable[SkuInfo],
    ) -> list[SubstitutionCandidate]:
        """Return ranked substitution alternatives for a basket line."""
        base = next((s for s in all_skus if s.sku_id == line.sku_id), None)
        if base is None:
            return []

        policy = line.policy or self._infer_policy(base)
        candidates: list[SubstitutionCandidate] = []

        for sku in all_skus:
            if sku.sku_id == line.sku_id:
                continue

            if self._is_allowed(base, sku, policy, line):
                delta = self._compute_delta(base, sku)
                score = self._compute_score(base, sku, policy)
                candidates.append(
                    SubstitutionCandidate(
                        sku_id=sku.sku_id,
                        name=sku.name,
                        ingredient_id=sku.ingredient_id,
                        ingredient_name=sku.ingredient_name,
                        category=sku.category,
                        kcal_per_100g=sku.kcal_per_100g,
                        protein_per_100g=sku.protein_per_100g,
                        fat_per_100g=sku.fat_per_100g,
                        carb_per_100g=sku.carb_per_100g,
                        pack_size_g=sku.pack_size_g,
                        price_rub=sku.price_rub,
                        brand=sku.brand,
                        kbzh_delta=delta,
                        score=score,
                    )
                )

        candidates.sort(key=lambda c: c.score, reverse=True)
        return candidates

    def _infer_policy(self, sku: SkuInfo) -> str:
        if sku.category == "protein" or "protein" in (sku.category or "").lower():
            return self.default_protein_policy
        return POLICY_SAME_INGREDIENT

    def _is_allowed(self, base: SkuInfo, alt: SkuInfo, policy: str, line: BasketLine) -> bool:
        tol = 0.15
        if policy == POLICY_STRICT:
            return base.ingredient_id == alt.ingredient_id
        elif policy == POLICY_SAME_INGREDIENT:
            return base.ingredient_id == alt.ingredient_id
        elif policy == POLICY_SIMILAR:
            if base.ingredient_id != alt.ingredient_id:
                # Different ingredient but same category and nutrients within tolerance
                if base.category != alt.category:
                    return False
                return (
                    abs(base.kcal_per_100g - alt.kcal_per_100g) / base.kcal_per_100g <= tol
                    and abs(base.protein_per_100g - alt.protein_per_100g) / max(base.protein_per_100g, 1) <= tol
                    and abs(base.fat_per_100g - alt.fat_per_100g) / max(base.fat_per_100g, 1) <= tol
                )
            return True
        elif policy == POLICY_ANY:
            return base.category == alt.category
        return False

    def _compute_delta(self, base: SkuInfo, alt: SkuInfo) -> dict[str, float]:
        return {
            "kcal": round(alt.kcal_per_100g - base.kcal_per_100g, 2),
            "protein": round(alt.protein_per_100g - base.protein_per_100g, 2),
            "fat": round(alt.fat_per_100g - base.fat_per_100g, 2),
            "carb": round(alt.carb_per_100g - base.carb_per_100g, 2),
        }

    def _compute_score(self, base: SkuInfo, alt: SkuInfo, policy: str) -> float:
        score = 0.0
        # Nutrient similarity
        nut_score = 1.0 - (
            abs(base.kcal_per_100g - alt.kcal_per_100g) / max(base.kcal_per_100g, 1)
            + abs(base.protein_per_100g - alt.protein_per_100g) / max(base.protein_per_100g, 1)
            + abs(base.fat_per_100g - alt.fat_per_100g) / max(base.fat_per_100g, 1)
            + abs(base.carb_per_100g - alt.carb_per_100g) / max(base.carb_per_100g, 1)
        ) / 4
        score += nut_score * 0.5
        # Price similarity (lower is better but we want close to original)
        price_ratio = alt.price_rub / max(base.price_rub, 0.01)
        price_score = 1.0 - abs(price_ratio - 1.0)
        score += price_score * 0.3
        # Same ingredient bonus
        if base.ingredient_id == alt.ingredient_id:
            score += 0.2
        return round(score, 4)
