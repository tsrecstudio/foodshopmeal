package ru.foodshopmeal.bff

import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.context.annotation.Import
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import ru.foodshopmeal.infrastructure.flags.FeatureFlagReader
import ru.foodshopmeal.integration.kuper.KuperAdapterStub
import ru.foodshopmeal.integration.locallist.LocalListAdapter

@WebMvcTest(SystemCapabilitiesController::class)
@Import(LocalListAdapter::class, KuperAdapterStub::class, GlobalProblemExceptionHandler::class)
class SystemCapabilitiesControllerTest(
    @Autowired private val mockMvc: MockMvc,
) {
    @MockBean
    private lateinit var featureFlags: FeatureFlagReader

    @Test
    fun `returns L1 local_list capabilities when Kuper flag is disabled`() {
        `when`(featureFlags.isEnabled("retailer.kuper.enabled", false)).thenReturn(false)

        mockMvc.perform(get("/api/v1/system/capabilities?lat=55.7558&lon=37.6173"))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.effectiveDegradationLevel").value("L1"))
            .andExpect(jsonPath("$.activeAdapter").value("local_list"))
            .andExpect(jsonPath("$.kuperFeatureEnabled").value(false))
            .andExpect(jsonPath("$.compliance.requiresHealthConsent152Fz").value(true))
    }

    @Test
    fun `promotes to L3 kuper adapter when feature flag is enabled`() {
        `when`(featureFlags.isEnabled("retailer.kuper.enabled", false)).thenReturn(true)

        mockMvc.perform(get("/api/v1/system/capabilities?lat=55.7558&lon=37.6173"))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.effectiveDegradationLevel").value("L3"))
            .andExpect(jsonPath("$.activeAdapter").value("kuper"))
            .andExpect(jsonPath("$.kuperFeatureEnabled").value(true))
    }

    @Test
    fun `rejects out of range latitude with RFC 7807 ProblemDetail`() {
        mockMvc.perform(get("/api/v1/system/capabilities?lat=125.0&lon=37.6"))
            .andExpect(status().isUnprocessableEntity)
            .andExpect(jsonPath("$.title").value("Validation Failed"))
            .andExpect(jsonPath("$.status").value(422))
    }
}
