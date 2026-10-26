package ru.foodshopmeal.bff

import jakarta.validation.constraints.DecimalMax
import jakarta.validation.constraints.DecimalMin
import org.springframework.validation.annotation.Validated
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import ru.foodshopmeal.compliance.CompliancePolicy
import ru.foodshopmeal.domain.port.DegradationLevel
import ru.foodshopmeal.domain.port.RetailerAdapter
import ru.foodshopmeal.domain.port.RetailerCapability
import ru.foodshopmeal.infrastructure.flags.FeatureFlagReader

data class ComplianceMetadataDto(
    val requiresHealthConsent152Fz: Boolean,
    val policyVersion: String,
    val medicalStopListReasons: List<String>,
    val nonMedicalDisclaimerRu: String,
)

data class SystemCapabilitiesResponse(
    val effectiveDegradationLevel: DegradationLevel,
    val activeAdapter: String,
    val capabilities: Set<RetailerCapability>,
    val kuperFeatureEnabled: Boolean,
    val compliance: ComplianceMetadataDto,
)

@Validated
@RestController
@RequestMapping("/api/v1/system")
class SystemCapabilitiesController(
    private val adapters: List<RetailerAdapter>,
    private val featureFlags: FeatureFlagReader,
) {
    @GetMapping("/capabilities")
    fun getCapabilities(
        @RequestParam(required = false) @DecimalMin("-90.0") @DecimalMax("90.0") lat: Double?,
        @RequestParam(required = false) @DecimalMin("-180.0") @DecimalMax("180.0") lon: Double?,
    ): SystemCapabilitiesResponse {
        val kuperEnabled = featureFlags.isEnabled(KUPER_FLAG_KEY, defaultValue = false)

        val selectedAdapter =
            if (kuperEnabled) {
                adapters.firstOrNull { it.retailerCode == "kuper" }
            } else {
                null
            } ?: adapters.first { it.retailerCode == "local_list" }

        return SystemCapabilitiesResponse(
            effectiveDegradationLevel = selectedAdapter.degradationLevel,
            activeAdapter = selectedAdapter.retailerCode,
            capabilities = selectedAdapter.capabilities(),
            kuperFeatureEnabled = kuperEnabled,
            compliance = ComplianceMetadataDto(
                requiresHealthConsent152Fz = true,
                policyVersion = CompliancePolicy.CURRENT_POLICY_VERSION,
                medicalStopListReasons = CompliancePolicy.MEDICAL_STOP_LIST_REASONS,
                nonMedicalDisclaimerRu = CompliancePolicy.NON_MEDICAL_DISCLAIMER_RU,
            ),
        )
    }

    companion object {
        const val KUPER_FLAG_KEY = "retailer.kuper.enabled"
    }
}
