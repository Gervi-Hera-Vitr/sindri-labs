export const meta = {
  name: 'group-discovery-images',
  description: 'Research + install discovery images (apparatus / diagram) for 3 group fragments',
  phases: [
    { title: 'Research', detail: 'Per-group Wikipedia/Commons lookup for the iconic visual of the work itself' },
    { title: 'Install',  detail: 'Per-group curl|magick fit-pad to 500x600, edit fragment frontmatter' },
  ],
}

const ROOT = '/Users/rdd13r/IdeaProjects/Gervi-Hera-Vitr/sindri-labs'

const GROUPS = [
  {
    slug: 'geiger-marsden',
    name: 'Geiger-Marsden gold-foil experiment',
    description: 'The 1909 gold-foil / alpha-scattering experiment that revealed the atomic nucleus.',
    visualHints: 'Schematic of the scattering geometry (radium source → gold foil → scintillation screen showing alpha deflections), OR the historical apparatus diagram from the original paper, OR the famous expectation-vs-result side-by-side diagram. AVOID portraits.',
  },
  {
    slug: 'bothe-becker-joliot-curies',
    name: 'Bothe-Becker / Joliot-Curies neutron-precursor experiments',
    description: 'The chain of 1930-1932 experiments (alpha-on-beryllium produces penetrating radiation, then proton recoils from paraffin) that produced neutron data without recognizing it.',
    visualHints: 'Schematic of the polonium/radium-alpha → beryllium → paraffin → proton-recoil chain, OR a diagram of Bothe coincidence detection, OR the Joliot-Curies apparatus photo, OR a schematic from Chadwick\'s 1932 neutron paper that references this chain. AVOID portraits.',
  },
  {
    slug: 'brout-englert-ghk',
    name: 'Brout-Englert-Higgs (BEH) mechanism',
    description: 'The 1964 mass-generation mechanism — three independent papers (Brout-Englert; Higgs; Guralnik-Hagen-Kibble).',
    visualHints: 'The Mexican-hat / wine-bottle Higgs potential V(φ) = -μ²|φ|² + λ|φ|⁴, OR a Feynman diagram of the Higgs interaction, OR a spontaneous-symmetry-breaking diagram. The Mexican-hat potential is the canonical visual. AVOID portraits.',
  },
]

