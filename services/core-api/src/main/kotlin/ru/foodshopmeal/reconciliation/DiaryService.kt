package ru.foodshopmeal.reconciliation

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.math.BigDecimal
import java.time.LocalDate

/**
 * M6: Diary — checkbox diary, off-plan rebalance, weekly summary.
 */
@Service
class DiaryService(private val jdbc: JdbcTemplate) {

    data class DiaryEntryDto(
        val id: String,
        val date: LocalDate,
        val meal: String,
        val source: String,
        val kcal: BigDecimal,
        val protein: BigDecimal,
        val fat: BigDecimal,
        val carb: BigDecimal,
    )

    fun getEntries(userId: String, from: LocalDate?, to: LocalDate?): List<DiaryEntryDto> {
        val params = mutableListOf<Any>(userId)
        val conditions = mutableListOf<String>()
        if (from != null) { conditions.add("date >= ?"); params.add(from) }
        if (to != null) { conditions.add("date <= ?"); params.add(to) }
        val where = if (conditions.isEmpty()) "" else "WHERE " + conditions.joinToString(" AND ")
        return jdbc.query(
            """SELECT id, date, meal, source, kcal, protein, fat, carb
               FROM core.diary_entries $where AND user_id = ?::uuid ORDER BY date, meal""",
            { rs, _ ->
                DiaryEntryDto(
                    id = rs.getString("id").toString(),
                    date = rs.getObject("date", LocalDate::class.java),
                    meal = rs.getString("meal"),
                    source = rs.getString("source"),
                    kcal = rs.getBigDecimal("kcal"),
                    protein = rs.getBigDecimal("protein"),
                    fat = rs.getBigDecimal("fat"),
                    carb = rs.getBigDecimal("carb"),
                )
            }, *params.toTypedArray()
        )
    }

    fun addEntry(
        userId: String, date: LocalDate, meal: String, source: String,
        kcal: BigDecimal, protein: BigDecimal, fat: BigDecimal, carb: BigDecimal,
    ) {
        jdbc.update(
            """INSERT INTO core.diary_entries (id, user_id, date, meal, source, kcal, protein, fat, carb)
               VALUES (gen_random_uuid(), ?::uuid, ?, ?, ?, ?, ?, ?, ?)
               ON CONFLICT (user_id, date, meal, source) DO UPDATE SET
                   kcal = EXCLUDED.kcal, protein = EXCLUDED.protein,
                   fat = EXCLUDED.fat, carb = EXCLUDED.carb""",
            userId, date, meal, source, kcal, protein, fat, carb
        )
    }

    fun getWeeklySummary(userId: String, weekStart: LocalDate): Map<String, BigDecimal> {
        val result = jdbc.queryForMap(
            """SELECT COALESCE(SUM(kcal), 0) as kcal, COALESCE(SUM(protein), 0) as protein,
                   COALESCE(SUM(fat), 0) as fat, COALESCE(SUM(carb), 0) as carb
               FROM core.diary_entries
               WHERE user_id = ?::uuid AND date >= ? AND date < ? + INTERVAL '7 days'""",
            userId, weekStart
        )
        return mapOf(
            "kcal" to (result["kcal"] as BigDecimal),
            "protein" to (result["protein"] as BigDecimal),
            "fat" to (result["fat"] as BigDecimal),
            "carb" to (result["carb"] as BigDecimal),
        )
    }
}
