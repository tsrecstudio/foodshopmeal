package ru.foodshopmeal.integration.kuper

import org.springframework.stereotype.Component
import ru.foodshopmeal.domain.port.DegradationLevel
import ru.foodshopmeal.domain.port.RetailerAdapter
import ru.foodshopmeal.domain.port.RetailerCapability

/**
 * L3 Kuper Fulfillment Adapter skeleton (gated behind `retailer.kuper.enabled` feature flag).
 *
 * Full Anti-Corruption Layer, OAuth2 client_credentials token caching, price revalidation,
 * idempotent order placement, and mock/sandbox wiring are implemented in Stage M5.
 *
 * TODO(M5-kuper-contract): Confirm exact Kuper Fulfillment API payload schemas for:
 *  1) per-line substitution policy granularity & allowed SKU whitelist;
 *  2) actual-composition & actual-weight fields in delivery status webhooks;
 *  3) Catalog feed vs API source (GTIN / net_weight).
 */
@Component
class KuperAdapterStub : RetailerAdapter {
    override val retailerCode: String = RETAILER_CODE
    override val degradationLevel: DegradationLevel = DegradationLevel.L3

    override fun capabilities(): Set<RetailerCapability> =
        setOf(
            RetailerCapability.READ_CATALOG,
            RetailerCapability.CHECK_STOCK,
            RetailerCapability.DELIVERY_ZONES,
            RetailerCapability.FILL_CART,
            RetailerCapability.CHECKOUT,
        )

    companion object {
        const val RETAILER_CODE: String = "kuper"
        const val FEATURE_FLAG_KEY: String = "retailer.kuper.enabled"
    }
}
