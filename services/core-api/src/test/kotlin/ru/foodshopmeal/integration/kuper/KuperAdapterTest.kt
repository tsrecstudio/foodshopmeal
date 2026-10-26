package ru.foodshopmeal.integration.kuper

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

class KuperAdapterTest {

    private val adapter = KuperAdapter()

    @Test
    fun `token cache returns same token within expiry`() {
        val t1 = adapter.getAccessToken("client", "secret")
        val t2 = adapter.getAccessToken("client", "secret")
        assertEquals(t1, t2)
        assertNotNull(t1)
    }

    @Test
    fun `place order returns accepted order`() {
        val cart = KuperAdapter.KuperCart(
            storeId = "store-1",
            lines = listOf(KuperAdapter.KuperCartLine("sku-1", 2, "g")),
            totalRub = 300.0,
        )
        val order = adapter.placeOrder("client", "secret", KuperAdapter.KuperOrderRequest(cart, "slot-1", "idem-key-1"))
        assertEquals(KuperAdapter.OrderState.Accepted, order.state)
        assertTrue(order.externalOrderId.isNotEmpty())
    }

    @Test
    fun `status mapping maps kuper statuses`() {
        assertEquals(KuperAdapter.OrderState.Created, adapter.mapStatus("created"))
        assertEquals(KuperAdapter.OrderState.Accepted, adapter.mapStatus("accepted"))
        assertEquals(KuperAdapter.OrderState.InProgress, adapter.mapStatus("in_progress"))
        assertEquals(KuperAdapter.OrderState.InProgress, adapter.mapStatus("preparing"))
        assertEquals(KuperAdapter.OrderState.InProgress, adapter.mapStatus("on_way"))
        assertEquals(KuperAdapter.OrderState.Delivered, adapter.mapStatus("delivered"))
        assertEquals(KuperAdapter.OrderState.Delivered, adapter.mapStatus("completed"))
        assertEquals(KuperAdapter.OrderState.Cancelled, adapter.mapStatus("cancelled"))
        assertEquals(KuperAdapter.OrderState.Cancelled, adapter.mapStatus("canceled"))
        assertEquals(KuperAdapter.OrderState.Failed, adapter.mapStatus("unknown"))
    }

    @Test
    fun `webhook handling extracts status`() {
        val state = adapter.handleWebhook(mapOf("status" to "delivered"))
        assertEquals(KuperAdapter.OrderState.Delivered, state)
    }

    @Test
    fun `capabilities include all L3 capabilities`() {
        val caps = adapter.capabilities()
        assertTrue(caps.contains(ru.foodshopmeal.domain.port.RetailerCapability.READ_CATALOG))
        assertTrue(caps.contains(ru.foodshopmeal.domain.port.RetailerCapability.CHECK_STOCK))
        assertTrue(caps.contains(ru.foodshopmeal.domain.port.RetailerCapability.DELIVERY_ZONES))
        assertTrue(caps.contains(ru.foodshopmeal.domain.port.RetailerCapability.FILL_CART))
        assertTrue(caps.contains(ru.foodshopmeal.domain.port.RetailerCapability.CHECKOUT))
    }
}
