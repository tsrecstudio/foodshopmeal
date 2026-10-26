package ru.foodshopmeal.domain.port

/**
 * Capabilities declared by a retailer integration adapter.
 * Domain Core interacts ONLY with this port — partner DTOs never cross the Anti-Corruption Layer.
 */
enum class RetailerCapability {
    READ_CATALOG,
    CHECK_STOCK,
    DELIVERY_ZONES,
    FILL_CART,
    CHECKOUT,
}

interface RetailerAdapter {
    val retailerCode: String
    val degradationLevel: DegradationLevel

    fun capabilities(): Set<RetailerCapability>
}
