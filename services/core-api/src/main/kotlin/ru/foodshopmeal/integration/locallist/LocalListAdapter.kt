package ru.foodshopmeal.integration.locallist

import org.springframework.stereotype.Component
import ru.foodshopmeal.domain.port.DegradationLevel
import ru.foodshopmeal.domain.port.RetailerAdapter
import ru.foodshopmeal.domain.port.RetailerCapability

/**
 * L1 Fallback Adapter: Smart shopping list with offline/feed prices.
 * Always available even without active partner contracts or when Kuper API is unreachable.
 */
@Component
class LocalListAdapter : RetailerAdapter {
    override val retailerCode: String = RETAILER_CODE
    override val degradationLevel: DegradationLevel = DegradationLevel.L1

    override fun capabilities(): Set<RetailerCapability> =
        setOf(RetailerCapability.READ_CATALOG)

    companion object {
        const val RETAILER_CODE: String = "local_list"
    }
}
