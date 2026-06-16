# Thoughts in Flight

1. [ ] Review school content for slop;
2. [ ] Remove all the slop;
3. [ ] Grade particle;
4. [ ] Merge.

## In-flight (this branch, pre-compact 2026-06-16)

**De-slopped so far:** README.md; site/_pages/{about, contact, curriculum, profile-page, site-setup, philosophy, mathematics, science}.adoc; site/_posts/{2024-11-08-Welcome-to-my-School, 2025-06-26-Essay-On-Harry-Potter-Series}.adoc; PR template consolidated to `.github/pull_request_template.md`; issue template consolidated to `.github/issue_template.md`; project-wide Viskr→Viska (10 sites) + 6 brand corruption fixes (Herá, Cyrillic Hера/Hеrа, Mimir Academy).

**Pages migrate to a new `_documents/` collection (per Vadim's plan):**
- The three pages already declaring `categories: [page]` and `tags: [graded]` in their YAML front matter:
  - `site/_pages/philosophy.adoc`
  - `site/_pages/philosophers.adoc`
  - `site/_pages/mathematics.adoc`
- Reason: they want to participate in tag archives. `jekyll-archives` (2.3.0) is already wired in `site/Gemfile` and `site/_config.yml:227–234`. New `_documents` collection added to archive config = tag archive includes them.
- Permalinks preserved per-item via front matter (`/philosophy/`, `/philosophers/`, `/mathematics/`).
- Migration not yet started.

**Remaining `_posts/` to scan for slop:**
- Essay-On-How-To-Kill-A-Mocking-Bird, Essay-On-Go-Set-A-Watchman (literary, expected clean)
- On-Mathematics, On-Foundations-Of-Mathematics, On-Mathematics-Set-Theory, On-Mathematics-Complexity-Theory, On-Mathematics-Category-Theory, On-Godel-Incompleteness-Theorem, On-Computation-Theory, On-Set-Theory (math series — survey flagged em-dashes + curly apos in some)
- 2026-05-08-On-Particle (already scanned earlier this session — clean modulo "Captain here" comment)

**Tag enrichment open question:** literary essays currently `[essay]`; math posts use richer `[mathematics, theory, <topic>]`. Proposed parallel `[literature, analysis, <work>, essay]` for literary essays — pending Vadim's decision and possibly a documented tagging convention.

**Tier 4 deferred (file renames at the very end):** image-anton.jpg → image-captain.jpg; banner-anton.jpg → banner-captain.jpg; avatar-anton.jpg → avatar-captain.jpg.
