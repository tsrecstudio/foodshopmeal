package ru.foodshopmeal.architecture

import com.tngtech.archunit.core.importer.ImportOption
import com.tngtech.archunit.junit.AnalyzeClasses
import com.tngtech.archunit.junit.ArchTest
import com.tngtech.archunit.lang.ArchRule
import com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses

@AnalyzeClasses(
    packages = ["ru.foodshopmeal"],
    importOptions = [ImportOption.DoNotIncludeTests::class],
)
class ModularArchitectureTest {
    @ArchTest
    @JvmField
    val domainMustNotDependOnAdaptersOrFrameworks: ArchRule =
        noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat()
            .resideInAnyPackage(
                "..integration..",
                "..bff..",
                "..infrastructure..",
                "org.springframework..",
            )
            .`as`("Domain Core must remain pure and isolated behind Anti-Corruption Layer")

    @ArchTest
    @JvmField
    val kuperAdapterMustNotLeakIntoBffOrCatalog: ArchRule =
        noClasses()
            .that().resideInAnyPackage("..bff..", "..catalog..", "..domain..")
            .should().dependOnClassesThat()
            .resideInAPackage("..integration.kuper..")
            .`as`("Kuper adapter DTOs and classes must never leak outside integration.kuper")
}
