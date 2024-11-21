import com.github.benmanes.gradle.versions.updates.DependencyUpdatesTask
import org.asciidoctor.gradle.jvm.AbstractAsciidoctorTask.JAVA_EXEC
import org.asciidoctor.gradle.jvm.AsciidoctorTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask.EPUB3
import org.asciidoctor.gradle.jvm.pdf.AsciidoctorPdfTask
import org.slf4j.LoggerFactory
import java.util.*

val useJavaVer: String by project

val versionOfKotlinLogging: String by project
val versionOfSlf4j: String by project
val versionOfLogback: String by project

val asciidoctorJDiagramVersion: String by project

val adocJvmParams =
    listOf(
        "--add-opens",
        "java.base/sun.nio.ch=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.io=ALL-UNNAMED",
    )

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.build") }

plugins {
    id("com.github.ben-manes.versions")

    kotlin("jvm")
    id("org.jetbrains.dokka") apply false

    id("io.ktor.plugin") apply false
    id("org.jetbrains.kotlin.plugin.serialization") apply false

    id("org.asciidoctor.jvm.pdf")
    id("org.asciidoctor.jvm.gems")
    id("org.asciidoctor.jvm.epub")
    id("org.asciidoctor.jvm.convert")
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
    implementation(platform(kotlin("bom")))

    api("org.slf4j:slf4j-api:$versionOfSlf4j")
    implementation("io.github.oshai:kotlin-logging:$versionOfKotlinLogging")
    implementation("ch.qos.logback:logback-classic:$versionOfLogback")

    testImplementation(platform(kotlin("bom")))
    testImplementation(kotlin("test"))
}

listOf(
    tasks.withType<AsciidoctorTask>(),
    tasks.withType<AsciidoctorPdfTask>(),
    tasks.withType<AsciidoctorEpubTask>(),
).forEach {
    it.configureEach {
        setExecutionMode(JAVA_EXEC)
        jvm { jvmArgs(adocJvmParams) }

        isLogDocuments = true
        baseDirFollowsSourceDir()
        setSourceDir(file("src/docs/asciidoc"))
        sources(
            delegateClosureOf<PatternSet> {
                include("journey.adoc")
            },
        )
    }
}

tasks.withType<AsciidoctorEpubTask>().configureEach { ebookFormats(EPUB3) }

tasks.named<DependencyUpdatesTask>("dependencyUpdates").configure {
    checkForGradleUpdate = true
    outputFormatter = "json"
    outputDir = "build/dependencies"
    reportfileName = "report"

    val releaseDependencyRequired: Boolean = project.findProperty("useReleaseDependenciesOnly")?.toString()?.toBoolean() ?: false

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

                // Add annotations for GitHub Actions
                println("::warning file=build.gradle.kts::Dependency update available for $group:$name from $currentVersion to $available")
            }
        } else {
            println("All dependencies are up to date.")
        }
    }
}
