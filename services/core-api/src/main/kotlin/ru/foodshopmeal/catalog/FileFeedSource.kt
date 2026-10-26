package ru.foodshopmeal.catalog

import org.springframework.core.io.Resource
import org.springframework.core.io.ResourceLoader
import org.springframework.stereotype.Component
import ru.foodshopmeal.catalog.port.CatalogSource
import ru.foodshopmeal.catalog.port.CatalogSourceType
import ru.foodshopmeal.catalog.port.RawCatalogRecord
import java.math.BigDecimal

/**
 * M2: FileFeedSource — reads SKU catalog from CSV/JSON files in S3 or classpath.
 * Used for the MVP since Kuper catalog source is unconfirmed.
 */
@Component
class FileFeedSource(private val resourceLoader: ResourceLoader) : CatalogSource {

    override val sourceType: CatalogSourceType = CatalogSourceType.FILE_FEED

    override fun fetchSnapshot(retailerCode: String, storeExternalId: String): Sequence<RawCatalogRecord> {
        // For MVP, reads from classpath:catalog-feeds/{retailer}/{store}.csv
        // In production, reads from S3 path s3://feeds/{retailer}/{store}/catalog.json
        val resource: Resource = resourceLoader.getResource("classpath:catalog-feeds/${retailerCode}/${storeExternalId}.csv")
        if (!resource.exists()) {
            return emptySequence()
        }
        return resource.inputStream.bufferedReader().lineSequence()
            .filter { it.isNotBlank() && !it.startsWith("#") }
            .map { line -> parseCsvLine(line) }
            .filterNotNull()
    }

    private fun parseCsvLine(line: String): RawCatalogRecord? {
        // CSV: externalId,name,brand,gtin,packSize,unit,category,priceRub,available
        val parts = line.split(",").map { it.trim() }
        if (parts.size < 7) return null
        val externalId = parts[0]
        val name = parts[1]
        val brand = parts.getOrNull(2).ifEmpty { null }
        val gtin = parts.getOrNull(3).ifEmpty { null }
        val packSize = runCatching { parts[4].toBigDecimal() }.getOrDefault(BigDecimal.ZERO)
        val unit = parts[5]
        val category = parts.getOrNull(6).ifEmpty { null }
        val priceRub = runCatching { parts.getOrNull(7)?.toBigDecimal() }.getOrNull()
        val available = parts.getOrNull(8).equals("true", ignoreCase = true)
        return RawCatalogRecord(
            externalId = externalId, name = name, brand = brand, gtin = gtin,
            packSize = packSize, unit = unit, category = category,
            priceRub = priceRub, available = available,
        )
    }
}