const RESEARCH_SCHEMA = {
  type: 'object',
  required: ['slug', 'hasImage', 'imageUrl', 'credit', 'notes'],
  properties: {
    slug: { type: 'string' },
    hasImage: { type: 'boolean', description: 'true if a usable, freely-licensed diagram/apparatus image was found' },
    imageUrl: { type: 'string', description: 'direct URL to a JPG/PNG file. For SVGs on Commons, prefer the PNG thumbnail URL (https://upload.wikimedia.org/wikipedia/commons/thumb/.../800px-FILE.svg.png). Empty string if hasImage=false.' },
    credit: { type: 'string', description: 'Single-line attribution suitable for :page-image-credit:. Plain ASCII straight quotes only. Empty string if hasImage=false.' },
    notes: { type: 'string', description: 'Brief caveat: what is depicted, license, any context.' },
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

const researchPrompt = (g) => [
  `Find a freely-licensed diagram or apparatus image representing **${g.name}**.`,
  ``,
  `WHAT THE PAGE IS ABOUT:`,
  g.description,
  ``,
  `WHAT TO LOOK FOR:`,
  g.visualHints,
  ``,
  `PROCESS:`,
  `1. Use WebFetch on the relevant Wikipedia article(s). Likely targets:`,
  `   - For geiger-marsden: https://en.wikipedia.org/wiki/Geiger-Marsden_experiments or https://en.wikipedia.org/wiki/Rutherford_scattering_experiments`,
  `   - For bothe-becker-joliot-curies: https://en.wikipedia.org/wiki/Discovery_of_the_neutron or https://en.wikipedia.org/wiki/Walther_Bothe`,
  `   - For brout-englert-ghk: https://en.wikipedia.org/wiki/Higgs_mechanism or https://en.wikipedia.org/wiki/Mexican_hat_potential`,
  `2. Locate the canonical diagram. For SVGs, find the PNG render URL on upload.wikimedia.org (pattern: /thumb/<path>/<file>.svg/800px-<file>.svg.png). For JPG/PNG, use the direct upload.wikimedia.org URL.`,
  `3. Verify licensing on the Commons file page. Accept: PD, CC0, CC-BY, CC-BY-SA. Reject anything more restrictive.`,
  ``,
  `OUTPUT FIELDS:`,
  `- imageUrl: direct upload.wikimedia.org URL to a JPG or PNG file (NOT the file description page; the actual image bytes).`,
  `- credit: one line: "<Description>. <License> via Wikimedia Commons." Use straight ASCII quotes only. Example: "Geiger-Marsden expected-vs-observed scattering diagram. CC-BY-SA 3.0 via Wikimedia Commons."`,
  `- notes: what the image depicts in one phrase, plus any caveat.`,
  ``,
  `The slug is "${g.slug}". Return it verbatim in the output.`,
].join('\n')

const installPrompt = (g, research) => [
  `Install a discovery diagram for **${g.name}** into the Sindri Labs fragments system.`,
  ``,
  `INPUT:`,
  `- slug: ${g.slug}`,
  `- imageUrl: ${research.imageUrl}`,
  `- credit: ${research.credit}`,
  `- notes: ${research.notes}`,
  ``,
  `STEPS:`,
  `1. Download + FIT (not cover-crop) into 500x600, padding with white so the whole diagram is visible:`,
  `   curl -sL '${research.imageUrl}' | magick - -resize '500x600' -background white -gravity center -extent 500x600 -strip -interlace JPEG -quality 90 ${ROOT}/site/assets/images/people/${g.slug}.jpg`,
  ``,
  `   NOTE: NO caret on resize. Cover-crop chops diagrams; fit-pad preserves them.`,
  ``,
  `2. Verify file exists and is >3KB (diagrams can be smaller than portraits):`,
  `   ls -la ${ROOT}/site/assets/images/people/${g.slug}.jpg`,
  `   If size is suspiciously small (<3KB) or magick errored, return installed=false with the diagnostic.`,
  ``,
  `3. Edit ${ROOT}/site/_fragments/people/${g.slug}.adoc using the Edit tool. Read the file first if you have not this session, then make TWO edits:`,
  `   - Replace ":page-image: placeholder.jpg" with ":page-image: ${g.slug}.jpg"`,
  `   - Replace ":page-image-credit: \\"change me\\"" with ":page-image-credit: \\"${research.credit.replace(/"/g, '\\\\"')}\\""`,
  ``,
  `4. Return installed=true and a one-line success message, OR installed=false with the failing step error.`,
].join('\n')

const results = await pipeline(
  GROUPS,
  (g) => agent(researchPrompt(g), {
    label: `research:${g.slug}`,
    phase: 'Research',
    schema: RESEARCH_SCHEMA,
    agentType: 'Explore',
  }),
  async (research, g) => {
    if (!research || !research.hasImage) {
      return {
        slug: g.slug,
        installed: false,
        message: research ? `no-image: ${research.notes || 'researcher reported no usable image'}` : 'research failed',
      }
    }
    return agent(installPrompt(g, research), {
      label: `install:${g.slug}`,
      phase: 'Install',
      schema: INSTALL_SCHEMA,
    })
  }
)

const safe = results.filter(Boolean)
const installed = safe.filter((r) => r.installed)
const skipped = safe.filter((r) => !r.installed)

log(`Installed: ${installed.length}/${GROUPS.length}`)
log(`Skipped:   ${skipped.length}/${GROUPS.length}`)
for (const s of skipped) log(`  - ${s.slug}: ${s.message}`)

return { installed, skipped, all: safe }
