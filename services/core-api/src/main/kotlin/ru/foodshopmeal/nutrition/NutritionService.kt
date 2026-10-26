package ru.foodshopmeal.nutrition

import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.math.BigDecimal

/**
 * M1 nutrition service: loads ingredients/recipes from PostgreSQL and
 * delegates all nutrients computation to NutritionCalculator.
 */
@Service
class NutritionService(
    private val jdbc: JdbcTemplate,
    private val objectMapper: ObjectMapper,
) {

    data class IngredientRow(
        val id: String,
        val name: String,
        val category: String,
        val kcalPer100g: BigDecimal,
        val proteinPer100g: BigDecimal,
        val fatPer100g: BigDecimal,
        val carbPer100g: BigDecimal,
        val fiberPer100g: BigDecimal,
        val densityGPerMl: BigDecimal,
        val yieldFactorCooked: BigDecimal,
        val wasteFactor: BigDecimal,
        val allergens: List<String>,
        val tags: List<String>,
    )

    data class RecipeIngredientRow(
        val ingredientName: String,
        val gramsRaw: BigDecimal,
        val optional: Boolean,
        val substitutionGroup: String?,
        val ingredientAllergens: List<String>,
    )

    data class StepDto(val stepNo: Int, val text: String, val timerSec: Int)

    data class RecipeIngredientDto(
        val ingredientName: String,
        val optional: Boolean,
        val substitutionGroup: String?,
        val gramsRaw: BigDecimal,
        val gramsGross: BigDecimal,
        val gramsCooked: BigDecimal,
    )

    data class RecipeNutritionDto(
        val id: String,
        val title: String,
        val timeMin: Int,
        val difficulty: String,
        val equipment: List<String>,
        val baseServings: Int,
        val requestedServings: BigDecimal,
        val tags: List<String>,
        val allergens: List<String>,
        val nutrition: NutritionCalculator.RecipeNutrition,
        val ingredients: List<RecipeIngredientDto>,
        val steps: List<StepDto>,
    )

    fun listIngredients(
        query: String?,
        category: String?,
        excludeAllergen: String?,
        limit: Int,
        offset: Int,
    ): List<IngredientRow> {
        val sql = buildString {
            append("SELECT id, name, category, kcal_per_100g, protein_per_100g, fat_per_100g, ")
            append("carb_per_100g, fiber_per_100g, density_g_per_ml, yield_factor_cooked, ")
            append("waste_factor, allergens, tags FROM core.ingredients WHERE 1=1")
            if (!query.isNullOrBlank()) append(" AND lower(name) LIKE lower(?)")
            if (!category.isNullOrBlank()) append(" AND category = ?")
            if (!excludeAllergen.isNullOrBlank()) append(" AND NOT @> ARRAY[?]::text[]")
            append(" ORDER BY name LIMIT ? OFFSET ?")
        }
        val args = mutableListOf<Any>()
        if (!query.isNullOrBlank()) args.add("%$query%")
        if (!category.isNullOrBlank()) args.add(category)
        if (!excludeAllergen.isNullOrBlank()) args.add(excludeAllergen)
        args.add(limit); args.add(offset)
        return jdbc.query(sql, args.toTypedArray()) { rs, _ ->
            IngredientRow(
                id = rs.getString("id").toString(),
                name = rs.getString("name"),
                category = rs.getString("category"),
                kcalPer100g = rs.getBigDecimal("kcal_per_100g"),
                proteinPer100g = rs.getBigDecimal("protein_per_100g"),
                fatPer100g = rs.getBigDecimal("fat_per_100g"),
                carbPer100g = rs.getBigDecimal("carb_per_100g"),
                fiberPer100g = rs.getBigDecimal("fiber_per_100g"),
                densityGPerMl = rs.getBigDecimal("density_g_per_ml"),
                yieldFactorCooked = rs.getBigDecimal("yield_factor_cooked"),
                wasteFactor = rs.getBigDecimal("waste_factor"),
                allergens = rs.getArray("allergens")?.array?.map { it.toString() } ?: emptyList(),
                tags = rs.getArray("tags")?.array?.map { it.toString() } ?: emptyList(),
            )
        }
    }

    fun getRecipe(recipeId: String, servings: Int, includeOptional: Boolean): RecipeNutritionDto {
        val recipe = jdbc.queryForMap(
            "SELECT id, title, steps, time_min, equipment, servings, tags, difficulty FROM core.recipes WHERE id = ?::uuid",
            recipeId,
        )
        val title = recipe["title"] as String
        val baseServings = (recipe["servings"] as java.math.BigDecimal).toInt()
        val targetServings = if (servings > 0) servings else baseServings
        val scale = BigDecimal(targetServings) / BigDecimal(baseServings)

        // recipe ingredients with allergens
        val ingRows = jdbc.query(
            """
            SELECT i.name, ri.grams_raw, ri.optional, ri.substitution_group, i.allergens
            FROM core.recipe_ingredients ri
            JOIN core.ingredients i ON i.id = ri.ingredient_id
            WHERE ri.recipe_id = ?::uuid
            ORDER BY ri.ingredient_id
            """.trimIndent(),
            recipeId,
        ) { rs, _ ->
            RecipeIngredientRow(
                ingredientName = rs.getString("name"),
                gramsRaw = rs.getBigDecimal("grams_raw"),
                optional = rs.getBoolean("optional"),
                substitutionGroup = rs.getString("substitution_group"),
                ingredientAllergens = rs.getArray("allergens")?.array?.map { it.toString() } ?: emptyList(),
            )
        }

        // load all ingredient nutrients (map by name)
        val ingredientMap = jdbc.query(
            "SELECT name, kcal_per_100g, protein_per_100g, fat_per_100g, carb_per_100g, " +
                "fiber_per_100g, density_g_per_ml, yield_factor_cooked, waste_factor FROM core.ingredients",
        ) { rs, _ ->
            val name = rs.getString("name")
            name to NutritionCalculator.IngredientNutrients(
                kcalPer100g = rs.getBigDecimal("kcal_per_100g"),
                proteinPer100g = rs.getBigDecimal("protein_per_100g"),
                fatPer100g = rs.getBigDecimal("fat_per_100g"),
                carbPer100g = rs.getBigDecimal("carb_per_100g"),
                fiberPer100g = rs.getBigDecimal("fiber_per_100g"),
                densityGPerMl = rs.getBigDecimal("density_g_per_ml"),
                yieldFactorCooked = rs.getBigDecimal("yield_factor_cooked"),
                wasteFactor = rs.getBigDecimal("waste_factor"),
            )
        }.toMap()

        val activeIngs = ingRows.filter { includeOptional || !it.optional }
        val components = activeIngs.map { it.ingredientName to it.gramsRaw }
        val calc = NutritionCalculator(scale)
        val nutrition = calc.compute(components, ingredientMap)

        // parse steps jsonb
        val stepsJson = recipe["steps"] as com.postgresql.util.PGobject
        val stepsArray = objectMapper.readTree(stepsJson.value)
        val steps = stepsArray.map { node ->
            StepDto(
                stepNo = node["stepNo"]?.asInt() ?: 0,
                text = node["text"]?.asText() ?: "",
                timerSec = node["timerSec"]?.asInt() ?: 0,
            )
        }

        val allergens = activeIngs.flatMap { it.ingredientAllergens }.distinct()
        val equipment = (recipe["equipment"] as java.sql.Array)?.array?.map { it.toString() } ?: emptyList()
        val tags = (recipe["tags"] as java.sql.Array)?.array?.map { it.toString() } ?: emptyList()

        return RecipeNutritionDto(
            id = recipeId,
            title = title,
            timeMin = (recipe["time_min"] as java.math.BigDecimal).toInt(),
            difficulty = recipe["difficulty"] as String,
            equipment = equipment,
            baseServings = baseServings,
            requestedServings = scale,
            tags = tags,
            allergens = allergens,
            nutrition = nutrition,
            ingredients = activeIngs.map {
                val comp = nutrition.components.first { c -> c.ingredientName == it.ingredientName }
                RecipeIngredientDto(
                    ingredientName = it.ingredientName,
                    optional = it.optional,
                    substitutionGroup = it.substitutionGroup,
                    gramsRaw = comp.gramsRaw,
                    gramsGross = comp.gramsGross,
                    gramsCooked = comp.gramsCooked,
                )
            },
            steps = steps,
        )
    }
}
