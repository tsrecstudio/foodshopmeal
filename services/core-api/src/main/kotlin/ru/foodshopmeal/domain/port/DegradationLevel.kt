package ru.foodshopmeal.domain.port

/**
 * Product degradation tiers:
 * - L1: Catalog + prices -> smart shopping list (always available, zero partner contracts required)
 * - L2: + remote cart filling
 * - L3: + full checkout, delivery slots, and actual-composition webhooks
 */
enum class DegradationLevel {
    L1,
    L2,
    L3,
}
