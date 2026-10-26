package ru.foodshopmeal.nutrition

import java.math.BigDecimal
import java.math.RoundingMode

/**
 * Deterministic nutrition calculator for the ingredient graph.
 *
 * Locked invariants (M0):
 *   * nutrients_per_100g are per 100 g of edible raw portion;
 *   * grams_gross  = grams_raw / (1 - waste_factor)   (purchase weight incl. waste)
 *   * grams_cooked = grams_raw * yield_factor_cooked  (weight after cooking)
 *   * recipe nutrients are NEVER stored — always derived from ingredients here.
 *
 * All arithmetic uses BigDecimal with HALF_UP rounding to 2 decimal places.
 */
class NutritionCalculator(private val scale: BigDecimal) {

    companion object {
        const val SCALE_DIVISIONS = 100
        const val ROUNDING_MODE = RoundingMode.HALF_UP
        const val ROUNDING_SCALE = 2

        fun round(value: BigDecimal): BigDecimal =
            value.setScale(ROUNDING_SCALE, ROUNDING_MODE)
    }

    data class IngredientNutrients(
        val kcalPer100g: BigDecimal,
        val proteinPer100g: BigDecimal,
        val fatPer100g: BigDecimal,
        val carbPer100g: BigDecimal,
        val fiberPer100g: BigDecimal,
        val densityGPerMl: BigDecimal,
        val yieldFactorCooked: BigDecimal,
        val wasteFactor: BigDecimal,
    )

    data class RawComponent(
        val ingredientName: String,
        val gramsRaw: BigDecimal,
        val gramsGross: BigDecimal,
        val gramsCooked: BigDecimal,
        val nutrients: NutrientsBatch,
    )

    data class NutrientsBatch(
        val kcal: BigDecimal,
        val protein: BigDecimal,
        val fat: BigDecimal,
        val carb: BigDecimal,
        val fiber: BigDecimal,
    )

    data class RecipeNutrition(
        val totalBatch: NutrientsBatch,
        val rawEdibleWeightG: BigDecimal,
        val grossPurchaseWeightG: BigDecimal,
        val cookedWeightG: BigDecimal,
        val perServing: NutrientsBatch,
        val per100gCooked: NutrientsBatch,
        val components: List<RawComponent>,
    )

    fun compute(
        components: List<Pair<String, BigDecimal>>,
        ingredients: Map<String, IngredientNutrients>,
    ): RecipeNutrition {
        var totalKcal = BigDecimal.ZERO
        var totalProtein = BigDecimal.ZERO
        var totalFat = BigDecimal.ZERO
        var totalCarb = BigDecimal.ZERO
        var totalFiber = BigDecimal.ZERO
        var totalRaw = BigDecimal.ZERO
        var totalGross = BigDecimal.ZERO
        var totalCooked = BigDecimal.ZERO
        val computedComponents = mutableListOf<RawComponent>()

        for ((name, baseGrams) in components) {
            val ing = ingredients[name] ?: error("Unknown ingredient: $name")
            val gramsRaw = baseGrams * scale
            val gramsGross = gramsRaw / (BigDecimal.ONE - ing.wasteFactor)
            val gramsCooked = gramsRaw * ing.yieldFactorCooked

            val factor = gramsRaw / BigDecimal(SCALE_DIVISIONS)
            val n = NutrientsBatch(
                kcal = factor * ing.kcalPer100g,
                protein = factor * ing.proteinPer100g,
                fat = factor * ing.fatPer100g,
                carb = factor * ing.carbPer100g,
                fiber = factor * ing.fiberPer100g,
            )

            totalKcal += n.kcal
            totalProtein += n.protein
            totalFat += n.fat
            totalCarb += n.carb
            totalFiber += n.fiber
            totalRaw += gramsRaw
            totalGross += gramsGross
            totalCooked += gramsCooked

            computedComponents.add(
                RawComponent(
                    ingredientName = name,
                    gramsRaw = round(gramsRaw),
                    gramsGross = round(gramsGross),
                    gramsCooked = round(gramsCooked),
                    nutrients = n,
                )
            )
        }

        val perServing = NutrientsBatch(
            kcal = round(totalKcal / scale),
            protein = round(totalProtein / scale),
            fat = round(totalFat / scale),
            carb = round(totalCarb / scale),
            fiber = round(totalFiber / scale),
        )

        val cookedWeightFor100g = if (totalCooked > BigDecimal.ZERO) totalCooked else BigDecimal.ONE
        val per100gCooked = NutrientsBatch(
            kcal = round(totalKcal * BigDecimal(SCALE_DIVISIONS) / cookedWeightFor100g),
            protein = round(totalProtein * BigDecimal(SCALE_DIVISIONS) / cookedWeightFor100g),
            fat = round(totalFat * BigDecimal(SCALE_DIVISIONS) / cookedWeightFor100g),
            carb = round(totalCarb * BigDecimal(SCALE_DIVISIONS) / cookedWeightFor100g),
            fiber = round(totalFiber * BigDecimal(SCALE_DIVISIONS) / cookedWeightFor100g),
        )

        return RecipeNutrition(
            totalBatch = NutrientsBatch(
                kcal = round(totalKcal),
                protein = round(totalProtein),
                fat = round(totalFat),
                carb = round(totalCarb),
                fiber = round(totalFiber),
            ),
            rawEdibleWeightG = round(totalRaw),
            grossPurchaseWeightG = round(totalGross),
            cookedWeightG = round(totalCooked),
            perServing = perServing,
            per100gCooked = per100gCooked,
            components = computedComponents,
        )
    }
}
