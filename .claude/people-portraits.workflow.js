export const meta = {
  name: 'people-portraits',
  description: 'Research + install 500x600 portraits for 13 people fragments in Sindri Labs',
  phases: [
    { title: 'Research', detail: 'Per-person Wikipedia lookup, direct image URL + credit' },
    { title: 'Install',  detail: 'Per-person curl|magick to assets dir, edit fragment frontmatter' },
  ],
}

const ROOT = '/Users/rdd13r/IdeaProjects/Gervi-Hera-Vitr/sindri-labs'

const PEOPLE = [
  { slug: 'anderson',   name: 'Carl David Anderson', hint: 'American physicist, 1905-1991, positron discovery' },
  { slug: 'bohr',       name: 'Niels Bohr',          hint: 'Danish physicist, 1885-1962, atomic model' },
  { slug: 'chadwick',   name: 'James Chadwick',      hint: 'British physicist, 1891-1974, neutron discovery' },
  { slug: 'dalton',     name: 'John Dalton',         hint: 'English chemist, 1766-1844, atomic theory' },
  { slug: 'democritus', name: 'Democritus',          hint: 'Greek pre-Socratic philosopher, c.460-370 BCE, atomism' },
  { slug: 'dirac',      name: 'Paul Dirac',          hint: 'British physicist, 1902-1984, quantum mechanics' },
  { slug: 'gassendi',   name: 'Pierre Gassendi',     hint: 'French philosopher and priest, 1592-1655, revived atomism' },
  { slug: 'gell-mann',  name: 'Murray Gell-Mann',    hint: 'American physicist, 1929-2019, quark model' },
  { slug: 'higgs',      name: 'Peter Higgs',         hint: 'British physicist, 1929-2024, Higgs mechanism' },
  { slug: 'leucippus',  name: 'Leucippus',           hint: 'Greek pre-Socratic philosopher, c.5th century BCE, originator of atomism' },
  { slug: 'rutherford', name: 'Ernest Rutherford',   hint: 'New Zealand and British physicist, 1871-1937, nuclear model' },
  { slug: 'thomson',    name: 'J. J. Thomson',       hint: 'British physicist, 1856-1940, electron discovery' },
  { slug: 'zweig',      name: 'George Zweig',        hint: 'American physicist, b. 1937, quark/ace model' },
]

const RESEARCH_SCHEMA = {
  type: 'object',
  required: ['slug', 'hasImage', 'imageUrl', 'credit', 'isContemporaryLikeness', 'notes'],
  properties: {
    slug: { type: 'string' },
    hasImage: { type: 'boolean', description: 'true if a usable freely-licensed portrait or likeness was found' },
    imageUrl: { type: 'string', description: 'direct URL to a JPG/PNG file, typically on upload.wikimedia.org. Empty string if hasImage=false.' },
    credit: { type: 'string', description: 'Single-line attribution suitable for :page-image-credit:. Empty string if hasImage=false. No newlines. Plain ASCII straight quotes only.' },
    isContemporaryLikeness: { type: 'boolean', description: 'true if portrait was made during the subject lifetime; false for posthumous or imagined likenesses.' },
    notes: { type: 'string', description: 'Brief caveat: license type, Roman copy, imagined likeness, etc.' },
  },
}

const INSTALL_SCHEMA = {
  type: 'object',
  required: ['slug', 'installed', 'message'],
  properties: {
    slug: { type: 'string' },
    installed: { type: 'boolean' },
    message: { type: 'string', description: 'One-line confirmation or one-line error reason' },
  },
}

