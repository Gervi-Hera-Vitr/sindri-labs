import com.github.benmanes.gradle.versions.updates.DependencyUpdatesTask
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

    testImplementation(platform(kotlin("bom")))
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

tasks.named<AsciidoctorTask>("asciidoctor") { configureAsciiDocInput(this) }

tasks.named<AsciidoctorPdfTask>("asciidoctorPdf") { configureAsciiDocInput(this) }

tasks.named<AsciidoctorEpubTask>("asciidoctorEpub") { configureAsciiDocInput(this).also { ebookFormats(EPUB3) } }

pdfThemes {
    local("principal") {
        themeDir = file("docs/src/resources/themes")
        themeName = "principal-theme"
    }
    local("project") {
        themeDir = file("docs/src/resources/themes")
        themeName = "project-theme"
    }
    local("student") {
        themeDir = file("docs/src/resources/themes")
        themeName = "student-theme"
    }
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
    includePatterns: List<String> = listOf(
        "attendance.adoc",
        "compliance.adoc",
        "curriculum.adoc",
        "index.adoc",
        "testing.adoc")
) {
    task.apply {
        isLogDocuments = true
        baseDirFollowsSourceDir()
        sourceDir(sourceDir)

        sources { includePatterns.forEach { include(it) } }
    }
}
