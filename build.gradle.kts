import com.github.benmanes.gradle.versions.updates.DependencyUpdatesTask
import org.slf4j.LoggerFactory
import java.util.*

val useJavaVer: String by project

val versionOfKotlinLogging: String by project
val versionOfSlf4j: String by project
val versionOfLogback: String by project

val asciidoctorJDiagramVersion: String by project

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.build") }

plugins {
    id("org.gradle.kotlin.kotlin-dsl") apply false  // `kotlin-dsl` forced version upgrade
//    `kotlin-dsl` apply false  // `kotlin-dsl` maintainer's recommendation
    id("com.github.ben-manes.versions")

    kotlin("jvm")
    id("org.jetbrains.dokka") apply false

    id("io.ktor.plugin") apply false
    id("org.jetbrains.kotlin.plugin.serialization") apply false

    id("org.asciidoctor.jvm.pdf") apply false
    id("org.asciidoctor.jvm.gems") apply false
    id("org.asciidoctor.jvm.epub") apply false
    id("org.asciidoctor.jvm.convert") apply false
}

allprojects {
    repositories {
        mavenCentral()
    }
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(useJavaVer)
    }
}

dependencies {
    implementation(gradleApi())
    implementation(platform(kotlin("bom")))

    api("org.slf4j:slf4j-api:$versionOfSlf4j")
    implementation("io.github.oshai:kotlin-logging:$versionOfKotlinLogging")
    implementation("ch.qos.logback:logback-classic:$versionOfLogback")

    testImplementation(platform(kotlin("bom")))
    testImplementation(kotlin("test"))
}

tasks.named<DependencyUpdatesTask>("dependencyUpdates").configure {
    checkForGradleUpdate = true
    outputFormatter = "json"
    outputDir = "build/dependencies"
    reportfileName = "report"

    val releaseDependencyRequired: Boolean = fun(): Boolean {
        val releaseDependencyRequiredProperty = project.findProperty("useReleaseDependenciesOnly")?.toString()?.toBoolean() ?: false
        println("::notice file=build.gradle.kts::Release-Only dependency restriction in properties is $releaseDependencyRequiredProperty")
        if (releaseDependencyRequiredProperty) {
            println("::notice file=build.gradle.kts::Since Release-Only dependency restriction is set by property to true, skipping env check which has no effect; to control this behavior from env, mute the property 'useReleaseDependenciesOnly' or set it to 'false'.")
            return true
        }

        val releaseDependencyRequiredOverride = System.getenv("RELEASES_ONLY")
        if (releaseDependencyRequiredOverride != null && releaseDependencyRequiredOverride.toBoolean()) {
            println("::notice file=build.gradle.kts::Release-Only dependency restriction is honored from env('RELEASES_ONLY') and is $releaseDependencyRequiredOverride")
            return true
        }
        println("::notice file=build.gradle.kts::Release Only dependency restriction is set by property to 'false'.")
        return false
    }()

    rejectVersionIf {
        releaseDependencyRequired && isStableVersion(candidate.version).not()
    }
}

fun isStableVersion(version: String): Boolean {
    val stableKeyword = listOf("RELEASE", "FINAL", "GA").any { version.uppercase(Locale.getDefault()).contains(it) }
    val regex = "^[0-9,.v-]+(-r)?$".toRegex()
    val isStable = stableKeyword || regex.matches(version)
    return isStable
}

tasks.register("processDependencyUpdates") {
    dependsOn("dependencyUpdates")

    doLast {
        val reportFile = file("build/dependencies/report.json")
        if (!reportFile.exists()) {
            println("ERROR: No dependency update report found.")
            println("::error file=build.gradle.kts::Dependency report not found at build/dependencies/report.json")
            return@doLast
        }

        val reportJson = reportFile.readText()
        val json = groovy.json.JsonSlurper().parseText(reportJson)

        // Capture suggestions for outdated dependencies
        val outdatedJsonDependenciesAsObject = json as Map<*, *>
        val outdatedDependencies = outdatedJsonDependenciesAsObject["outdated"] as Map<*, *>
        val dependencies = outdatedDependencies["dependencies"] as List<*>

        if (dependencies.isNotEmpty()) {
            println("The following dependencies have newer versions available:")

            dependencies.forEach { dep ->
                val dependencyInformation = dep as Map<*, *>
                val group = dependencyInformation["group"]
                val name = dependencyInformation["name"]
                val currentVersion = dependencyInformation["version"]

                val available = (dep["available"] as Map<*, *>)["milestone"]

                println("- $group:$name [$currentVersion -> $available]")

                println("::warning file=build.gradle.kts::Dependency update available for $group:$name from $currentVersion to $available")
            }
        } else {
            println("All dependencies are up to date.")
            println("::notice file=build.gradle.kts::Dependencies are up to date.")
        }
    }
}