const researchPrompt = (p) => [
  `Find a freely-licensed portrait for **${p.name}** (${p.hint}).`,
  ``,
  `PROCESS:`,
  `1. Use WebFetch on the Wikipedia article. Try https://en.wikipedia.org/wiki/<best-guess-slug> first; if 404, try WebSearch.`,
  `2. Locate the lead infobox image. Click through to the file Original file URL on upload.wikimedia.org. That is the direct image URL we want (ends in .jpg, .jpeg, or .png).`,
  `3. Read the licensing on the Wikimedia Commons file page. Accept: public domain, CC0, CC-BY, CC-BY-SA. Reject anything more restrictive.`,
  ``,
  `OUTPUT FIELDS:`,
  `- imageUrl: direct upload.wikimedia.org URL (NOT the file description page; the actual image bytes).`,
  `- credit: format as one line: "<Description>. <License> via Wikimedia Commons." Example: "Portrait by Sir Godfrey Kneller (1689). Public domain via Wikimedia Commons." Use straight ASCII quotes only. No curly quotes, no em-dashes.`,
  `- isContemporaryLikeness: true only if the portrait or photo was made during the subject lifetime.`,
  `- notes: brief caveat if needed (Roman marble copy of Hellenistic original; engraving, 17th c., imagined likeness; no individual likeness exists; etc.).`,
  ``,
  `SPECIAL CASES:`,
  `- Democritus: ancient busts exist (often as laughing-philosopher tradition). Roman copies of Greek originals are acceptable; mark isContemporaryLikeness=false.`,
  `- Leucippus: research carefully. If no individual portrayal exists in Wikipedia or Commons, set hasImage=false with a note explaining.`,
  ``,
  `The slug is "${p.slug}". Return it verbatim in the output.`,
].join('\n')

const installPrompt = (p, research) => [
  `Install a portrait for **${p.name}** into the Sindri Labs people-fragments system.`,
  ``,
  `INPUT:`,
  `- slug: ${p.slug}`,
  `- imageUrl: ${research.imageUrl}`,
  `- credit: ${research.credit}`,
  `- notes: ${research.notes}`,
  ``,
  `STEPS:`,
  `1. Download + crop in one pipe (no original on disk):`,
  `   curl -sL '${research.imageUrl}' | magick - -resize '500x600^' -gravity center -extent 500x600 -strip -interlace JPEG -quality 88 ${ROOT}/site/assets/images/people/${p.slug}.jpg`,
  ``,
  `2. Verify file exists and is >5KB:`,
  `   ls -la ${ROOT}/site/assets/images/people/${p.slug}.jpg`,
  `   If size is suspiciously small (<5KB) or magick errored, return installed=false with the diagnostic.`,
  ``,
  `3. Edit ${ROOT}/site/_fragments/people/${p.slug}.adoc using the Edit tool. Read the file first if you have not this session, then make TWO edits:`,
  `   - Replace ":page-image: placeholder.jpg" with ":page-image: ${p.slug}.jpg"`,
  `   - Replace ":page-image-credit: \\"change me\\"" with ":page-image-credit: \\"${research.credit.replace(/"/g, '\\\\"')}\\""`,
  ``,
  `4. Return installed=true and a one-line success message if all steps succeeded, OR installed=false with the failing step error.`,
  ``,
  `NOTE on quoting: keep single quotes around the URL in the curl command. The credit string for the Edit tool should be passed exactly as given.`,
].join('\n')

const results = await pipeline(
  PEOPLE,
  (p) => agent(researchPrompt(p), {
    label: `research:${p.slug}`,
    phase: 'Research',
    schema: RESEARCH_SCHEMA,
    agentType: 'Explore',
  }),
  async (research, p) => {
    if (!research || !research.hasImage) {
      return {
        slug: p.slug,
        installed: false,
        message: research ? `no-image: ${research.notes || 'researcher reported no usable image'}` : 'research failed',
      }
    }
    return agent(installPrompt(p, research), {
      label: `install:${p.slug}`,
      phase: 'Install',
      schema: INSTALL_SCHEMA,
    })
  }
)

const safe = results.filter(Boolean)
const installed = safe.filter((r) => r.installed)
const skipped = safe.filter((r) => !r.installed)

log(`Installed: ${installed.length}/${PEOPLE.length}`)
log(`Skipped:   ${skipped.length}/${PEOPLE.length}`)
for (const s of skipped) log(`  - ${s.slug}: ${s.message}`)

return { installed, skipped, all: safe }
