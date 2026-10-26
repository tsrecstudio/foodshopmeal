package ru.foodshopmeal.integration.kuper

import org.springframework.stereotype.Component
import ru.foodshopmeal.domain.port.DegradationLevel
import ru.foodshopmeal.domain.port.RetailerAdapter
import ru.foodshopmeal.domain.port.RetailerCapability

/**
 * M5: Kuper Fulfillment Adapter (L3) — behind feature flag `retailer.kuper.enabled`.
 *
 * Implements:
 *  - OAuth2 client_credentials with in-memory token cache (Redis in prod)
 *  - Order idempotency via Idempotency-Key header
 *  - Pre-checkout price revalidation (compare cart total vs catalog price)
 *  - Anti-Corruption Layer: Kuper DTOs never leak into Domain Core
 *  - Status mapping: Kuper status -> internal OrderState
 *
 * For MVP: uses mock HTTP client. Real HTTP client wired in production.
 */
@Component
class KuperAdapter : RetailerAdapter {

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

    // ---- Anti-Corruption Layer: Kuper DTOs ----
    data class KuperCartLine(
        val skuId: String,
        val quantity: Int,
        val unit: String,
    )

    data class KuperCart(
        val storeId: String,
        val lines: List<KuperCartLine>,
        val totalRub: Double,
    )

    data class KuperOrderRequest(
        val cart: KuperCart,
        val slotId: String,
        val idempotencyKey: String,
    )

    data class KuperOrderResponse(
        val externalOrderId: String,
        val status: String,
        val totalRub: Double,
    )

    data class KuperTokenResponse(
        val accessToken: String,
        val expiresIn: Int,
    )

    // ---- Internal domain types (never leak Kuper DTOs) ----
    sealed class OrderState {
        object Created : OrderState()
        object Accepted : OrderState()
        object InProgress : OrderState()
        object Delivered : OrderState()
        object Cancelled : OrderState()
        object Failed : OrderState()
    }

    data class PlacedOrder(
        val orderId: String,
        val externalOrderId: String,
        val state: OrderState,
        val totalRub: Double,
    )

    // ---- Token cache ----
    private var tokenCache: KuperTokenResponse? = null
    private var tokenExpiresAt: Long = 0

    @Synchronized
    fun getAccessToken(clientId: String, clientSecret: String): String {
        val now = System.currentTimeMillis()
        if (tokenCache != null && now < tokenExpiresAt - 60_000) {
            return tokenCache!!.accessToken
        }
        // TODO(M5-kuper-contract): Replace mock with real OAuth2 request
        // POST https://api.kuper.ru/oauth/token
        // grant_type=client_credentials&client_id=...&client_secret=...
        val mockToken = "kuper-mock-token-${System.currentTimeMillis()}"
        tokenCache = KuperTokenResponse(mockToken, 3600)
        tokenExpiresAt = now + 3600_000L
        return mockToken
    }

    // ---- Idempotent order placement ----
    @Synchronized
    fun placeOrder(clientId: String, clientSecret: String, request: KuperOrderRequest): PlacedOrder {
        val token = getAccessToken(clientId, clientSecret)
        // TODO(M5-kuper-contract): Real HTTP call with Idempotency-Key header
        // POST https://api.kuper.ru/fulfillment/orders
        // Headers: Authorization: Bearer $token, Idempotency-Key: ${request.idempotencyKey}
        val externalOrderId = "kuper-${request.idempotencyKey.hashCode()}"
        return PlacedOrder(
            orderId = externalOrderId,
            externalOrderId = externalOrderId,
            state = OrderState.Accepted,
            totalRub = request.cart.totalRub,
        )
    }

    // ---- Pre-checkout price revalidation ----
    fun revalidatePrices(
        clientId: String,
        clientSecret: String,
        cart: KuperCart,
        expectedPrices: Map<String, Double>,
    ): Boolean {
        // TODO(M5-kuper-contract): Fetch current prices from Kuper catalog API
        // and compare with expectedPrices. Return false if any price differs by >5%.
        return expectedPrices.all { (skuId, expected) ->
            val actual = expected  // mock: assume prices match
            abs(actual - expected) <= expected * 0.05
        }
    }

    // ---- Status mapping ----
    fun mapStatus(kuperStatus: String): OrderState =
        when (kuperStatus.lowercase()) {
            "created" -> OrderState.Created
            "accepted" -> OrderState.Accepted
            "in_progress", "preparing", "on_way" -> OrderState.InProgress
            "delivered", "completed" -> OrderState.Delivered
            "cancelled", "canceled" -> OrderState.Cancelled
            else -> OrderState.Failed
        }

    // ---- Webhook handling ----
    fun handleWebhook(payload: Map<String, Any>): OrderState {
        val status = (payload["status"] as? String) ?: return OrderState.Failed
        return mapStatus(status)
    }

    companion object {
        const val RETAILER_CODE: String = "kuper"
        const val FEATURE_FLAG_KEY: String = "retailer.kuper.enabled"
    }
}
