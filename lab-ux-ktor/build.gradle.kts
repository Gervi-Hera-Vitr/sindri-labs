@file:Suppress("UnstableApiUsage")

import org.slf4j.LoggerFactory

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.journey.build") }

log.warn("AI/ML ktor UX build started.")

val applicationMainClass: String by project

plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.ktor)
    alias(libs.plugins.kotlin.serialization)
}

application {
    mainClass.set(applicationMainClass)

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

dependencies {

    constraints {
        implementation(libs.httpcore)
        implementation(kotlin("stdlib"))
        implementation(libs.jetbrains.annotations)
        implementation(libs.kotlinx.io.core)
        implementation(libs.kotlinx.serialization.core)
    }

    implementation(platform(kotlin("bom")))
    implementation(platform("io.ktor:ktor-bom"))

    implementation("io.ktor:ktor-server-auto-head-response-jvm")
    implementation("io.ktor:ktor-server-core-jvm")
    implementation("io.ktor:ktor-server-host-common-jvm")
    implementation("io.ktor:ktor-server-status-pages-jvm")
    implementation("io.ktor:ktor-server-default-headers-jvm")
    implementation("io.ktor:ktor-server-call-logging-jvm")
    implementation("io.ktor:ktor-server-content-negotiation-jvm")
    implementation("io.ktor:ktor-serialization-kotlinx-json-jvm")
    implementation("io.ktor:ktor-server-thymeleaf-jvm")
    implementation("io.ktor:ktor-server-cio-jvm")

    implementation(libs.logback.classic)
    testImplementation("io.ktor:ktor-server-test-host-jvm")
    testImplementation(kotlin("test-junit"))
}
