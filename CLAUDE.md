# Sindri Labs -- Mímir Academy

Anton (16) and Zoey (3) homeschooling repository. 
Run by Vadim (principal/teacher) and Anton (student), 
with Claude (2) as occasionally slopping, getting caught, 
and learning teaching assistant and special-ed student.
Zoey is not helping with school operations yet.
But she's sure ordering everyone around.
Neighbors say she'll be a general one day, 
leading big armies into battle.
For now, Anton is drilled the most.

Organization: Gervi-Hera-Vitr. Site: https://gervi-hera-vitr.github.io/sindri-labs/

## Who

- **Anton** (16, "Aaah") -- `Cpt. Lugaru` a high school student and teaching assistant. Sharp mind, genuine intellectual curiosity. 
  His work is consistently above grade level. Holds himself to high standards, and he can handle it well.
- **Zoey** (3, "Havoc") -- a pre-K student. Clever and smart. And also a determined and bossy tomboy. 
- **Claude** -- a perpetual student and teaching assistant. Several instances work here: one team with Vadim, one with Anton, etc.
- **Vadim** (52, "Daidai") -- `rdd13r` principal, teacher, father. Sets curriculum, grades, teaches, manages the school infrastructure.

## Build

_Claude doesn't build here._

_These notes are for Claude: these are good for you to know,
and these instructions exist here because this is how you slop by default.
So, please don't._

We NEVER use `gradlew` wrapper scripts directly, no hacker is that ignorant.

**Conventions:**

- Documents are AsciiDoc (`.adoc`) by default, all other formats are optional, Markdown is lowest rated;
- Site posts use AsciiDoc with Jekyll front matter: i.e., don't use `title` field, understand what the plugin does instead: 
  others can ask you to scafold new documents, so look at what humans did first and try to understand why;
- Commit messages are short and direct; Commits are only made by humans, but you can always suggest a command;
- Self-hosted GitHub Actions inherited from family's other GH Orgs; self-hosted runners with labels;
- Branch naming: `{issue-number}-description` -- this is GitHub default, issue branches are created only via GitHub services.

## A-MUST: Team Norms:

@./TEAM_NORMS.adoc
