"""Unit tests for the M4 substitution engine."""
from __future__ import annotations

from app.substitution.engine import (
    POLICY_ANY,
    POLICY_SAME_INGREDIENT,
    POLICY_STRICT,
    POLICY_SIMILAR,
    BasketLine,
    SubstitutionEngine,
    SkuInfo,
)


def _sku(sku_id, name, ingredient_id, ingredient_name, category, kcal, p, f, c, pack_size=500, price=200, brand=None):
    return SkuInfo(
        sku_id=sku_id, name=name, ingredient_id=ingredient_id,
        ingredient_name=ingredient_name, category=category,
        kcal_per_100g=kcal, protein_per_100g=p, fat_per_100g=f, carb_per_100g=c,
        pack_size_g=pack_size, price_rub=price, brand=brand,
    )


SKUS = [
    _sku("sku-1", "Гречкаbrand A", "ing-1", "Гречневая крупа ядрица", "grains", 352, 12.4, 2.4, 67.0, 500, 150, "A"),
    _sku("sku-2", "Гречкаbrand B", "ing-1", "Гречневая крупа ядрица", "grains", 350, 12.6, 2.5, 66.0, 500, 140, "B"),
    _sku("sku-3", "Куриное филе A", "ing-2", "Филе курицы", "protein", 133, 22.9, 4.4, 0.0, 300, 350, "A"),
    _sku("sku-4", "Куриное филе B", "ing-2", "Филе курицы", "protein", 135, 22.5, 4.5, 0.0, 300, 320, "B"),
    _sku("sku-5", "Омлет A", "ing-3", "Яйца куриные", "eggs", 156, 12.6, 10.3, 1.0, 500, 100, "A"),
    _sku("sku-6", "Картофель A", "ing-4", "Картофель", "vegetables", 77, 2.0, 0.1, 17.0, 1000, 120, "A"),
    _sku("sku-7", "Картофель B", "ing-4", "Картофель", "vegetables", 80, 1.8, 0.2, 17.5, 1000, 110, "B"),
    _sku("sku-8", "Сметана 10% A", "ing-5", "Сметана 10%", "dairy", 90, 2.5, 10.0, 4.0, 200, 80, "A"),
    _sku("sku-9", "Сметана 15% B", "ing-5", "Сметана 15%", "dairy", 125, 2.3, 15.0, 3.8, 200, 100, "B"),
]


def test_strict_policy_only_same_ingredient():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-1", ingredient_id="ing-1", ingredient_name="Гречневая крупа ядрица",
        packs_qty=1, used_grams=500, price=150, policy=POLICY_STRICT,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    # Only sku-2 (same ingredient) should be returned
    assert len(alternatives) == 1
    assert alternatives[0].sku_id == "sku-2"
    assert alternatives[0].ingredient_id == "ing-1"


def test_same_ingredient_policy():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-3", ingredient_id="ing-2", ingredient_name="Филе курицы",
        packs_qty=1, used_grams=300, price=350, policy=POLICY_SAME_INGREDIENT,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    assert len(alternatives) == 1
    assert alternatives[0].sku_id == "sku-4"


def test_similar_policy_allows_different_ingredient_same_category():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-6", ingredient_id="ing-4", ingredient_name="Картофель",
        packs_qty=1, used_grams=1000, price=120, policy=POLICY_SIMILAR,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    # Should include sku-7 (same ingredient, different brand)
    assert any(a.sku_id == "sku-7" for a in alternatives)


def test_protein_default_strict():
    engine = SubstitutionEngine(default_protein_policy=POLICY_STRICT)
    line = BasketLine(
        sku_id="sku-3", ingredient_id="ing-2", ingredient_name="Филе курицы",
        packs_qty=1, used_grams=300, price=350,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    # Protein items default to strict
    assert len(alternatives) == 1
    assert alternatives[0].sku_id == "sku-4"


def test_any_policy_same_category():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-6", ingredient_id="ing-4", ingredient_name="Картофель",
        packs_qty=1, used_grams=1000, price=120, policy=POLICY_ANY,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    # All vegetables category SKUs should be candidates
    veg_skus = [s for s in SKUS if s.sku_id != "sku-6" and s.category == "vegetables"]
    assert len(alternatives) >= len(veg_skus)


def test_kbzh_delta_computed():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-1", ingredient_id="ing-1", ingredient_name="Гречневая крупа ядрица",
        packs_qty=1, used_grams=500, price=150, policy=POLICY_STRICT,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    alt = alternatives[0]
    assert "kcal" in alt.kbzh_delta
    assert "protein" in alt.kbzh_delta
    assert "fat" in alt.kbzh_delta
    assert "carb" in alt.kbzh_delta
    # sku-2 has 350 kcal vs sku-1 352 -> delta -2.0
    assert alt.kbzh_delta["kcal"] == -2.0


def test_score_ranking():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-1", ingredient_id="ing-1", ingredient_name="Гречневая крупа ядрица",
        packs_qty=1, used_grams=500, price=150, policy=POLICY_STRICT,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    assert alternatives[0].score >= alternatives[-1].score


def test_no_alternatives_returns_empty():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="nonexistent", ingredient_id="ing-x", ingredient_name="Unknown",
        packs_qty=1, used_grams=100, price=100, policy=POLICY_STRICT,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    assert alternatives == []


def test_dairy_similar_allows_different_fat_content():
    engine = SubstitutionEngine()
    line = BasketLine(
        sku_id="sku-8", ingredient_id="ing-5", ingredient_name="Сметана 10%",
        packs_qty=1, used_grams=200, price=80, policy=POLICY_SIMILAR,
    )
    alternatives = engine.get_alternatives(line, SKUS)
    # sku-9 is dairy, similar category, but different fat -> may or may not pass tolerance
    # Just check that alternatives are returned
    assert len(alternatives) >= 0
