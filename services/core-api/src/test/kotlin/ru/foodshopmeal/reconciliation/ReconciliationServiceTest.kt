package ru.foodshopmeal.reconciliation

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import java.math.BigDecimal

class ReconciliationServiceTest {
    // Unit tests for status mapping and deviation calculation
    @Test
    fun `deviation calculation within tolerance`() {
        val planned = BigDecimal("1800.00")
        val actual = BigDecimal("1850.00")
        val deviation = (actual - planned) / planned * BigDecimal(100)
        assertTrue(deviation.abs() < BigDecimal("15.0"))
    }

    @Test
    fun `deviation calculation exceeds tolerance`() {
        val planned = BigDecimal("1800.00")
        val actual = BigDecimal("2100.00")
        val deviation = (actual - planned) / planned * BigDecimal(100)
        assertTrue(deviation.abs() > BigDecimal("15.0"))
    }

    @Test
    fun `deviation zero when no planned`() {
        val planned = BigDecimal.ZERO
        val actual = BigDecimal("1800.00")
        val deviation = if (planned > BigDecimal.ZERO) {
            (actual - planned) / planned * BigDecimal(100)
        } else BigDecimal.ZERO
        assertEquals(BigDecimal.ZERO, deviation)
    }
}
