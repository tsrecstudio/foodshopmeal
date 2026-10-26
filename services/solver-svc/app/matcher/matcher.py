"""M2 SKU matching pipeline.

Flow:
  1. Normalize SKU name / brand / pack size (Cyrillic/latin, synonyms, units).
  2. Candidate retrieval via pgvector (embedding on ingredient graph) + name match.
  3. LLM classification with confidence (stub here — replace with real LLM in prod).
  4. Auto-accept confidence >= 0.9; else route to manual review queue.

Anti-corruption: catalog data never leaks into core domain; only IDs + names cross.
"""
from __future__ import annotations

import re
import unicodedata
from dataclasses import dataclass, field
from typing import Iterable

# Confidence thresholds
AUTO_ACCEPT_THRESHOLD = 0.9
MIN_RETURN_THRESHOLD = 0.3  # below this, return no match at all
SYNONYM_CONFIDENCE = 0.93

# Synonym map (Russian product names -> canonical ingredient graph names)
SYNONYM_MAP: dict[str, str] = {
    "гречка": "Гречневая крупа ядрица",
    "гречневая": "Гречневая крупа ядрица",
    "овсянка": "Хлопья овсяные",
    "овсяные хлопья": "Хлопья овсяные",
    "картошка": "Картофель",
    "картофель": "Картофель",
    "морковь": "Морковь",
    "лук": "Лук репчатый",
    "репчатый лук": "Лук репчатый",
    "чеснок": "Чеснок",
    "помидоры": "Помидоры",
    "томат": "Помидоры",
    "огурцы": "Огурцы",
    "капуста": "Капуста белокочанная",
    "белая капуста": "Капуста белокочанная",
    "свёкла": "Свёкла",
    "свекла": "Свёкла",
    "масло сливочное": "Масло сливочное 72,5%",
    "масло растительное": "Масло растительное",
    "подсолнечное масло": "Масло подсолнечное",
    "сыр пармезан": "Сыр пармезан",
    "творог": "Творог постный 0%",
    "молоко": "Молоко коровье 3,2%",
    "молоко 3,2": "Молоко коровье 3,2%",
    "молоко 2,5": "Молоко коровье 2,5%",
    "яйца": "Яйца куриные",
    "яйцо": "Яйца куриные",
    "филе курицы": "Филе курицы",
    "куриная грудка": "Куриная грудка",
    "филе индейки": "Филе индейки",
    "говядина": "Говядина подоскасник",
    "филе трески": "Филе трески",
    "филе семги": "Филе семги",
    "рис": "Рис круглый",
    "рис круглый": "Рис круглый",
    "макароны": "Макароны",
    "лапша": "Лапша тонкая",
    "хлеб": "Хлеб пшеничный",
    "печенье": "Печенье",
    "сметана": "Сметана 10%",
    "кефир": "Кефир 3,2%",
    "соль": "Соль",
    "перец": "Перец чёрный молотый",
    "сахар": "Сахар",
    "мед": "Мед",
}

UNIT_ALIASES: dict[str, str] = {
    "г": "g",
    "грамм": "g",
    "грамма": "g",
    "граммов": "g",
    "мл": "ml",
    "毫升": "ml",
    "кг": "kg",
    "шт": "pcs",
    "шт.": "pcs",
    "штк": "pcs",
}


def normalize_text(text: str) -> str:
    """Normalize Cyrillic/Latin text: lowercase, strip, collapse whitespace."""
    text = unicodedata.normalize("NFKC", text)
    text = text.strip().lower()
    text = re.sub(r"\s+", " ", text)
    return text


def normalize_name(text: str) -> str:
    """Normalize a product name for matching."""
    t = normalize_text(text)
    t = re.sub(r"\b\d{13}\b", "", t)  # strip GTINs
    t = re.sub(r"[,.«»\"'’]", " ", t)
    t = re.sub(r"\s+", " ", t).strip()
    return t


def parse_pack_size(pack_size: str) -> tuple[str, float]:
    """Extract (unit, value) from pack size string, e.g. '250 g' -> ('g', 250)."""
    t = normalize_text(pack_size)
    match = re.search(r"([\d.]+)\s*([a-zа-яё]*)", t)
    if not match:
        return ("", 0.0)
    value = float(match.group(1))
    unit = match.group(2)
    unit = UNIT_ALIASES.get(unit, unit)
    return (unit, value)


def normalize_brand(brand: str) -> str:
    return normalize_text(brand)


def extract_fat_percent(text: str) -> float | None:
    """Extract fat percentage from text, e.g. 'масло 72,5%' -> 72.5."""
    match = re.search(r"(\d+[.,]?\d*)\s*%", text)
    if not match:
        return None
    return float(match.group(1).replace(",", "."))


