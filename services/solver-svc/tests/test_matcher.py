"""Unit tests for the M2 SKU matching pipeline."""
from __future__ import annotations

from dataclasses import dataclass

from app.matcher.matcher import (
    IngredientRecord,
    SkuMatcher,
    SkuRecord,
    extract_fat_percent,
    match_batch,
    normalize_name,
    parse_pack_size,
)


def _ing(ingredient_id, name, synonyms=None, category="grains"):
    return IngredientRecord(
        ingredient_id=ingredient_id,
        name=name,
        synonyms=synonyms or [],
        category=category,
        kcal_per_100g=300,
        protein_per_100g=10,
        fat_per_100g=5,
        carb_per_100g=60,
        fiber_per_100g=5,
        density_g_per_ml=0.8,
        yield_factor_cooked=1.0,
        waste_factor=0.0,
        allergens=[],
        tags=[category],
    )


INGREDIENTS = [
    _ing("ing-1", "Гречневая крупа ядрица", ["гречка"], "grains"),
    _ing("ing-2", "Картофель", ["картошка"], "vegetables"),
    _ing("ing-3", "Молоко коровье 3,2%", ["молоко"], "dairy"),
    _ing("ing-4", "Масло сливочное 72,5%", ["масло сливочное"], "dairy"),
    _ing("ing-5", "Яйца куриные", ["яйца"], "eggs"),
]


def _sku(sku_id, name, pack_size=None, unit="g", category="grains", brand=None, gtin=None):
    return SkuRecord(
        sku_id=sku_id,
        retailer_id="ret-1",
        external_id=sku_id,
        name=name,
        brand=brand,
        gtin=gtin,
        pack_size=pack_size,
        unit=unit,
        category=category,
    )


def test_normalize_name_lowercases_and_strips():
    assert normalize_name("  Гречневая   Крупа  ") == "гречневая крупа"
    assert normalize_name("Картофель «Идеальный»") == "картофель идеальный"


def test_parse_pack_size():
    assert parse_pack_size("250 g") == ("g", 250.0)
    assert parse_pack_size("1 л") == ("л", 1.0)
    assert parse_pack_size("500") == ("", 500.0)
    assert parse_pack_size("2.5 кг") == ("kg", 2.5)


def test_extract_fat_percent():
    assert extract_fat_percent("масло 72,5%") == 72.5
    assert extract_fat_percent("творог 0%") == 0.0
    assert extract_fat_percent("без %") is None


def test_exact_name_match_auto_accepts():
    matcher = SkuMatcher()
    result = matcher.match_sku(_sku("sku-1", "Гречневая крупа ядрица", "500 g"), INGREDIENTS)
    assert result is not None
    assert result.ingredient_id == "ing-1"
    assert result.confidence >= 0.9
    assert result.status == "matched"


def test_synonym_match_auto_accepts():
    matcher = SkuMatcher()
    result = matcher.match_sku(_sku("sku-2", "Гречка", "1000 g"), INGREDIENTS)
    assert result is not None
    assert result.ingredient_id == "ing-1"
    assert result.confidence >= 0.9


def test_close_name_match_goes_to_review():
    matcher = SkuMatcher()
    # "Гречневый суп" is close to "Гречневая крупа ядрица" but not exact
    result = matcher.match_sku(_sku("sku-3", "Гречневый суп готовый"), INGREDIENTS)
    assert result is not None
    assert result.status == "review"


def test_no_match_returns_none():
    matcher = SkuMatcher()
    result = matcher.match_sku(_sku("sku-4", "Ананасы консервированные"), INGREDIENTS)
    # no ing close enough -> None (or review with low confidence)
    if result:
        assert result.confidence < 0.9


def test_pack_size_extracts_net_weight():
    matcher = SkuMatcher()
    result = matcher.match_sku(_sku("sku-5", "Картофель", "1000 g"), INGREDIENTS)
    assert result is not None
    assert result.net_weight_g == 1000.0


def test_batch_matching():
    skus = [
        _sku("sku-a", "Гречка", "500 g"),
        _sku("sku-b", "Картофель", "1000 g"),
        _sku("sku-c", "Ананасы"),
    ]
    results = match_batch(skus, INGREDIENTS)
    assert len(results) == 2  # ананас не совпал
    ids = {r.ingredient_id for r in results}
    assert "ing-1" in ids
    assert "ing-2" in ids


def test_auto_accept_threshold_configurable():
    matcher = SkuMatcher(auto_accept_threshold=0.95)
    result = matcher.match_sku(_sku("sku-d", "Гречка", "500 g"), INGREDIENTS)
    assert result is not None
    assert result.status == "review"  # below 0.95


def test_gtin_stripped_from_name():
    assert normalize_name("Гречка 0123456789012") == "гречка"
