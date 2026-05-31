# AzAWSLab Portfolio Refresh Tracker

| Area | Status | Reader signal |
|---|---:|---|
| 🟢 Platform Status | Public Ready | Portfolio and evidence are safe for public review |
| 🔵 Release 1 | Workplace & Identity | Hybrid modern workplace, identity, endpoint, security, and recovery |
| 🟢 Release 2 | Platform Engineering | Terraform, AKS, AVD, multi-cloud, AWX, security, and AI enclave |
| ⚪ Release 3 | Multi-Cloud Roadmap | DevSecOps, Argo CD, and multi-cloud platform roadmap |

## Purpose

This tracker controls the AzAWSLab portfolio refresh so the frontend website and GitHub documentation become a consistent, premium, evidence-backed cloud engineering portfolio.

The refresh must improve presentation quality without inventing claims, weakening the project narrative, or creating inconsistent documentation styles.

## Working branch

`feature/portfolio-premium-refresh`

## Portfolio model

| Layer | Purpose | Audience | Content style |
|---|---|---|---|
| 🌐 Frontend website | Public portfolio and case-study presentation | Recruiters, hiring managers, technical reviewers | Polished, guided, visual, concise |
| 📦 GitHub repository | Technical backend and source-of-truth evidence | Engineers, architects, security reviewers | Detailed, evidence-linked, implementation-focused |
| 🧾 Evidence folders | Proof layer | Technical reviewers | Screenshots, CLI evidence, workflow output, diagrams, validation notes |

## Core operating rules

- Work in one feature branch.
- Do not push directly from `main`.
- Use multiple focused local commits.
- Keep push commands separate from commit commands.
- Do not use `git add .`.
- Do not rewrite unrelated files.
- Do not start writing before auditing the relevant files.
- Do not edit before comparing existing content with the proposed replacement.
- Do not invent implementation details.
- Do not add claims without evidence.
- Update this tracker at the end of every phase.
- Check encoding and mojibake before every commit.
- Preserve emoji/status-style scanning tables in GitHub Markdown.
- Remove duplicate flat tables where they repeat the same information.
- Use visual chips/badges on frontend pages.
- Do not use weak public headers such as `Part of`, `Best for`, or `Purpose`.
- Do not use the word `showroom`.
- Keep implemented, evidenced, design-standard, and roadmap content clearly separated.

## Approved presentation direction

| Decision | Approved standard |
|---|---|
| Portfolio positioning | Evidence-backed Azure, hybrid, and multi-cloud platform engineering portfolio |
| Primary role alignment | Azure Engineer, Cloud Engineer, Cloud Platform Engineer |
| Secondary role alignment | Multi-Cloud Platform Engineer, Infrastructure Engineer, Infrastructure Architect |
| Advanced credibility layer | Cloud Architect, Security Architect, DevOps / SRE Engineer |
| Writing tone | Human, experienced, organised, confident, evidence-led, architect-level |
| Frontend style | Public portfolio and case-study presentation |
| GitHub style | Technical backend, source of truth, and evidence record |
| Release 1 evidence | Curated screenshots on frontend, deeper evidence in GitHub |
| Release 2 evidence | Selected proof and text diagrams on frontend, deeper CLI/workflow evidence in GitHub |
| Lessons learned page | Convert to Architectural Decisions and Operational Insights |
| Homepage requirement | Must explain what the project is, what is inside, intent, proof, audience, and evidence location |

## Content standards

### Frontend page standard

Every major frontend page should follow this pattern:

1. Title
2. Visual status chips/badges
3. Strong opening explanation
4. What this page proves
5. Architecture snapshot
6. Key capabilities
7. Selected proof
8. Reviewer takeaway
9. Deeper GitHub evidence
10. Next recommended page

### GitHub backend Markdown standard

Every major GitHub Markdown page should follow this pattern:

1. Title
2. Emoji/status scanning table
3. Purpose
4. Scope
5. Architecture model
6. Implementation summary
7. Terraform, Ansible, AWX, workflow, or evidence wiring where relevant
8. Evidence map
9. Validation notes
10. Reviewer takeaway
11. Related files

### Evidence page standard

Every evidence page or evidence section should explain:

1. Evidence item
2. Capability proven
3. Evidence type: screenshot, CLI, workflow, diagram, config, or validation note
4. What the reviewer should verify
5. Related implementation file
6. Redaction note where required

## Writing quality rules

Use wording that feels:

- Human
- Experienced
- Organised
- Confident
- Evidence-led
- Architect-level
- Calm and precise
- Premium portfolio quality

Avoid wording that feels:

- AI-generated
- Scaffold-like
- Defensive
- Salesy
- Intern-level
- Overexplained without evidence
- Like internal documentation metadata
- Like trial-and-error notes

## Banned or discouraged wording

| Avoid | Use instead |
|---|---|
| showroom | portfolio, case study, evidence-backed platform record |
| I tried | implemented, validated, designed, tested |
| failed because | validated a guardrail, confirmed a policy boundary |
| not completed | roadmap, future extension, intentionally scoped |
| basic lab | production-style lab, enterprise-pattern implementation, lab-validated platform |
| simple setup | controlled implementation, scoped platform pattern |
| just a demo | evidence-backed portfolio implementation |
| Part of / Best for / Purpose header | visual chips on frontend, emoji/status table in GitHub |
| maybe / probably | state only what is evidenced or mark as not confirmed |

## Evidence-safe claim model

Every major claim must map to one of these categories:

