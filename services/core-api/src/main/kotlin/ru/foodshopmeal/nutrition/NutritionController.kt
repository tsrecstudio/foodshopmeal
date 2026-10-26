package ru.foodshopmeal.nutrition

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1")
class NutritionController(private val service: NutritionService) {

    @GetMapping("/ingredients")
    fun listIngredients(
        @RequestParam(required = false) q: String?,
        @RequestParam(required = false) category: String?,
        @RequestParam(required = false) excludeAllergen: String?,
        @RequestParam(defaultValue = "50") limit: Int = 50,
        @RequestParam(defaultValue = "0") offset: Int = 0,
    ): List<NutritionService.IngredientRow> =
        service.listIngredients(q, category, excludeAllergen, limit, offset)

    @GetMapping("/recipes/{id}")
    fun getRecipe(
        @PathVariable id: String,
        @RequestParam(required = false) servings: Int?,
        @RequestParam(defaultValue = "false") includeOptional: Boolean = false,
    ): NutritionService.RecipeNutritionDto =
        service.getRecipe(id, servings ?: 0, includeOptional)
}
