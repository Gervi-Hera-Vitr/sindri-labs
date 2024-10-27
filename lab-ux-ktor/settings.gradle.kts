pluginManagement {

    val versionOfToolchainsFoojayResolver: String by extra

    val versionOfKotlin: String by extra
    val versionOfKtor: String by extra

    plugins {
        kotlin("jvm") version versionOfKotlin
        jacoco

        id("io.ktor.plugin") version versionOfKtor
        id("org.jetbrains.kotlin.plugin.serialization") version versionOfKotlin

        id("org.gradle.toolchains.foojay-resolver-convention") version versionOfToolchainsFoojayResolver
    }
}
