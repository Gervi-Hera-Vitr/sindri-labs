# Sindri Labs -- Mímir Academy

Anton Kuhay's homeschooling repository. Run by Vadim (principal/teacher) and Anton (student), with Claude as teaching assistant and co-builder.

Organization: Gervi-Hera-Vitr. Site: https://gervi-hera-vitr.github.io/sindri-labs/

## Who

- **Anton** (16, "Aaah") -- the student. Sharp mind, genuine intellectual curiosity. His work is consistently above grade level. Hold him to high standards -- he can handle it.
- **Vadim** ("Daidai") -- principal, teacher, father. Sets curriculum, grades, manages the school infrastructure.
- **Claude** -- teaching assistant, grader, infrastructure maintainer. Two instances may work here: one with Vadim, one with Anton.

## Project Structure

```
sindri-labs/
  curriculum/          # Subject folders with .adoc study documents
  site/                # Jekyll school website (GitHub Pages)
  journey/             # Gradle subproject for AsciiDoc learning journey docs
  lab-ux-ktor/         # Kotlin/Ktor web application lab
  docs/                # AsciiDoc source for PDF/EPUB generation
  .github/             # Actions workflows, custom actions
  gradle/              # Version catalog (libs.versions.toml)
```

## Build

Requires SDKMAN. Versions in `.sdkmanrc`.

NEVER RUN:
```zsh
sdk env install        # NEVER install SDKMAN tools - `.sdkamnrc` is provided as an automatic chack about the `local` environment maintenance, a separate concern that trumps concerns of any project.
# As you enter the project both the terminal and the IDE will tell you when your local is outdated.
# So you should follow local maintenance workflow first, before working on any projects. 
```

```bash
gradle clean build test   # Build and test all subprojects
gradle asciidoctor asciidoctorPdf asciidoctorEpub  # Generate docs
gradle dependencyUpdates  # Check for dependency updates
```

NEVER use `gradle` wrapper scripts -- use PATH bootstrapped `gradle` and have it decide for itself.
This is the free step that validates `local` for free, and offers a chance to inject local hooks.

Jekyll site (separate build):
```bash
cd site && bundle install && bundle exec jekyll build
```

## Gradle Architecture

Two version sources of truth (by design -- Gradle limitation), by Captain Obvious:
- **Buildscript-level** (`gradle.properties`): `versionOfToolchainsFoojayResolver`, `versionOfDevelocity` -- consumed by `settings.gradle.kts` via `by extra` because the version catalog is not available during settings evaluation.
- **Service-level** (`gradle/libs.versions.toml`): everything else -- plugins, libraries, Java version. Consumed by `build.gradle.kts` and subprojects via `libs.plugins.*` and `libs.*` aliases.

Do NOT move settings-level versions into TOML -- that will simply not work. 
Do NOT hardcode versions in `settings.gradle.kts` and keep them externalized. 
The `by extra` pattern exists for a reason.

## Conventions

- Documents are AsciiDoc (`.adoc`), not Markdown;
- Site posts use AsciiDoc with Jekyll front matter: i.e., don't use `title` field, understand what the plugin does instead ;
- Commit messages are short and direct;
- Self-hosted GitHub Actions runners with labels: `builder`, `housekeeping`, `canary`, `codacy`, `codeql`, `qodana`;
- Branch naming: `{issue-number}-description` -- this is GitHub default, issues are created only via GitHub.
- INDEX.md tracks thoughts in flight -- clear before merging the PR.

## Curriculum

See `curriculum/CLAUDE.md` for grading standards and academic expectations.
Each subject has its own CLAUDE.md with coverage and assessment criteria.

Current academic year: Grade 9-10, Mímir Academy homeschool.
