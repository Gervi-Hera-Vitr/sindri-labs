pluginManagement {

    val versionOfDevelocity: String by extra
    val versionOfBenManesPlugin: String by extra

    val versionOfToolchainsFoojayResolver: String by extra

    val versionOfKotlinDsl: String by extra
    val versionOfKotlin: String by extra
    val versionOfKtor: String by extra

    val versionOfDokka: String by extra
    val versionOfAsciidoctorJvm: String by extra

    repositories {
        gradlePluginPortal()
        mavenCentral()
    }

    plugins {
        id("org.gradle.toolchains.foojay-resolver-convention") version versionOfToolchainsFoojayResolver

        id("com.gradle.develocity") version versionOfDevelocity
        id("com.github.ben-manes.versions") version versionOfBenManesPlugin


                kotlin("jvm") version versionOfKotlin
        id("org.jetbrains.dokka") version versionOfDokka
        id("org.gradle.kotlin.kotlin-dsl") version versionOfKotlinDsl        // `kotlin-dsl` forced version upgrade, otherwise remove mention: FYI, matilda does not work with 5.x anymore

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

plugins {
    id("com.gradle.develocity")
}

develocity {
    buildScan {
        termsOfUseUrl.set("https://gradle.com/help/legal-terms-of-use")
        termsOfUseAgree.set("yes")
    }
}

include("lab-ux-ktor", "journey")

rootProject.name = "sindri-labs"
