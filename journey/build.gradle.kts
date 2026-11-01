import org.asciidoctor.gradle.jvm.AsciidoctorTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask
import org.asciidoctor.gradle.jvm.epub.AsciidoctorEpubTask.EPUB3
import org.asciidoctor.gradle.jvm.pdf.AsciidoctorPdfTask
import org.slf4j.LoggerFactory

private val log by lazy { LoggerFactory.getLogger("ai.gervi.hera.vitr.journey.build") }

log.warn("AI/ML Learning Journey documents build started.")

plugins {
    alias(libs.plugins.asciidoctor.pdf)
    alias(libs.plugins.asciidoctor.gems)
    alias(libs.plugins.asciidoctor.epub)
    alias(libs.plugins.asciidoctor.convert)
}

listOf(
    tasks.withType<AsciidoctorTask>(),
    tasks.withType<AsciidoctorPdfTask>(),
    tasks.withType<AsciidoctorEpubTask>(),
).forEach {
    it.configureEach {
        isLogDocuments = true
        baseDirFollowsSourceDir()
    }
}

tasks.withType<AsciidoctorEpubTask>().configureEach { ebookFormats(EPUB3) }
