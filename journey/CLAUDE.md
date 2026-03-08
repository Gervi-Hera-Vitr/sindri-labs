# Journey -- AsciiDoc Learning Journey

Gradle subproject for generating AsciiDoc documents about Anton's AI/ML learning journey.

## Build

Built as part of the root project. Uses AsciiDoctor plugins (pdf, gems, epub, convert).

```bash
gradle :journey:asciidoctor
gradle :journey:asciidoctorPdf
gradle :journey:asciidoctorEpub
```

## Structure

- `src/` -- AsciiDoc source documents
- `build/` -- generated output (PDF, EPUB, HTML)
- `build.gradle.kts` -- configures AsciiDoctor tasks with JVM args for module access

## Notes

Uses `JAVA_EXEC` execution mode for AsciiDoctor tasks with `--add-opens` JVM args to handle module system restrictions.
This is a documentation-only subproject -- no Kotlin/Java source code.
