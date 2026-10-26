package ru.foodshopmeal.compliance

object CompliancePolicy {
    const val CURRENT_POLICY_VERSION: String = "2026-10-01"

    val MEDICAL_STOP_LIST_REASONS: List<String> = listOf(
        "pregnancy",
        "diabetes",
        "eating_disorders",
    )

    const val NON_MEDICAL_DISCLAIMER_RU: String =
        "Сервис носит информационно-бытовой характер планирования покупок и питания, " +
            "не является медицинским изделием или медицинской услугой и не заменяет консультацию врача."
}

class MedicalStopListException(reason: String) :
    RuntimeException("Medical stop-list triggered ($reason): therapeutic diet generation is disabled")