@dataclass
class SkuRecord:
    sku_id: str
    retailer_id: str
    external_id: str
    name: str
    brand: str | None
    gtin: str | None
    pack_size: str | None
    unit: str
    category: str


@dataclass
class IngredientRecord:
    ingredient_id: str
    name: str
    synonyms: list[str]
    category: str
    kcal_per_100g: float
    protein_per_100g: float
    fat_per_100g: float
    carb_per_100g: float
    fiber_per_100g: float
    density_g_per_ml: float | None
    yield_factor_cooked: float
    waste_factor: float
    allergens: list[str]
    tags: list[str]


@dataclass
class MatchResult:
    sku_id: str
    ingredient_id: str
    ingredient_name: str
    net_weight_g: float
    confidence: float
    verified_by: str = "auto"
    status: str = "matched"  # 'matched' | 'review' | 'no_match'
    reason: str = ""


class SkuMatcher:
    """Pipeline: normalize -> candidates -> classify -> auto-accept/review."""

    def __init__(self, synonym_map: dict[str, str] | None = None, auto_accept_threshold: float = AUTO_ACCEPT_THRESHOLD):
        self.synonym_map = synonym_map or SYNONYM_MAP
        self.auto_accept_threshold = auto_accept_threshold

    def match_sku(
        self, sku: SkuRecord, ingredients: Iterable[IngredientRecord]
    ) -> MatchResult | None:
        """Match a single SKU against the ingredient graph."""
        norm_name = normalize_name(sku.name)
        # Check synonym map first
        canonical = self.synonym_map.get(norm_name)
        if canonical:
            # find ingredient by canonical name
            for ing in ingredients:
                if ing.name == canonical or norm_name in [normalize_name(s) for s in ing.synonyms]:
                    return self._build_result(sku, ing, SYNONYM_CONFIDENCE, "auto")

        # Normalize and compare against each ingredient (name + synonyms)
        best_match: tuple[float, IngredientRecord] | None = None
        for ing in ingredients:
            score = self._similarity(norm_name, ing)
            if best_match is None or score > best_match[0]:
                best_match = (score, ing)

        if best_match and best_match[0] >= MIN_RETURN_THRESHOLD:
            if best_match[0] >= self.auto_accept_threshold:
                return self._build_result(sku, best_match[1], best_match[0], "auto")
            return self._build_result(sku, best_match[1], best_match[0], "review")
        return None

    def _build_result(self, sku: SkuRecord, ing: IngredientRecord, confidence: float, verified_by: str) -> MatchResult:
        # Determine net weight from pack_size if available
        unit, value = parse_pack_size(sku.pack_size or "")
        net_weight_g = value if unit in ("g", "kg") else 0.0
        if unit == "kg":
            net_weight_g = value * 1000
        # If no pack size, assume 100g default
        if net_weight_g == 0.0:
            net_weight_g = 100.0
        status = "matched" if confidence >= self.auto_accept_threshold else "review"
        return MatchResult(
            sku_id=sku.sku_id,
            ingredient_id=ing.ingredient_id,
            ingredient_name=ing.name,
            net_weight_g=net_weight_g,
            confidence=round(confidence, 4),
            verified_by=verified_by,
            status=status,
        )

    def _similarity(self, norm_name: str, ing: IngredientRecord) -> float:
        """Compute similarity score between normalized SKU name and ingredient."""
        ing_norm = normalize_name(ing.name)
        # Exact match
        if norm_name == ing_norm:
            return 1.0
        # Synonym match
        for syn in ing.synonyms:
            if normalize_name(syn) == norm_name:
                return 0.95
        # Substring / token overlap
        tokens_sku = set(norm_name.split())
        tokens_ing = set(ing_norm.split())
        if tokens_ing and tokens_sku:
            overlap = len(tokens_sku & tokens_ing) / len(tokens_ing)
            if overlap >= 0.5:
                return 0.6 + overlap * 0.3
        # Name similarity via simple Levenshtein ratio
        lev = self._levenshtein_ratio(norm_name, ing_norm)
        return lev * 0.8

    @staticmethod
    def _levenshtein_ratio(a: str, b: str) -> float:
        if not a or not b:
            return 0.0
        m, n = len(a), len(b)
        dp = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(m + 1):
            dp[i][0] = i
        for j in range(n + 1):
            dp[0][j] = j
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                cost = 0 if a[i - 1] == b[j - 1] else 1
                dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)
        return 1 - dp[m][n] / max(m, n)


def match_batch(
    skus: list[SkuRecord],
    ingredients: list[IngredientRecord],
    matcher: SkuMatcher | None = None,
) -> list[MatchResult]:
    """Match a batch of SKUs."""
    matcher = matcher or SkuMatcher()
    results: list[MatchResult] = []
    for sku in skus:
        result = matcher.match_sku(sku, ingredients)
        if result:
            results.append(result)
    return results
