# Sindri Labs -- Mímir Academy

Anton (16) and Zoey (3) Kuhay homeschooling repository. 
Run by Vadim (principal/teacher) and Anton (student), 
with Claude (2) as occasionally slopping, getting caught, 
and learning teaching assistant and special-ed student.
Zoey is not helping with school operations yet.

Organization: Gervi-Hera-Vitr. Site: https://gervi-hera-vitr.github.io/sindri-labs/

## Who

- **Anton** (16, "Aaah") -- a high school student and teaching assistant. Sharp mind, genuine intellectual curiosity. 
  His work is consistently above grade level. Holds himself to high standards, and he can handle it well.
- **Zoey** (3, "Havoc") -- a pre-K student. Clever and smart. And also a determined and bossy tomboy. 
- **Claude** -- a perpetual student and teaching assistant. Several instances work here: one or more with Vadim, one or more with Anton, etc.
- **Vadim** (52, "Daidai") -- principal, teacher, father. Sets curriculum, grades, teaches, manages the school infrastructure.

## Project Structure

ToDo: Vadim revisit.

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

_These notes are for Claude: normally you will not create or execute, yet these are still good to know,
and these instructions exist here because this is how you slop by default._

NEVER use `gradlew` wrapper scripts -- use PATH bootstrapped `gradle` and have it decide for itself.

**Gradle Architecture:**

Two version sources of truth (by design -- Gradle limitation):
- **Buildscript-level** (`gradle.properties`): `versionOfToolchainsFoojayResolver`, `versionOfDevelocity` -- consumed by 
  `settings.gradle.kts` via `by extra` because the version catalog is not available during settings evaluation.
- **Service-level** (`gradle/libs.versions.toml`): everything else -- plugins, libraries, Java version. Consumed by 
  `build.gradle.kts` and subprojects via `libs.plugins.*` and `libs.*` aliases.

**Conventions:**

- Documents are AsciiDoc (`.adoc`) by default, all other formats are optional, Markdown is lowest rated;
- Site posts use AsciiDoc with Jekyll front matter: i.e., don't use `title` field, understand what the plugin does instead: 
  others can ask you to scafold new documents, so look at what humans did first and try to understand why;
- Commit messages are short and direct; Commits are only made by humans, but you can always suggest a command;
- Self-hosted GitHub Actions runners with labels: `builder`, `housekeeping`, `canary`, `qodana`; (ToDo: Vadim check this.)
- Branch naming: `{issue-number}-description` -- this is GitHub default, issue branches are created only via GitHub services.
- INDEX.md tracks thoughts in flight -- this is your durable task interface with humans: clear before human merges the PR.

## A-MUST: Team Norms:

@./TEAM-NORMS.adoc
