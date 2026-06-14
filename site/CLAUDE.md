# School Site -- Jekyll

Anton's school website. Published at https://gervi-hera-vitr.github.io/sindri-labs/

## Build

_Just for Claude's reference -- humans use run configurations instead!_
Note: runconfigs exist for everything if there isn't one -- humans don't care for it then.
See convenience run configs at ${PROJECT_ROOT}/.run/**.xml

```zsh
cd site
bundle install
bundle exec jekyll build
bundle exec jekyll serve -wolIVt --port 4400
```

Requires Ruby (3.3.5) and Bundler -- this is inherited Mímis Gildi convention: everything is reusable. 
On self-hosted Linux runners (the farm) Ruby is installed as a system package on 'legacy' stock.
On self-hosted Linux runners (Goo family), Linux local (workstations) and Mac OS X workstations,
Ruby is installed via asdf. Ruby version is dictated by Jekyll ↔ OS parity compatibility.

**Theme:**

Minimal Mistakes (`mmistakes/minimal-mistakes`) with `sunrise` skin. Remote theme via `jekyll-remote-theme` plugin.

**Content Format:**

- Posts and pages are AsciiDoc (`.adoc`), not Markdown, both in workup and publish locations. Workups are in topic locations (see later).
- Posts go in `_posts/` with naming: `YYYY-MM-DD-Title.adoc` -- Jekyll format: automatic, no need to get creative.
- Pages go in `_pages/` with `permalink` front matter are school infrastructure usually managed by faculty.
- Front matter uses YAML between `---` delimiters at the top of `.adoc` files; `fronmatter` ↔ `adoc attributes` are to be understood, not slopped.
- Content, even workup scraps, is always curated: useless breaks (''') are disliked by all, and wrong breaks (---) are hated: no slop!
- Workups can emerge for weeks and live in topic folders such as `curriculum/Engineering/onCoreWizardry/onCompetitiveProgramming/onCodeForces`;
- Workups are not graded, they're reviewed, collaborated on, and curated; the published work based on workups is graded instead.

**Collections -- Fragments and References:**

Two custom collections live alongside `_posts` and `_pages`:

- **`_fragments/`** -- small reusable pieces (paragraph or two), one per topic. Used for drilldowns from posts and as inline includes.
- **`_references/`** -- bibliographic entries, one per source. Used as footnote text and as bibliography includes.

Both render as their own pages, but do NOT appear in the main post feed. Subdirectories work: `_fragments/people/foo.adoc` becomes `/fragments/people/foo/`. The collection's permalink template (`/fragments/:path/`, `/references/:path/`) generates the URL automatically -- no need to set `permalink:` in front matter.

**The four working patterns:**

1. **Fragment as inline include** -- `include::../_fragments/foo.adoc[tag=body]` pastes the fragment body into the host document (post-time, before parse).
2. **Fragment as link** -- `link:{{ '/fragments/foo/' | relative_url }}[Title]` to link to the standalone page.
3. **Reference as footnote** -- `footnote:id[short text + link to the reference page]` defines the footnote once, then `footnote:id[]` (empty brackets) reuses it anywhere later in the same document.
4. **Reference as bibliography** -- `include::../_references/foo.adoc[tag=citation]` pulls the bibliographic line. `[tag=annotation]` pulls the descriptive note.

**Tagged regions:**

Mark content for include with:

```
// tag::body[]
...content...
// end::body[]
```

Standard tags: `body` for fragments, `citation` and `annotation` for references. Front matter is automatically excluded from any tagged include. Content outside the tags appears only on the standalone collection page.

**Constraint:**

`include::` is an AsciiDoc preprocessor directive and does NOT work inside `footnote:[]` brackets. So footnotes either inline their text or link out to a reference page. Define-once-then-reuse via `footnote:id[]` does work and is the right pattern for repeated citations.

Examples:

- `_fragments/people/democritus.adoc` -- demo fragment
- `_references/dirac-1928.adoc` -- demo reference

**Existing Content:**

This can always be changing, but you keep wanting to have a static list that WILL get outdated. You can have your list here.
Nevertheless, if I deleted it one day -- would you know why I did that? I recomment reading content present instead of playing lazy slop.

- **Posts:** Welcome, school updates, book essays (Harry Potter, To Kill a Mockingbird, Go Set a Watchman), mathematics series (foundations through computation theory)
- **Pages:** About, curriculum, philosophy, mathematics, philosophers, science, semester, school year, contact, profile

**Site Author:**

"Mama Zaia" -- the bunny matriarch character. This is an intentional family branding based on the history and lore of the family.

**Deployment:**

GitHub Actions are inherited -- always read the templated workflow.

**Comments:**

Utterances (GitHub Issues-backed) configured for the repo.
(ToDo: Vadim please verify if this is still the case.)
