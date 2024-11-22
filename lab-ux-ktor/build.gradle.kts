@file:Suppress("UnstableApiUsage")

import org.slf4j.LoggerFactory

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.journey.build") }

log.warn("AI/ML ktor UX build started.")

val applicationMainClass: String by project

val versionOfLogback: String by project
val versionOfKotlin: String by project

val versionOverrideHttpCore: String by project
val versionOverrideJetbrainsAnnotations: String by project
val versionOverrideKotlinxIoCore: String by project
val versionOverrideKotlinxSerialization: String by project

plugins {
    kotlin("jvm")
    id("io.ktor.plugin")
    id("org.jetbrains.kotlin.plugin.serialization")
}

application {
    mainClass.set(applicationMainClass)

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

dependencies {

    constraints {
        implementation("org.apache.httpcomponents:httpcore:$versionOverrideHttpCore")
        implementation("org.jetbrains.kotlin:kotlin-stdlib:$versionOfKotlin")
        implementation("org.jetbrains:annotations:$versionOverrideJetbrainsAnnotations")
        implementation("org.jetbrains.kotlinx:kotlinx-io-core:$versionOverrideKotlinxIoCore")
        implementation("org.jetbrains.kotlinx:kotlinx-serialization-core:$versionOverrideKotlinxSerialization")
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

    implementation("ch.qos.logback:logback-classic:$versionOfLogback")
    testImplementation("io.ktor:ktor-server-test-host-jvm")
    testImplementation(kotlin("test-junit"))
}