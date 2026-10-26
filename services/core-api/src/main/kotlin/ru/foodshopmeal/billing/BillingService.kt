package ru.foodshopmeal.billing

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.math.BigDecimal
import java.time.LocalDate

/**
 * M8: Subscription billing, analytics, A/B testing.
 */
@Service
class BillingService(private val jdbc: JdbcTemplate) {

    data class Plan(
        val code: String,
        val name: String,
        val priceMonthly: BigDecimal,
        val features: List<String>,
    )

    data class Subscription(
        val userId: String,
        val planCode: String,
        val status: String,
        val currentPeriodEnd: LocalDate,
    )

    val plans: List<Plan> = listOf(
        Plan("free", "Free", BigDecimal("0"), listOf("7-дневный план", "L1 список покупок")),
        Plan("pro", "Pro", BigDecimal("990"), listOf("Все опции", "L3 оплата", "Substitution engine")),
        Plan("premium", "Premium", BigDecimal("1990"), listOf("Всё из Pro", "Аналитика", "A/B тестинг")),
    )

    fun getPlans(): List<Plan> = plans

    fun subscribe(userId: String, planCode: String): Subscription {
        val plan = plans.find { it.code == planCode } ?: error("Unknown plan: $planCode")
        val periodEnd = LocalDate.now().plusMonths(1)
        return Subscription(userId, planCode, "active", periodEnd)
    }

    fun cancel(userId: String): Subscription {
        return Subscription(userId, "free", "cancelled", LocalDate.now())
    }
}

@Service
class AnalyticsService(private val jdbc: JdbcTemplate) {

    fun getWeeklyStats(userId: String, weekStart: LocalDate): Map<String, Any> {
        return jdbc.queryForMap(
            """SELECT COALESCE(SUM(kcal), 0) as kcal, COALESCE(SUM(protein), 0) as protein,
                   COALESCE(SUM(fat), 0) as fat, COALESCE(SUM(carb), 0) as carb,
                   COUNT(*) as entries
               FROM core.diary_entries
               WHERE user_id = ?::uuid AND date >= ? AND date < ? + INTERVAL '7 days'""",
            userId, weekStart
        )
    }

    fun getTopRecipes(userId: String, limit: Int = 10): List<Map<String, Any>> {
        return jdbc.queryForList(
            """SELECT title, COUNT(*) as count, AVG(kcal) as avg_kcal
               FROM core.diary_entries de
               JOIN core.recipes r ON r.title = de.meal  -- simplified join
               WHERE user_id = ?::uuid
               GROUP BY title
               ORDER BY count DESC
               LIMIT ?""",
            userId, limit
        )
    }
}

@Service
class ExperimentService(private val jdbc: JdbcTemplate) {

    data class Experiment(
        val code: String,
        val name: String,
        val variants: List<String>,
        val isActive: Boolean,
    )

    data class Assignment(
        val userId: String,
        val experimentCode: String,
        val variant: String,
    )

    val activeExperiments: List<Experiment> = listOf(
        Experiment("plan_layout", "Разметка 7-дневного плана", listOf("list", "cards"), true),
        Experiment("substitution_ui", "Интерфейс подстановок", listOf("compact", "expanded"), true),
    )

    fun getExperiments(): List<Experiment> = activeExperiments

    fun assign(userId: String, experimentCode: String): Assignment {
        val exp = activeExperiments.find { it.code == experimentCode } ?: error("Unknown experiment: $experimentCode")
        val variant = exp.variants[userId.hashCode().abs() % exp.variants.size]
        return Assignment(userId, experimentCode, variant)
    }
}
