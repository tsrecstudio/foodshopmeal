package ru.foodshopmeal.billing

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import java.math.BigDecimal

class BillingServiceTest {
    private val billing = BillingService(org.springframework.jdbc.core.JdbcTemplate())

    @Test
    fun `plans include free pro and premium`() {
        val codes = billing.getPlans().map { it.code }
        assertEquals(listOf("free", "pro", "premium"), codes)
    }

    @Test
    fun `pro plan price is 990`() {
        val pro = billing.getPlans().find { it.code == "pro" }
        assertNotNull(pro)
        assertEquals(BigDecimal("990"), pro.priceMonthly)
    }

    @Test
    fun `subscribe creates active subscription`() {
        val sub = billing.subscribe("user-1", "pro")
        assertEquals("pro", sub.planCode)
        assertEquals("active", sub.status)
    }

    @Test
    fun `cancel returns free plan`() {
        val sub = billing.cancel("user-1")
        assertEquals("free", sub.planCode)
        assertEquals("cancelled", sub.status)
    }

    @Test
    fun `experiments have variants`() {
        val exp = ExperimentService(org.springframework.jdbc.core.JdbcTemplate())
        val experiments = exp.getExperiments()
        assertTrue(experiments.all { it.variants.size >= 2 })
    }

    private fun assertTrue(cond: Boolean) = org.junit.jupiter.api.Assertions.assertTrue(cond)
}
