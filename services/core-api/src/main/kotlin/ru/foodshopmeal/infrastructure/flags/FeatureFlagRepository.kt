package ru.foodshopmeal.infrastructure.flags

import org.springframework.jdbc.core.simple.JdbcClient
import org.springframework.stereotype.Repository

interface FeatureFlagReader {
    fun isEnabled(flagKey: String, defaultValue: Boolean = false): Boolean
}

@Repository
class JdbcFeatureFlagRepository(
    private val jdbcClient: JdbcClient,
) : FeatureFlagReader {
    override fun isEnabled(flagKey: String, defaultValue: Boolean): Boolean =
        jdbcClient
            .sql("SELECT enabled FROM core.feature_flags WHERE flag_key = :flagKey")
            .param("flagKey", flagKey)
            .query(Boolean::class.java)
            .optional()
            .orElse(defaultValue)
}