| Category | Meaning | Allowed public wording |
|---|---|---|
| ✅ Implemented and evidenced | Implementation and proof both exist | Evidence-backed implementation |
| 🟡 Implemented, evidence needs linking | Work exists but evidence path needs improvement | Implemented capability with evidence to be linked |
| 🔵 Documented design standard | Architecture/design exists, implementation evidence is not the main claim | Documented design standard |
| ⚪ Roadmap | Future or planned work | Roadmap extension |
| 🔴 Reword or remove | Claim is unsupported, unclear, or risky | Do not publish until fixed |

## Guardrail and failed-evidence wording

If evidence shows a blocked or failed validation, do not present it as weakness. Classify what it proves.

| Evidence pattern | Stronger interpretation |
|---|---|
| Policy blocked deployment | Governance enforcement validated |
| Single-region DR blocked | Recovery design boundary confirmed |
| Route did not follow expected path | Routing/inspection boundary identified |
| Permission denied | RBAC or least-privilege control validated |
| Workflow failed safely | Delivery guardrail validated |
| Missing final screenshot | Do not claim success evidence; describe the evidenced control boundary |

## Phase tracker

| Phase | Scope | Status | Files changed | Evidence checked | Encoding checked | Commit |
|---|---|---:|---|---|---:|---|
| 0 | Branch and baseline tracker | In progress | `PORTFOLIO_REFRESH_TRACKER.md` | Not started | Pending | Pending |
| 1 | Audit and source-of-truth map | Pending |  |  |  |  |
| 2 | Content, navigation, and writing standard | Pending |  |  |  |  |
| 3 | Homepage and frontend shell | Pending |  |  |  |  |
| 4 | GitHub root documentation cleanup | Pending |  |  |  |  |
| 5 | Release 1 normalization | Pending |  |  |  |  |
| 6 | Release 2 normalization | Pending |  |  |  |  |
| 7 | Diagrams and evidence model | Pending |  |  |  |  |
| 8 | Final QA and polish | Pending |  |  |  |  |

## Phase 0 baseline checklist

| Check | Status | Notes |
|---|---:|---|
| Feature branch created | Pending | `feature/portfolio-premium-refresh` |
| Tracker created | In progress | This file |
| Working tree reviewed | Pending | Use `git status --short` |
| Push avoided from main | Required | Never push directly from `main` |
| Commit prepared | Pending | Stage only this tracker file |
| Push required | No | First push should happen after a meaningful milestone |

## Files to audit in Phase 1

| Area | Files or folders | Audit goal |
|---|---|---|
| Root entry point | `README.md` | Remove duplication, fix weak intro, improve evidence path |
| Portfolio backend | `PORTFOLIO.md` | Preserve strong case-study value, align with frontend |
| Skills | `SKILLS_MATRIX.md` | Expand and align with target roles |
| Architecture | `ARCHITECTURE.md` | Improve diagram-led explanation and remove weak metadata tone |
| Frontend home | Website homepage source | Explain project, intent, proof, audience, and evidence |
| Frontend navigation | MkDocs/navigation configuration | Add Portfolio > Role Guide submenu |
| Release 1 | Release 1 docs and evidence | Curate screenshot proof and normalize tone |
| Release 2 | Release 2 docs and evidence | Raise platform engineering narrative quality |
| Diagrams | `diagrams/` | Reuse available diagrams before creating new ones |
| Evidence | Evidence/proof folders | Map claims to proof and avoid overclaiming |

## Claim-to-evidence register

Use this table during audits and rewrites.

| Claim | Release | Status | Evidence path | Public wording | Technical reviewer wording | Action |
|---|---|---:|---|---|---|---|
|  |  | Pending |  |  |  |  |

## Diagram placement register

Use this table before adding or moving diagrams.

| Page | Diagram file | Purpose | What it proves | Related evidence | Action |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

## Quality gate

Before committing a rewritten page, score it from 1 to 10.

| Quality area | Score | Notes |
|---|---:|---|
| Human-written tone |  |  |
| Premium portfolio quality |  |  |
| Technical credibility |  |  |
| Recruiter readability |  |  |
| Architect-level clarity |  |  |
| Evidence alignment |  |  |
| Navigation usefulness |  |  |
| Release consistency |  |  |
| No defensive wording |  |  |
| No AI-sounding filler |  |  |

If any important page scores below 8, revise before commit.

## Encoding and mojibake gate

Before every commit that changes Markdown, YAML, or website content:

- Confirm files are UTF-8.
- Scan for replacement characters and mojibake.
- Pay special attention to emoji/status tables.
- Do not commit files showing corrupted characters.
- Do not repair encoding by guessing; compare against the intended content.

## Stop conditions

Stop and review before continuing if:

- A claim cannot be mapped to evidence.
- A file contains mojibake or encoding corruption.
- A rewrite changes technical meaning.
- Roadmap content appears as implemented content.
- Release 1 or Release 2 style becomes inconsistent.
- The page reads like internal notes instead of premium portfolio writing.
- The AI proposes broad rewrites without first auditing the file.
- The AI invents missing implementation details.
- A command tries to use `git add .`.
- A command tries to push directly from `main`.

## Phase completion log

### Phase 0 — Branch and baseline tracker

- Status: In progress
- Files changed:
  - `PORTFOLIO_REFRESH_TRACKER.md`
- Evidence checked:
  - Not started
- Encoding checked:
  - Pending
- Commit:
  - Pending
- Notes:
  - Tracker created to control the portfolio refresh and prevent scope drift.

### Phase 1 — Audit and source-of-truth map

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 2 — Content, navigation, and writing standard

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 3 — Homepage and frontend shell

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 4 — GitHub root documentation cleanup

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 5 — Release 1 normalization

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 6 — Release 2 normalization

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 7 — Diagrams and evidence model

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes:

### Phase 8 — Final QA and polish

- Status: Pending
- Files changed:
- Evidence checked:
- Encoding checked:
- Commit:
- Notes: