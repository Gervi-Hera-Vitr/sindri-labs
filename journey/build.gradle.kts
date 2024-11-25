import org.asciidoctor.gradle.jvm.AbstractAsciidoctorTask.JAVA_EXEC
import org.asciidoctor.gradle.jvm.AsciidoctorTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask.EPUB3
import org.asciidoctor.gradle.jvm.pdf.AsciidoctorPdfTask
import org.slf4j.LoggerFactory

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.journey.build") }

log.warn("AI/ML Learning Journey documents build started.")

val adocJvmParams =
    listOf(
        "--add-opens",
        "java.base/sun.nio.ch=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.io=ALL-UNNAMED",
    )

plugins {
    id("org.asciidoctor.jvm.pdf")
    id("org.asciidoctor.jvm.gems")
    id("org.asciidoctor.jvm.epub")
    id("org.asciidoctor.jvm.convert")
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
    }
}

tasks.withType<AsciidoctorEpubTask>().configureEach { ebookFormats(EPUB3) }
