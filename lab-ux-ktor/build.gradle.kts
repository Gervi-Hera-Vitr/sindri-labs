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

configurations {
    all {
        resolutionStrategy {
            dependencySubstitution {
                substitute(module("org.apache.httpcomponents:httpcore"))
                    .using(module("org.apache.httpcomponents:httpcore:$versionOverrideHttpCore"))
                substitute(module("org.jetbrains.kotlin:kotlin-stdlib-common"))
                    .using(module("org.jetbrains.kotlin:kotlin-stdlib:$versionOfKotlin"))
                substitute(module("org.jetbrains:annotations"))
                    .using(module("org.jetbrains:annotations:$versionOverrideJetbrainsAnnotations"))
                substitute(module("org.jetbrains.kotlinx:kotlinx-io-core"))
                    .using(module("org.jetbrains.kotlinx:kotlinx-io-core:$versionOverrideKotlinxIoCore"))
                substitute(module("org.jetbrains.kotlinx:kotlinx-serialization-core"))
                    .using(module("org.jetbrains.kotlinx:kotlinx-serialization-core:$versionOverrideKotlinxSerialization"))
            }
        }
    }
}

application {
    mainClass.set(applicationMainClass)

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

dependencies {
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