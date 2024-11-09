pluginManagement {

    val kotlinVersion: String by extra
    val dokkaVersion: String by extra

    val toolchainsFoojayResolverVersion: String by extra

    val asciidoctorJvmVersion: String by extra

    plugins {
        id("org.gradle.toolchains.foojay-resolver-convention") version toolchainsFoojayResolverVersion

        kotlin("jvm") version kotlinVersion

        id("org.jetbrains.dokka") version dokkaVersion

        asciidoctorJvmVersion.apply {
            id("org.asciidoctor.jvm.pdf") version this
            id("org.asciidoctor.jvm.gems") version this
            id("org.asciidoctor.jvm.epub") version this
            id("org.asciidoctor.jvm.convert") version this
        }
    }
}

rootProject.name = "journey"

