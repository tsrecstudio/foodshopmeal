package ru.foodshopmeal.infrastructure.health

import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.actuate.health.Health
import org.springframework.boot.actuate.health.HealthIndicator
import org.springframework.http.client.SimpleClientHttpRequestFactory
import org.springframework.stereotype.Component
import org.springframework.web.client.RestClient
import java.time.Duration

@Component("solverService")
class SolverServiceHealthIndicator(
    @Value("\${fsm.solver.base-url}") private val solverBaseUrl: String,
) : HealthIndicator {
    private val restClient: RestClient =
        RestClient.builder()
            .baseUrl(solverBaseUrl)
            .requestFactory(
                SimpleClientHttpRequestFactory().apply {
                    setConnectTimeout(Duration.ofSeconds(2))
                    setReadTimeout(Duration.ofSeconds(2))
                },
            )
            .build()

    override fun health(): Health =
        try {
            val body = restClient.get()
                .uri("/health/ready")
                .retrieve()
                .body(Map::class.java)
            Health.up()
                .withDetail("baseUrl", solverBaseUrl)
                .withDetail("upstream", body ?: emptyMap<String, Any>())
                .build()
        } catch (ex: Exception) {
            Health.down(ex)
                .withDetail("baseUrl", solverBaseUrl)
                .build()
        }
}
