# School Site -- Jekyll

Anton's school website. Published at https://gervi-hera-vitr.github.io/sindri-labs/

## Build

Just for reference -- use run configurations instead!
```bash
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

## Existing Content

- **Posts:** Welcome, school updates, book essays (Harry Potter, To Kill a Mockingbird, Go Set a Watchman), mathematics series (foundations through computation theory)
- **Pages:** About, curriculum, philosophy, mathematics, philosophers, science, semester, school year, contact, profile

## Site Author

"Mama Zaia" -- the bunny matriarch character. This is an intentional family flavor.

## Deployment

GitHub Actions: `site-build.yml` builds, `site-deploy.yml` deploys to GitHub Pages on push to main. Uses `actions/upload-pages-artifact` and `actions/deploy-pages`.

## Comments

Utterances (GitHub Issues-backed) configured for the repo.
