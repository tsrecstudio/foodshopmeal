package ru.foodshopmeal.reconciliation

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.math.BigDecimal
import java.time.LocalDate

/**
 * M6: Reconciliation — delivery fact webhook -> week KBZHU recalculation -> notification -> re-optimization.
 */
@Service
class ReconciliationService(private val jdbc: JdbcTemplate) {

    data class DeliveryFactDto(
        val orderId: String,
        val skuId: String,
        val actualSkuId: String?,
        val actualWeightG: BigDecimal?,
    )

    data class ReconciliationResult(
        val orderId: String,
        val weekStart: LocalDate,
        val plannedKcal: BigDecimal,
        val actualKcal: BigDecimal,
        val deviationPct: BigDecimal,
        val needsReoptimization: Boolean,
    )

    fun processDeliveryFact(orderId: String, fact: DeliveryFactDto): ReconciliationResult {
        // 1. Insert delivery fact
        jdbc.update(
            """INSERT INTO fulfillment.delivery_facts (order_id, sku_id, actual_sku_id, actual_weight_g)
               VALUES (?::uuid, ?::uuid, ?::uuid, ?)""",
            orderId, fact.skuId, fact.actualSkuId, fact.actualWeightG?.toDouble()
        )

        // 2. Mark webhook as processed
        jdbc.update(
            "UPDATE fulfillment.webhook_events SET processed = TRUE, processed_at = now() WHERE order_id = ?::uuid",
            orderId
        )

        // 3. Calculate actual week KCAL (simplified: sum of delivery facts)
        val actualKcal = jdbc.queryForObject(
            """SELECT COALESCE(SUM(actual_weight_g * kcal_per_100g / 100), 0)
               FROM fulfillment.delivery_facts df
               JOIN catalog.sku_ingredient_links sil ON sil.sku_id = df.sku_id
               JOIN core.ingredients i ON i.id = sil.ingredient_id
               WHERE df.order_id = ?::uuid""",
            BigDecimal::class.java, orderId
        ) ?: BigDecimal.ZERO

        // 4. Get planned KCAL from diary
        val plannedKcal = jdbc.queryForObject(
            """SELECT COALESCE(SUM(kcal), 0) FROM core.diary_entries
               WHERE user_id = (SELECT user_id FROM fulfillment.orders WHERE id = ?::uuid)
                 AND date >= date_trunc('week', CURRENT_DATE)""",
            BigDecimal::class.java, orderId
        ) ?: BigDecimal.ZERO

        val deviation = if (plannedKcal > BigDecimal.ZERO) {
            (actualKcal - plannedKcal) / plannedKcal * BigDecimal(100)
        } else {
            BigDecimal.ZERO
        }

        // 5. Store reconciliation summary
        jdbc.update(
            """INSERT INTO core.reconciliation_summaries (id, user_id, week_start, planned_kcal, actual_kcal, deviation_pct)
               SELECT gen_random_uuid(), user_id, date_trunc('week', CURRENT_DATE)::date, ?, ?, ?
               FROM fulfillment.orders WHERE id = ?::uuid
               ON CONFLICT (user_id, week_start) DO UPDATE SET
                   planned_kcal = EXCLUDED.planned_kcal,
                   actual_kcal = EXCLUDED.actual_kcal,
                   deviation_pct = EXCLUDED.deviation_pct""",
            plannedKcal, actualKcal, deviation, orderId
        )

        return ReconciliationResult(
            orderId = orderId,
            weekStart = LocalDate.now().withDayOfMonth(1),  // simplified: month start
            plannedKcal = plannedKcal,
            actualKcal = actualKcal,
            deviationPct = deviation.setScale(2, java.math.RoundingMode.HALF_UP),
            needsReoptimization = deviation.abs() > BigDecimal("15.0"),  // >15% deviation
        )
    }
}
