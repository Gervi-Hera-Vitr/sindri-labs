pluginManagement {

    repositories {
        gradlePluginPortal()
        mavenCentral()
    }

    plugins {
        id("org.gradle.toolchains.foojay-resolver-convention") version
                providers.gradleProperty("versionOfToolchainsFoojayResolver").get()
        id("com.gradle.develocity") version
                providers.gradleProperty("versionOfDevelocity").get()
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
