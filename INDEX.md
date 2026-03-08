# Thoughts in Flight

Clear before merging.

## Infrastructure Upgrade

- [x] Bump .sdkmanrc (java 21.0.9-tem, kotlin 2.3.10, scala 3.8.2, gradle 9.3.1, sbt 1.12.4)
- [x] Upgrade Gradle wrapper to 9.3.1
- [x] Migrate version properties to libs.versions.toml
- [x] Fix settings.gradle.kts -- restore `by extra` for buildscript-level plugins (foojay, develocity)
- [x] Remove dead TOML entries for `foojay`/`develocity`
- [x] Clean up git submodules (local/, production/echoes, .gitmodules)
- [x] Set up .claude/settings.json
- [x] Build passes (18 tasks, all tests green)

### GitHub Actions

- [x] Update action-runner-introspect toolchain versions (`gradle`, `kotlin`, `sbt`, `scala`)
- [x] Delete agents-factor-12.yml (all placeholder echo steps)
- [x] Bump codeql-action v4.31.9 -> v4.32.6
- [x] Bump gradle/actions v5.0.0 -> v5.0.2
- [x] stale.yml: continue-on-error, stats, disk space check -- pre-existing fix for stale action tmp bug

## CLAUDE.md Files

- [ ] Root CLAUDE.md -- project identity, build, conventions, who Anton is, Mimir Academy
- [ ] curriculum/CLAUDE.md -- grading standards, document format, academic expectations
- [ ] curriculum/Psychology/CLAUDE.md -- what's covered, resources, assessment
- [ ] curriculum/Mathematics/CLAUDE.md
- [ ] curriculum/History/CLAUDE.md
- [ ] curriculum/Engineering/CLAUDE.md
- [ ] curriculum/Biology/CLAUDE.md
- [ ] curriculum/Physics/CLAUDE.md
- [ ] curriculum/Business/CLAUDE.md
- [ ] site/CLAUDE.md -- Jekyll build, post format, theme
- [ ] journey/CLAUDE.md -- Gradle subproject, purpose
- [ ] lab-ux-ktor/CLAUDE.md -- Ktor lab, build, run

## Anton's Psychology Semester Closeout

Grading summary from review:

| Document                  | Topic                                                                    | Assessment                                                                      |
|---------------------------|--------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| HowToLearn.adoc           | Learning science -- retrieval practice, spaced repetition, consolidation | Excellent. Effect sizes cited, 118-study meta-analyses. Professional-level.     |
| BrainHealthPt1.adoc       | Risk factors -- sleep, substances, head injuries, stress, toxins         | Excellent. Glymphatic system, BMJ 2025, Dunedin Study. Honest evidence ratings. |
| BrainHealthPt2.adoc       | Positive interventions -- exercise, nutrition, cognitive training        | Excellent. BDNF mechanisms, MIND diet data, specific dosing.                    |
| Neuron.adoc               | Neuronal structure, signaling, synaptic plasticity                       | Excellent. Graduate-level depth. Action potentials, NMDA, LTP/LTD.              |
| Expertise.adoc            | Expertise framework, chunking, deliberate practice                       | Excellent. Chase & Simon, Tetlock's 82K predictions.                            |
| YaleLectureNineNotes.adoc | Yale PSYC 110 -- love, attraction, Sternberg's theory                    | Very good. Methodological critique, androcentric bias noted.                    |

### Post-Merge Plan (sub-issues under #494)

- [ ] Grade Anton's psychology semester -- formal assessment, produce grade sheet
- [ ] Recover missing work -- fieldwork logs from ASE internship, anything outside repo
- [ ] Create review cheatsheets on school site for each major topic
- [ ] Revalidate school site -- Jekyll builds, content current, links work
- [ ] Plan sciences semester -- verify Q4 curriculum, set up structure

## Open Questions

- stale.yml: 9 new lines added on this branch -- Vadim, was that intentional?
- Issue #348 filed for Shift #8 investigation (plan-of-attack repo)
