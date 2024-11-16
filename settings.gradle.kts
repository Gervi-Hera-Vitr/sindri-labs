pluginManagement {

    val versionOfBenManesPlugin: String by extra

    val versionOfToolchainsFoojayResolver: String by extra

    val versionOfKotlin: String by extra
    val versionOfKtor: String by extra

    val versionOfDokka: String by extra
    val versionOfAsciidoctorJvm: String by extra

    plugins {
        id("org.gradle.toolchains.foojay-resolver-convention") version versionOfToolchainsFoojayResolver
        id("com.github.ben-manes.versions") version versionOfBenManesPlugin

        kotlin("jvm") version versionOfKotlin
        id("org.jetbrains.dokka") version versionOfDokka

        jacoco

        id("io.ktor.plugin") version versionOfKtor

        id("org.jetbrains.kotlin.plugin.serialization") version versionOfKotlin

        versionOfAsciidoctorJvm.apply {
            id("org.asciidoctor.jvm.pdf") version this
            id("org.asciidoctor.jvm.gems") version this
            id("org.asciidoctor.jvm.epub") version this
            id("org.asciidoctor.jvm.convert") version this
        }
    }
}

include("lab-ux-ktor", "journey", "docs", "labs", "planning")

rootProject.name = "google-ai-labs"
