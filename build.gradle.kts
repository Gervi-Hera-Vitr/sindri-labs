import com.github.benmanes.gradle.versions.updates.DependencyUpdatesTask
import org.asciidoctor.gradle.jvm.AbstractAsciidoctorTask.JAVA_EXEC
import org.asciidoctor.gradle.jvm.AsciidoctorTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask.EPUB3
import org.asciidoctor.gradle.jvm.pdf.AsciidoctorPdfTask
import org.slf4j.LoggerFactory
import java.util.*

val documentationRootFolder = file(project.property("docs.root.folder") as String)

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.build") }

plugins {
    alias(libs.plugins.kotlin.dsl) apply false
    alias(libs.plugins.ben.manes)

    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.dokka) apply false

    alias(libs.plugins.ktor) apply false
    alias(libs.plugins.kotlin.serialization) apply false

    alias(libs.plugins.asciidoctor.pdf)
    alias(libs.plugins.asciidoctor.gems)
    alias(libs.plugins.asciidoctor.epub)
    alias(libs.plugins.asciidoctor.convert)
}

dependencies {
    implementation(gradleApi())
    implementation(platform(kotlin("bom")))

    api(libs.slf4j.api)
    implementation(libs.kotlin.logging)
    implementation(libs.logback.classic)

    testImplementation(kotlin("test"))
}

allprojects {
    repositories {
        mavenCentral()
    }
}
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(libs.versions.java.get()))
        vendor.set(JvmVendorSpec.ADOPTIUM)
        log.info("\t|=> Riddle me that Java Toolchain SET to    -> ${libs.versions.java.get()} : ${JvmVendorSpec.ADOPTIUM}.")
    }
}

val adocJvmParams = listOf(
    "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED",
    "--add-opens", "java.base/java.io=ALL-UNNAMED",
)

listOf(
    tasks.withType<AsciidoctorTask>(),
    tasks.withType<AsciidoctorPdfTask>(),
    tasks.withType<AsciidoctorEpubTask>(),
).forEach {
    it.configureEach {
        setExecutionMode(JAVA_EXEC)
        jvm { jvmArgs(adocJvmParams) }
    }
}

tasks.named<AsciidoctorTask>("asciidoctor") { configureAsciiDocInput(this) }

tasks.named<AsciidoctorPdfTask>("asciidoctorPdf") { configureAsciiDocInput(this) }

tasks.named<AsciidoctorEpubTask>("asciidoctorEpub") { configureAsciiDocInput(this).also { ebookFormats(EPUB3) } }

pdfThemes {
    file("docs/src/resources/themes").apply {
        arrayOf("principal", "project", "student").forEach {
            local(it) {
                themeDir = this@apply
                themeName = "$it-theme"
            }
        }
    }
}


tasks.named<DependencyUpdatesTask>("dependencyUpdates").configure {
    checkForGradleUpdate = true
    outputFormatter = "json"
    outputDir = "build/dependencies"
    reportfileName = "report"

    val releaseDependencyRequired: Boolean = when {
        this.project.findProperty("useReleaseDependenciesOnly")?.toString()?.toBoolean() ?: false -> {
            log.info("::notice file=build.gradle.kts::Since Release-Only dependency restriction is set by property to true, skipping env check which has no effect; to control this behavior from env, mute the property 'useReleaseDependenciesOnly' or set it to 'false'.")
            true
        }

        System.getenv("RELEASES_ONLY").toBoolean() -> {
            log.info("::notice file=build.gradle.kts::Release-Only dependency restriction is honored from env('RELEASES_ONLY')")
            true
        }

        else -> false
    }

    rejectVersionIf {
        releaseDependencyRequired && isStableVersion(candidate.version).not()
    }
}

fun isStableVersion(version: String): Boolean {
    val stableKeyword = listOf("RELEASE", "FINAL", "GA").any { version.uppercase(Locale.getDefault()).contains(it) }
    val regex = "^[0-9,.v-]+(-r)?$".toRegex()
    return stableKeyword || regex.matches(version)
}

tasks.register("processDependencyUpdates") {
    description = "Custom Dependency Updates Checker"
    dependsOn("dependencyUpdates")

    doLast {
        val reportFile = file("build/dependencies/report.json")
        if (!reportFile.exists()) {
            log.error("ERROR: No dependency update report found.")
            log.error("::error file=build.gradle.kts::Dependency report not found at build/dependencies/report.json")
            return@doLast
        }

        val reportJson = reportFile.readText()
        val json = groovy.json.JsonSlurper().parseText(reportJson)

        // Capture suggestions for outdated dependencies
        val outdatedJsonDependenciesAsObject = json as Map<*, *>
        val outdatedDependencies = outdatedJsonDependenciesAsObject["outdated"] as Map<*, *>
        val dependencies = outdatedDependencies["dependencies"] as List<*>

        when {
            dependencies.isNotEmpty() -> {
                log.warn("The following dependencies have newer versions available:")

                dependencies.forEach { dep ->
                    val dependencyInformation = dep as Map<*, *>
                    val group = dependencyInformation["group"]
                    val name = dependencyInformation["name"]
                    val currentVersion = dependencyInformation["version"]

                    val available = (dep["available"] as Map<*, *>)["milestone"]

                    log.warn("- $group:$name [$currentVersion -> $available]")

                    log.warn("::warning file=build.gradle.kts::Dependency update available for $group:$name from $currentVersion to $available")
                }
            }

            else -> arrayOf(
                    "All dependencies are up to date.",
                    "::notice file=build.gradle.kts::Dependencies are up to date."
                ).forEach(log::info)
        }
    }
}

/**
 * Configures the Asciidoctor task to generate documents from a specified source directory
 * and include only the specified patterns.
 *
 * @param task the Asciidoctor task to configure
 * @param sourceDir the source directory containing the documents to generate
 * @param includePatterns the patterns to include in the generation. Defaults to ["OnLeadership.adoc"]
 */
fun configureAsciiDocInput(
    task: org.asciidoctor.gradle.jvm.AbstractAsciidoctorTask,
    sourceDir: File = documentationRootFolder,
    includePatterns: List<String> = listOf("index.adoc")
) {
    task.apply {
        isLogDocuments = true
        baseDirFollowsSourceDir()
        sourceDir(sourceDir)

        sources { includePatterns.forEach { include(it) } }
    }
}
