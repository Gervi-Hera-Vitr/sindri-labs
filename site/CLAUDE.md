# School Site -- Jekyll

Anton's school website. Published at https://gervi-hera-vitr.github.io/sindri-labs/

## Build

Just for reference -- use run configurations instead!
```zsh
cd site
bundle install
bundle exec jekyll build
bundle exec jekyll serve   # Local preview at localhost:4000/sindri-labs/
```

IMPORTANT: See convenience run configs at ${PROJECT_ROOT}/.run/**.xml
Use: 'Bundle Serve Local'

Requires Ruby (3.3.5) and Bundler. 
On self-hosted Linux runners (the farm) Ruby is installed as a system package.
On self-hosted Linux runners (Goo family), Linux local (workstations) and Mac OS X workstations,
Ruby is installed via asdf. Ruby version is dictated by Jekyll - OS parity compatibility.

## Theme

Minimal Mistakes (`mmistakes/minimal-mistakes`) with `sunrise` skin. Remote theme via `jekyll-remote-theme` plugin.

## Content Format

- Posts and pages are AsciiDoc (`.adoc`), not Markdown
- Posts go in `_posts/` with naming: `YYYY-MM-DD-Title.adoc` - Jekyll format.
- Pages go in `_pages/` with `permalink` front matter
- Front matter uses YAML between `---` delimiters at the top of `.adoc` files

## Collections -- Fragments and References

Two custom collections live alongside `_posts` and `_pages`:

- **`_fragments/`** -- small reusable pieces (paragraph or two), one per topic. Used for drilldowns from posts and as inline includes.
- **`_references/`** -- bibliographic entries, one per source. Used as footnote text and as bibliography includes.

Both render as their own pages, but do NOT appear in the main post feed. Subdirectories work: `_fragments/people/foo.adoc` becomes `/fragments/people/foo/`. The collection's permalink template (`/fragments/:path/`, `/references/:path/`) generates the URL automatically -- no need to set `permalink:` in front matter.

### The four working patterns

1. **Fragment as inline include** -- `include::../_fragments/foo.adoc[tag=body]` pastes the fragment body into the host document (post-time, before parse).
2. **Fragment as link** -- `link:{{ '/fragments/foo/' | relative_url }}[Title]` to link to the standalone page.
3. **Reference as footnote** -- `footnote:id[short text + link to the reference page]` defines the footnote once, then `footnote:id[]` (empty brackets) reuses it anywhere later in the same document.
4. **Reference as bibliography** -- `include::../_references/foo.adoc[tag=citation]` pulls the bibliographic line. `[tag=annotation]` pulls the descriptive note.

### Tagged regions

Mark content for include with:

```
// tag::body[]
...content...
// end::body[]
```

Standard tags: `body` for fragments, `citation` and `annotation` for references. Front matter is automatically excluded from any tagged include. Content outside the tags appears only on the standalone collection page.

### Constraint

`include::` is an AsciiDoc preprocessor directive and does NOT work inside `footnote:[]` brackets. So footnotes either inline their text or link out to a reference page. Define-once-then-reuse via `footnote:id[]` does work and is the right pattern for repeated citations.

### Examples

- `_fragments/people/democritus.adoc` -- demo fragment
- `_references/dirac-1928.adoc` -- demo reference

## Existing Content

- **Posts:** Welcome, school updates, book essays (Harry Potter, To Kill a Mockingbird, Go Set a Watchman), mathematics series (foundations through computation theory)
- **Pages:** About, curriculum, philosophy, mathematics, philosophers, science, semester, school year, contact, profile

## Site Author

"Mama Zaia" -- the bunny matriarch character. This is an intentional family flavor.

## Deployment

GitHub Actions: `site-build.yml` builds, `site-deploy.yml` deploys to GitHub Pages on push to main. Uses `actions/upload-pages-artifact` and `actions/deploy-pages`.

## Comments

Utterances (GitHub Issues-backed) configured for the repo.
