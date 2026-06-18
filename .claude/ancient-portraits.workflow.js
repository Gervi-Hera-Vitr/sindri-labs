export const meta = {
  name: 'ancient-portraits',
  description: 'Research + install 500x600 portraits for 14 ancient/medieval people fragments in Sindri Labs',
  phases: [
    { title: 'Research', detail: 'Per-person Wikipedia lookup, direct image URL + credit' },
    { title: 'Install',  detail: 'Per-person curl|magick to assets dir, edit fragment frontmatter' },
  ],
}

const ROOT = '/Users/rdd13r/IdeaProjects/Gervi-Hera-Vitr/sindri-labs'

const PEOPLE = [
  { slug: 'al-khwarizmi',    name: 'Muhammad ibn Musa al-Khwarizmi', hint: 'Persian polymath, c.780-c.850, algebra and Hindu-Arabic numerals' },
  { slug: 'archimedes',      name: 'Archimedes of Syracuse',         hint: 'Greek mathematician/physicist, c.287-c.212 BCE, geometry and mechanics' },
  { slug: 'aristotle',       name: 'Aristotle',                      hint: 'Greek philosopher, 384-322 BCE, logic, physics, metaphysics' },
  { slug: 'epictetus',       name: 'Epictetus',                      hint: 'Greek Stoic philosopher, c.50-c.135 CE, Discourses and Enchiridion' },
  { slug: 'euclid',          name: 'Euclid of Alexandria',           hint: 'Greek mathematician, mid-4th century BCE - mid-3rd century BCE, Elements' },
  { slug: 'fibonacci',       name: 'Leonardo Fibonacci',             hint: 'Italian mathematician, c.1170-c.1250, Liber Abaci, Fibonacci sequence' },
  { slug: 'khayyam',         name: 'Omar Khayyam',                   hint: 'Persian polymath, 1048-1131, algebra of cubics, astronomy, Rubaiyat' },
  { slug: 'marcus-aurelius', name: 'Marcus Aurelius',                hint: 'Roman emperor and Stoic philosopher, 121-180 CE, Meditations' },
  { slug: 'plato',           name: 'Plato',                          hint: 'Greek philosopher, c.428-c.348 BCE, Academy, Theory of Forms' },
  { slug: 'pythagoras',      name: 'Pythagoras of Samos',            hint: 'Greek philosopher/mathematician, c.570-c.495 BCE, Pythagorean theorem' },
  { slug: 'seneca',          name: 'Seneca the Younger',             hint: 'Roman Stoic philosopher and statesman, c.4 BCE-65 CE, Letters and tragedies' },
  { slug: 'socrates',        name: 'Socrates',                       hint: 'Greek philosopher, c.470-399 BCE, Socratic method, executed in Athens' },
  { slug: 'thales',          name: 'Thales of Miletus',              hint: 'Greek pre-Socratic philosopher, c.624-c.546 BCE, first natural philosopher' },
  { slug: 'zeno-of-citium',  name: 'Zeno of Citium',                 hint: 'Greek philosopher, c.334-c.262 BCE, founder of Stoicism (distinct from Zeno of Elea)' },
]

const RESEARCH_SCHEMA = {
  type: 'object',
  required: ['slug', 'hasImage', 'imageUrl', 'credit', 'isContemporaryLikeness', 'notes'],
  properties: {
    slug: { type: 'string' },
    hasImage: { type: 'boolean', description: 'true if a usable freely-licensed portrait or likeness was found' },
    imageUrl: { type: 'string', description: 'direct URL to a JPG/PNG file, typically on upload.wikimedia.org. Empty string if hasImage=false.' },
    credit: { type: 'string', description: 'Single-line attribution suitable for :page-image-credit:. Empty string if hasImage=false. No newlines. Plain ASCII straight quotes only.' },
    isContemporaryLikeness: { type: 'boolean', description: 'true if portrait was made during the subject lifetime; false for posthumous, Roman copy, or imagined likenesses.' },
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
  `Find a freely-licensed portrait or likeness for **${p.name}** (${p.hint}).`,
  ``,
  `PROCESS:`,
  `1. Use WebFetch on the Wikipedia article. Try https://en.wikipedia.org/wiki/<best-guess-slug> first; if 404, try WebSearch.`,
  `2. Locate the lead infobox image (or the most representative likeness in the article). Click through to the file Original file URL on upload.wikimedia.org. That is the direct image URL we want (ends in .jpg, .jpeg, or .png).`,
  `3. Read the licensing on the Wikimedia Commons file page. Accept: public domain, CC0, CC-BY, CC-BY-SA. Reject anything more restrictive.`,
  ``,
  `OUTPUT FIELDS:`,
  `- imageUrl: direct upload.wikimedia.org URL (NOT the file description page; the actual image bytes).`,
  `- credit: format as one line: "<Description>. <License> via Wikimedia Commons." Example: "Roman marble bust, 2nd century copy of Hellenistic original. Public domain via Wikimedia Commons." Use straight ASCII quotes only. No curly quotes, no em-dashes.`,
  `- isContemporaryLikeness: true only if the portrait was made during the subject lifetime. For ancients, this is almost always false (Roman copies of Greek originals, medieval imagined likenesses, etc.).`,
  `- notes: brief caveat (Roman marble copy of Hellenistic original; medieval imagined portrait; bust; engraving 17th c.; etc.).`,
  ``,
  `SPECIAL CASES (ancient/medieval — most subjects here):`,
  `- For Greek philosophers and mathematicians, Roman marble copies of Hellenistic bronze originals are the standard accepted likeness. Mark isContemporaryLikeness=false but hasImage=true.`,
  `- For medieval figures (al-Khwarizmi, Fibonacci, Khayyam), accept later commemorative statues, manuscript illustrations, or modern portraits if they're the canonical Wikipedia infobox image.`,
  `- For Socrates: the Louvre / British Museum / Vatican bust(s) are standard.`,
  `- For Thales / Pythagoras / Zeno of Citium: imagined likenesses on Roman busts are acceptable.`,
  `- Make sure you do NOT confuse Zeno of Citium (Stoic founder) with Zeno of Elea (paradoxes). The slug is "zeno-of-citium".`,
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
