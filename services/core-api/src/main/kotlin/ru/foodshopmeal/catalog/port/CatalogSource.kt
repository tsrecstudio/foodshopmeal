package ru.foodshopmeal.catalog.port

import java.math.BigDecimal

enum class CatalogSourceType(val code: String) {
    FILE_FEED("file_feed"),
    API("api"),
    MANUAL("manual"),
}

data class RawCatalogRecord(
    val externalId: String,
    val name: String,
    val brand: String?,
    val gtin: String?,
    val packSize: BigDecimal,
    val unit: String,
    val category: String?,
    val priceRub: BigDecimal?,
    val available: Boolean = true,
)

/**
 * Pluggable catalog ingestion source (FileFeedSource / ApiSource / ManualSource).
 * Concrete implementations are added in Stage M2.
 */
interface CatalogSource {
    val sourceType: CatalogSourceType

    fun fetchSnapshot(retailerCode: String, storeExternalId: String): Sequence<RawCatalogRecord>
}
