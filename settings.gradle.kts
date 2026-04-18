pluginManagement {

    val versionOfDevelocity: String by extra
    val versionOfToolchainsFoojayResolver: String by extra

    repositories {
        gradlePluginPortal()
        mavenCentral()
    }

    plugins {
        id("org.gradle.toolchains.foojay-resolver-convention") version versionOfToolchainsFoojayResolver
        id("com.gradle.develocity") version versionOfDevelocity
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
