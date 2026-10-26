package ru.foodshopmeal.reconciliation

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.math.BigDecimal
import java.time.LocalDate

/**
 * M6: Pantry — track leftover ingredients, feed into next plan optimization.
 */
@Service
class PantryService(private val jdbc: JdbcTemplate) {

    data class PantryItemDto(
        val ingredientId: String,
        val grams: BigDecimal,
        val expiresAt: LocalDate?,
    )

    fun getPantry(userId: String): List<PantryItemDto> {
        return jdbc.query(
            """SELECT ingredient_id, grams, expires_at FROM core.pantry_items
               WHERE user_id = ?::uuid AND grams > 0""",
            { rs, _ ->
                PantryItemDto(
                    ingredientId = rs.getString("ingredient_id").toString(),
                    grams = rs.getBigDecimal("grams"),
                    expiresAt = rs.getObject("expires_at", LocalDate::class.java),
                )
            }, userId
        )
    }

    fun addIngredient(userId: String, ingredientId: String, grams: BigDecimal, expiresAt: LocalDate?) {
        jdbc.update(
            """INSERT INTO core.pantry_items (id, user_id, ingredient_id, grams, expires_at)
               VALUES (gen_random_uuid(), ?::uuid, ?::uuid, ?, ?)
               ON CONFLICT (user_id, ingredient_id) DO UPDATE SET
                   grams = core.pantry_items.grams + EXCLUDED.grams,
                   expires_at = COALESCE(core.pantry_items.expires_at, EXCLUDED.expires_at)""",
            userId, ingredientId, grams, expiresAt
        )
    }

    fun useIngredient(userId: String, ingredientId: String, grams: BigDecimal) {
        jdbc.update(
            """UPDATE core.pantry_items SET grams = GREATEST(grams - ?, 0)
               WHERE user_id = ?::uuid AND ingredient_id = ?::uuid""",
            grams, userId, ingredientId
        )
    }

    fun removeExpired(userId: String) {
        jdbc.update(
            "DELETE FROM core.pantry_items WHERE user_id = ?::uuid AND expires_at < CURRENT_DATE",
            userId
        )
    }
}
