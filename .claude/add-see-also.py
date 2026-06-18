#!/usr/bin/env python3
"""
Insert in-body "see also" lateral-nav line in people fragments.

Pattern (matches site/_posts/mathematics nav style; internal links, no window=_blank):

  _**↑ {all-people}**_ | _**{see-<slug1>}**_ · _**{see-<slug2>}**_

Attribute defs live in the doc header (alongside :page-image:).
Nav line goes immediately after the image:: macro.

Usage:
  python3 add-see-also.py [--only SLUG[,SLUG...]] [--dry-run]
"""
import argparse
import glob
import os
import re

import yaml

ROOT = "/Users/rdd13r/IdeaProjects/Gervi-Hera-Vitr/sindri-labs"
PEOPLE_DIR = f"{ROOT}/site/_fragments/people"

FM_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
# noinspection RegExpRedundantEscape
IMAGE_LINE_RE = re.compile(
    r"^(image::\{page-image\}\[\{page-image-credit\}[^\]]*\])\n",
    re.MULTILINE,
)
EXISTING_NAV_RE = re.compile(r"^:all-people:", re.MULTILINE)

def load_frontmatter(content):
    m = FM_RE.match(content)
    if not m: return None
    try: return yaml.safe_load(m.group(1)) or {}
    except Exception: return None

def build_name_map():
    name_map = {}
    for path in sorted(glob.glob(f"{PEOPLE_DIR}/*.adoc")):
        slug = os.path.basename(path)[:-5]
        with open(path) as f: content = f.read()
        fm = load_frontmatter(content) or {}
        if fm.get("name"):
            name_map[slug] = fm["name"]
            continue
        # group / synopsis: derive a short label
        # try first heading line; for groups it's long, use slug-title-cased
        name_map[slug] = slug.replace("-", " ").title()
    return name_map

def related_for(fm):
    rel = fm.get("related")
    if isinstance(rel, list) and rel:
        return rel
    if fm.get("synopsis_of"):
        return [fm["synopsis_of"]]
    return []

def make_block(slug, related, name_map):
    lines = [":all-people: link:/sindri-labs/people/[All People]"]
    seen = set()
    for r in related:
        if r in seen: continue
        seen.add(r)
        label = name_map.get(r, r.replace("-", " ").title())
        lines.append(f":see-{r}: link:/sindri-labs/fragments/people/{r}/[{label}]")
    attr_block = "\n".join(lines)

    nav_left = "_**↑ {all-people}**_"
    if related:
        lateral = " · ".join(f"_**{{see-{r}}}**_" for r in related)
        nav = f"{nav_left} | {lateral}"
    else:
        nav = nav_left
    return attr_block, nav

def transform(path, name_map):
    slug = os.path.basename(path)[:-5]
    with open(path) as f: content = f.read()
    fm = load_frontmatter(content)
    if fm is None: return None, "no-frontmatter"
    if EXISTING_NAV_RE.search(content):
        return None, "already-has-nav"
    related = related_for(fm)
    attr_block, nav = make_block(slug, related, name_map)

    # Insert attribute defs into doc header: right after :page-image-credit: line.
    credit_re = re.compile(r"^(:page-image-credit:[^\n]*\n)", re.MULTILINE)
    if not credit_re.search(content):
        return None, "no-page-image-credit"
    content_v2 = credit_re.sub(rf"\1{attr_block}\n", content, count=1)

    # Insert nav line immediately after the image:: macro.
    if not IMAGE_LINE_RE.search(content_v2):
        return None, "no-image-macro"
    content_v3 = IMAGE_LINE_RE.sub(rf"\1\n\n{nav}\n", content_v2, count=1)

    if content_v3 == content:
        return None, "no-change"
    return content_v3, "ok"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", help="comma-separated slugs")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    name_map = build_name_map()
    paths = sorted(glob.glob(f"{PEOPLE_DIR}/*.adoc"))
    if args.only:
        wanted = set(args.only.split(","))
        paths = [p for p in paths if os.path.basename(p)[:-5] in wanted]

    counts = {"ok": 0, "already-has-nav": 0, "skip": 0}
    for p in paths:
        slug = os.path.basename(p)[:-5]
        new, status = transform(p, name_map)
        if status == "ok":
            counts["ok"] += 1
            if args.dry_run:
                print(f"DRY {slug}: would write")
            else:
                with open(p, "w") as f: f.write(new)
                print(f"OK  {slug}")
        elif status == "already-has-nav":
            counts["already-has-nav"] += 1
            print(f"-   {slug}: already has nav")
        else:
            counts["skip"] += 1
            print(f"!   {slug}: {status}")

    print(f"\nsummary: ok={counts['ok']} already={counts['already-has-nav']} skip={counts['skip']}")

if __name__ == "__main__":
    main()
