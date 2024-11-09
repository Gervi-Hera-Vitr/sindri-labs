import org.asciidoctor.gradle.jvm.AbstractAsciidoctorTask.JAVA_EXEC
import org.asciidoctor.gradle.jvm.AsciidoctorTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask.EPUB3
import org.asciidoctor.gradle.jvm.pdf.AsciidoctorPdfTask
import org.slf4j.LoggerFactory

val useJavaVer: String by project

val kotlinLoggingVersion: String by project
val slf4jVersion: String by project
val logbackClassicVersion: String by project

val asciidoctorJDiagramVersion: String by project

val adocJvmParams =
    listOf(
        "--add-opens",
        "java.base/sun.nio.ch=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.io=ALL-UNNAMED",
    )

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.journey.build") }

log.warn("AI/ML Learning Journey documents build started.")

plugins {
    kotlin("jvm")
    id("org.jetbrains.dokka")

    id("org.asciidoctor.jvm.pdf")
    id("org.asciidoctor.jvm.gems")
    id("org.asciidoctor.jvm.epub")
    id("org.asciidoctor.jvm.convert")
}

repositories {
    mavenCentral()
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(useJavaVer)
    }
}

dependencies {
    implementation(platform(kotlin("bom")))

    api("org.slf4j:slf4j-api:$slf4jVersion")
    implementation("io.github.oshai:kotlin-logging:$kotlinLoggingVersion")
    implementation("ch.qos.logback:logback-classic:$logbackClassicVersion")

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
