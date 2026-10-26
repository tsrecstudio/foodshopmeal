package ru.foodshopmeal.nutrition

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import java.math.BigDecimal

/**
 * Unit tests for the deterministic nutrition calculator.
 *
 * These verify the locked-in M0 invariants:
 *   grams_gross = grams_raw / (1 - waste_factor)
 *   grams_cooked = grams_raw * yield_factor_cooked
 *   nutrients_per_100g * grams_raw / 100
 *   per_serving = total_batch / servings
 *   per_100g_cooked = total_batch / cooked_weight * 100
 */
class NutritionCalculatorTest {

    private fun ing(
        kcal: Double, p: Double, f: Double, c: Double, fiber: Double = 0.0,
        dens: Double = 0.80, yld: Double = 1.00, waste: Double = 0.0,
    ) = NutritionCalculator.IngredientNutrients(
        kcalPer100g = BigDecimal(kcal.toString()),
        proteinPer100g = BigDecimal(p.toString()),
        fatPer100g = BigDecimal(f.toString()),
        carbPer100g = BigDecimal(c.toString()),
        fiberPer100g = BigDecimal(fiber.toString()),
        densityGPerMl = BigDecimal(dens.toString()),
        yieldFactorCooked = BigDecimal(yld.toString()),
        wasteFactor = BigDecimal(waste.toString()),
    )

    private fun calc(servings: Int) = NutritionCalculator(BigDecimal(servings))

    @Test
    fun `single ingredient no waste yields per serving equals raw nutrients`() {
        // 100g of an ingredient with 100 kcal/100g, 1 serving
        val n = calc(1)
        val result = n.compute(
            listOf("test" to BigDecimal("100")),
            mapOf("test" to ing(100.0, 10.0, 5.0, 80.0)),
        )
        assertEquals(BigDecimal("100.00"), result.perServing.kcal)
        assertEquals(BigDecimal("10.00"), result.perServing.protein)
        assertEquals(BigDecimal("5.00"), result.perServing.fat)
        assertEquals(BigDecimal("80.00"), result.perServing.carb)
        assertEquals(BigDecimal("100.00"), result.rawEdibleWeightG)
        assertEquals(BigDecimal("100.00"), result.cookedWeightG)
        assertEquals(BigDecimal("100.00"), result.per100gCooked.kcal)
    }

    @Test
    fun `waste factor increases gross weight`() {
        // 100g raw with 20% waste -> gross = 100 / (1-0.2) = 125
        val n = calc(1)
        val result = n.compute(
            listOf("test" to BigDecimal("100")),
            mapOf("test" to ing(100.0, 0.0, 0.0, 0.0, waste = 0.20)),
        )
        assertEquals(BigDecimal("125.00"), result.grossPurchaseWeightG)
    }

    @Test
    fun `yield factor cooked scales cooked weight and per-100g-cooked nutrients`() {
        // 100g raw, yield 0.75 -> cooked = 75g, kcal/100g_cooked = 100 * 100 / 75 = 133.33
        val n = calc(1)
        val result = n.compute(
            listOf("test" to BigDecimal("100")),
            mapOf("test" to ing(100.0, 10.0, 5.0, 80.0, yld = 0.75)),
        )
        assertEquals(BigDecimal("75.00"), result.cookedWeightG)
        assertEquals(BigDecimal("133.33"), result.per100gCooked.kcal)
        // per serving still based on raw nutrients
        assertEquals(BigDecimal("100.00"), result.perServing.kcal)
    }

    @Test
    fun `yield factor greater than one for grains increases cooked weight and lowers per-100g-cooked kcal`() {
        // 100g dry grains, yield 2.8 -> cooked = 280g, kcal/100g_cooked = 352 * 100 / 280 = 125.71
        val n = calc(1)
        val result = n.compute(
            listOf("гречка" to BigDecimal("100")),
            mapOf("гречка" to ing(352.0, 12.4, 2.4, 67.0, yld = 2.80)),
        )
        assertEquals(BigDecimal("280.00"), result.cookedWeightG)
        assertEquals(BigDecimal("125.71"), result.per100gCooked.kcal)
    }

    @Test
    fun `multiple ingredients sum nutrients and weights`() {
        // 2 ingredients: 100g @ 100kcal + 100g @ 200kcal = 300 kcal total, 2 servings -> 150 per serving
        val n = calc(2)
        val result = n.compute(
            listOf(
                "a" to BigDecimal("100"),
                "b" to BigDecimal("100"),
            ),
            mapOf(
                "a" to ing(100.0, 10.0, 0.0, 20.0),
                "b" to ing(200.0, 20.0, 10.0, 30.0),
            ),
        )
        assertEquals(BigDecimal("150.00"), result.perServing.kcal)
        assertEquals(BigDecimal("15.00"), result.perServing.protein)
        assertEquals(BigDecimal("5.00"), result.perServing.fat)
        assertEquals(BigDecimal("25.00"), result.perServing.carb)
    }

    @Test
    fun `cooking yield preserves total batch calories`() {
        // Chicken breast 150g raw, yield 0.75 -> cooked 112.5g
        // raw kcal = 133 * 1.5 = 199.5, cooked weight 112.5
        // per 100g cooked = 199.5 * 100 / 112.5 = 177.33
        val n = calc(1)
        val result = n.compute(
            listOf("курица" to BigDecimal("150")),
            mapOf("курица" to ing(133.0, 22.9, 4.4, 0.0, yld = 0.75)),
        )
        assertEquals(BigDecimal("199.50"), result.totalBatch.kcal)
        assertEquals(BigDecimal("112.50"), result.cookedWeightG)
        assertEquals(BigDecimal("177.33"), result.per100gCooked.kcal)
    }

    @Test
    fun `rounding is HALF_UP to 2 decimal places`() {
        // 33.333 kcal should round to 33.33
        val n = calc(1)
        val result = n.compute(
            listOf("test" to BigDecimal("10")),
            mapOf("test" to ing(333.33, 0.0, 0.0, 0.0)),
        )
        assertEquals(BigDecimal("33.33"), result.perServing.kcal)
    }

    @Test
    fun `unknown ingredient raises error`() {
        val n = calc(1)
        try {
            n.compute(
                listOf("missing" to BigDecimal("100")),
                mapOf("test" to ing(100.0, 0.0, 0.0, 0.0)),
            )
            assertTrue(false, "Expected IllegalArgumentException")
        } catch (e: IllegalArgumentException) {
            assertTrue(e.message!!.contains("Unknown ingredient"))
        }
    }

    @Test
    fun `density is available for volume conversion`() {
        // density 0.92 g/ml -> 100g = 108.7 ml
        val ing = ing(0.0, 0.0, 0.0, 0.0, dens = 0.92)
        assertEquals(BigDecimal("0.92"), ing.densityGPerMl)
    }
}
