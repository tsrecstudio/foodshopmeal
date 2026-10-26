"""Unit tests for the deterministic nutrition calculator (Python mirror of Kotlin)."""
from __future__ import annotations

from decimal import Decimal

import pytest

from app.nutrition import (
    IngredientNutrients,
    compute_recipe_nutrition,
    round2,
)


def _d(v):
    return Decimal(str(v))


def ing(
    kcal, p, f, c, fiber=0.0, dens=0.80, yld=1.00, waste=0.0,
):
    return IngredientNutrients(
        kcal_per_100g=_d(kcal),
        protein_per_100g=_d(p),
        fat_per_100g=_d(f),
        carb_per_100g=_d(c),
        fiber_per_100g=_d(fiber),
        density_g_per_ml=_d(dens),
        yield_factor_cooked=_d(yld),
        waste_factor=_d(waste),
    )


def test_single_ingredient_no_waste_yields_per_serving_equal_to_raw():
    n = compute_recipe_nutrition(
        [("test", Decimal("100"))],
        {"test": ing(100.0, 10.0, 5.0, 80.0)},
        servings=1,
    )
    assert n.per_serving.kcal == Decimal("100.00")
    assert n.per_serving.protein == Decimal("10.00")
    assert n.per_serving.fat == Decimal("5.00")
    assert n.per_serving.carb == Decimal("80.00")
    assert n.raw_edible_weight_g == Decimal("100.00")
    assert n.cooked_weight_g == Decimal("100.00")
    assert n.per100g_cooked.kcal == Decimal("100.00")


def test_waste_factor_increases_gross_weight():
    n = compute_recipe_nutrition(
        [("test", Decimal("100"))],
        {"test": ing(100.0, 0.0, 0.0, 0.0, waste=0.20)},
        servings=1,
    )
    assert n.gross_purchase_weight_g == Decimal("125.00")


def test_yield_factor_cooked_scales_cooked_weight_and_per_100g_cooked():
    n = compute_recipe_nutrition(
        [("test", Decimal("100"))],
        {"test": ing(100.0, 10.0, 5.0, 80.0, yld=0.75)},
        servings=1,
    )
    assert n.cooked_weight_g == Decimal("75.00")
    assert n.per100g_cooked.kcal == Decimal("133.33")
    assert n.per_serving.kcal == Decimal("100.00")


def test_grain_yield_greater_than_one_lowers_per_100g_cooked_kcal():
    n = compute_recipe_nutrition(
        [("гречка", Decimal("100"))],
        {"гречка": ing(352.0, 12.4, 2.4, 67.0, yld=2.80)},
        servings=1,
    )
    assert n.cooked_weight_g == Decimal("280.00")
    assert n.per100g_cooked.kcal == Decimal("125.71")


def test_multiple_ingredients_sum_nutrients():
    # 2 ingredients, each 100g per base serving, scaled to 2 servings
    # -> each ingredient used at 200g; total = 200+400=600 kcal, per serving = 300
    n = compute_recipe_nutrition(
        [("a", Decimal("100")), ("b", Decimal("100"))],
        {"a": ing(100.0, 10.0, 0.0, 20.0), "b": ing(200.0, 20.0, 10.0, 30.0)},
        servings=2,
    )
    assert n.total_batch.kcal == Decimal("600.00")
    assert n.per_serving.kcal == Decimal("300.00")
    assert n.per_serving.protein == Decimal("30.00")
    assert n.per_serving.fat == Decimal("10.00")
    assert n.per_serving.carb == Decimal("50.00")


def test_cooking_yield_preserves_total_batch_calories():
    n = compute_recipe_nutrition(
        [("курица", Decimal("150"))],
        {"курица": ing(133.0, 22.9, 4.4, 0.0, yld=0.75)},
        servings=1,
    )
    assert n.total_batch.kcal == Decimal("199.50")
    assert n.cooked_weight_g == Decimal("112.50")
    assert n.per100g_cooked.kcal == Decimal("177.33")


def test_rounding_is_half_up():
    n = compute_recipe_nutrition(
        [("test", Decimal("10"))],
        {"test": ing(333.33, 0.0, 0.0, 0.0)},
        servings=1,
    )
    assert n.per_serving.kcal == Decimal("33.33")


def test_unknown_ingredient_raises():
    with pytest.raises(ValueError, match="Unknown ingredient"):
        compute_recipe_nutrition(
            [("missing", Decimal("100"))],
            {"test": ing(100.0, 0.0, 0.0, 0.0)},
            servings=1,
        )


def test_round2_half_up():
    assert round2(Decimal("1.005")) == Decimal("1.01")
    assert round2(Decimal("1.004")) == Decimal("1.00")
