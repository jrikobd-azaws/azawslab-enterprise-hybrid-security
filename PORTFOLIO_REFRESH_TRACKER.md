# AzAWSLab Portfolio Refresh Tracker

This tracker controls the AzAWSLab portfolio refresh so the work remains scoped, evidence-led, and consistent across the frontend website, GitHub Markdown documentation, diagrams, and evidence files.

## Working branch

`feature/portfolio-premium-refresh`

Confirm locally before editing:

```powershell
git branch --show-current
git status --short
```

## Portfolio refresh objective

Upgrade AzAWSLab into a premium, evidence-backed Azure, hybrid, and multi-cloud platform engineering portfolio.

The refresh must improve:

- homepage clarity
- frontend navigation
- Portfolio submenu and Role Guide
- frontend content quality
- GitHub root documentation
- Release 1 and Release 2 consistency
- skills presentation
- architecture presentation
- evidence-to-capability mapping
- diagram placement
- roadmap separation
- encoding and mojibake safety

The project must support these target roles:

| Priority | Role |
|---|---|
| Primary | Azure Engineer |
| Primary | Cloud Engineer |
| Primary | Cloud Platform Engineer |
| Primary | Multi-Cloud Platform Engineer |
| Secondary | Infrastructure Engineer |
| Secondary | Infrastructure Architect |
| Advanced credibility | Cloud Architect |
| Advanced credibility | Security Architect |
| Advanced credibility | DevOps / SRE Engineer |

## Operating rules

- Work in one feature branch.
- Do not push directly from `main`.
- Use focused local commits.
- Keep push commands separate from commit commands.
- Do not use `git add .`.
- Do not rewrite unrelated files.
- Read and compare files before rewriting.
- Preserve emoji/status scanning tables in GitHub Markdown.
- Remove duplicate flat tables when they repeat the same information.
- Use visual chips/badges on frontend pages.
- Do not use weak public headers such as `Part of / Best for / Purpose`.
- Do not use the word `showroom` in public-facing portfolio content, except where listed as a banned term in the content standard.
- Check encoding and mojibake before commit.
- Do not invent claims or evidence.
- Keep implemented, evidenced, design-standard, and roadmap content clearly separated.
- Do not rename screenshots until an evidence index exists and links can be validated.
- Do not create Mermaid diagrams until site rendering support is confirmed.
- Do not push until a meaningful milestone is complete.

## Approved content decisions

| Decision | Status |
|---|---|
| Frontend is the public portfolio and case-study presentation | ✅ Approved |
| GitHub is the technical backend and evidence source of truth | ✅ Approved |
| Keep emoji/status scanning tables in GitHub Markdown | ✅ Approved |
| Remove duplicate flat tables | ✅ Approved |
| Use visual chips/badges on frontend pages | ✅ Approved |
| Add Portfolio > Role Guide submenu | ✅ Approved |
| Homepage must explain what the project is, what is inside, intent, proof, audience, and evidence location | ✅ Approved |
| Keep selected Release 1 screenshots visible on frontend | ✅ Approved |
| Move bulk screenshot evidence to deeper GitHub evidence paths | ✅ Approved |
| Use selected Release 2 CLI/workflow evidence only where it strengthens presentation | ✅ Approved |
| Prefer text diagrams for Release 2 technical flows | ✅ Approved |
| Convert Lessons Learned into Architectural Decisions and Operational Insights | ✅ Approved |
| Avoid defensive, scaffold-like, and internal metadata wording | ✅ Approved |
| Maintain human, experienced, organised, confident, evidence-led tone | ✅ Approved |

## Claim classification model

Every major claim must map to one of these statuses:

| Status | Meaning | Use when |
|---|---|---|
| ✅ Implemented and evidenced | Implementation and evidence are both present | Screenshots, CLI output, workflow logs, diagrams, or docs prove the claim |
| 🟡 Implemented; evidence linking needed | Implementation appears present, but evidence needs linking | File exists but evidence index is missing |
| 🔵 Design standard documented | Design exists but implementation evidence is not claimed | Architecture, roadmap, pattern, or intended model |
| ⚪ Roadmap | Future item | Release 3 or later enhancement |
| 🔴 Remove or reword | Unsupported or risky claim | No evidence, overclaiming, duplicate, or weak wording |

## Phase tracker

| Phase | Scope | Status | Files changed | Evidence checked | Encoding checked | Commit |
|---|---|---:|---|---|---:|---|
| 0 | Branch and baseline | Prepared | `PORTFOLIO_REFRESH_TRACKER.md` | N/A | Pending local check | Pending |
| 1 | Audit and source-of-truth map | Complete | None | Audit-level evidence inventory completed | Reviewed; local check still required before commit | N/A |
| 2 | Content, navigation, and writing standard | Complete | `CONTENT_STANDARD.md`, `PORTFOLIO_REFRESH_TRACKER.md` | N/A | Pending local check after file creation | Pending |
| 3 | Homepage and frontend shell | Complete | `site/index.md`, `site/role-guide.md`, `mkdocs.yml`, `site/portfolio-case-study.md`, `PORTFOLIO_REFRESH_TRACKER.md` | Frontend navigation, homepage evidence paths, role-guide links | Pending local check | Pending |
| 4 | GitHub root documentation cleanup | Pending |  |  |  |  |
| 5 | Release 1 normalization | Pending |  |  |  |  |
| 6 | Release 2 normalization | Pending |  |  |  |  |
| 7 | Diagrams and evidence model | Pending |  |  |  |  |
| 8 | Final QA and polish | Pending |  |  |  |  |

## Phase 1 - Audit and source-of-truth map

### Status

Complete as directional audit.

### Scope reviewed

- Live frontend website
- Homepage
- Architecture page
- Portfolio page
- Skills page
- Blog area
- GitHub root documents
- Release 1 documentation areas
- Release 2 documentation areas
- Foundation documentation areas
- Evidence folders
- Screenshots
- Diagram folder
- Tracker requirements

### Accepted Phase 1 findings

| Finding | Decision |
|---|---|
| Homepage needs stronger explanation of project, intent, proof, audience, and evidence location | Accepted |
| The word `showroom` must be removed from public-facing content | Accepted |
| Portfolio menu needs Role Guide submenu | Accepted |
| Emoji/status scanning tables should stay in GitHub Markdown | Accepted |
| Duplicate flat tables should be removed | Accepted |
| SKILLS_MATRIX.md needs major improvement | Accepted |
| ARCHITECTURE.md needs stronger diagram-led presentation | Accepted |
| Release 1 screenshots should remain visible where valuable | Accepted |
| Release 2 should use selected CLI/log evidence and stronger text diagrams | Accepted |
| Unsupported claims must be moved to roadmap or reworded | Accepted |
| Lessons Learned should become Architectural Decisions and Operational Insights | Accepted |
| Mermaid support must be confirmed before relying on Mermaid diagrams | Accepted |
| Screenshot renaming should be deferred until evidence indexing exists | Accepted |

### Phase 1 caution

The Phase 1 audit is accepted as a directional audit, not as an automatic edit list.

Before editing, Phase 3 and later must locally verify:

- exact MkDocs navigation file
- exact homepage source file
- current branch
- current working tree
- current file content
- diagram availability
- Mermaid rendering support
- evidence paths
- unsupported or overclaimed statements
- local encoding status

## Phase 2 - Content, navigation, and writing standard

### Status

Complete.

### Files created or updated

| File | Status |
|---|---|
| `CONTENT_STANDARD.md` | New standard document |
| `PORTFOLIO_REFRESH_TRACKER.md` | Updated with Phase 1 and Phase 2 control state |

### Phase 2 completion log

- Status: Complete
- Files changed:
  - `CONTENT_STANDARD.md`
  - `PORTFOLIO_REFRESH_TRACKER.md`
- Evidence checked: Not applicable; this was standard creation.
- Encoding checked: Must be confirmed locally after file creation.
- Commit: Pending.
- Notes:
  - Formalised content, navigation, evidence, diagram, roadmap, and writing standards.
  - Confirmed GitHub Markdown should preserve emoji/status scanning tables.
  - Confirmed duplicate flat tables should be removed.
  - Confirmed frontend pages should use visual chips/badges.
  - Confirmed `Evidence · Verified` must only be used when evidence directly supports the claim.
  - Confirmed Mermaid diagrams should not be required until MkDocs support is verified.
  - Confirmed Role Guide may start as a guided reviewer pathway and become interactive later.
  - No major pages rewritten in Phase 2.

### Quality score

Ready for controlled implementation.

## Phase 3 - Homepage and frontend shell

### Status

Pending.

### Goals

- Inspect local MkDocs/navigation configuration.
- Inspect homepage source file.
- Inspect current Portfolio pages.
- Confirm diagram support and available diagrams.
- Rewrite homepage to explain:
  - what AzAWSLab is
  - why it exists
  - what is inside
  - what it proves
  - who should review it
  - where evidence lives
  - what to inspect next
- Remove public-facing `showroom` wording.
- Add or prepare Portfolio > Role Guide navigation.
- Create Role Guide page or visible stub only if navigation points to it.
- Use visual chips/badges under major page titles.
- Use one existing architecture diagram where suitable.
- Do not create unverified Mermaid diagrams.
- Do not rename screenshots.
- Do not expand `SKILLS_MATRIX.md` yet.
- Do not rewrite Release 1 or Release 2 deeply yet.

### Expected files to inspect before editing

- `CONTENT_STANDARD.md`
- `PORTFOLIO_REFRESH_TRACKER.md`
- `mkdocs.yml` or equivalent navigation configuration
- homepage source file, likely `docs/index.md`
- portfolio page sources
- diagrams folder

### Stop conditions

Stop Phase 3 before editing if:

- the navigation file cannot be located
- homepage source file cannot be confirmed
- Mermaid support is unknown but a Mermaid dependency is being introduced
- Role Guide navigation points to a missing page
- a claim cannot be mapped to existing documentation or evidence
- encoding corruption appears in the target files

## Phase 4 - GitHub root documentation cleanup

### Status

Pending.

### Candidate files

- `README.md`
- `PORTFOLIO.md`
- `SKILLS_MATRIX.md`
- `ARCHITECTURE.md`
- `CONTENT_STANDARD.md`
- `PORTFOLIO_REFRESH_TRACKER.md`

### Goals

- Improve GitHub entry point clarity.
- Remove duplicate flat tables.
- Preserve emoji/status scanning tables.
- Remove weak public metadata-style headers.
- Improve root portfolio narrative.
- Expand skills matrix.
- Improve architecture overview.
- Reword unsupported claims.
- Convert Lessons Learned to Architectural Decisions and Operational Insights.
- Check mojibake and encoding before commit.

## Phase 5 - Release 1 normalization

### Status

Pending.

### Goals

- Keep important screenshot evidence visible.
- Convert screenshot-heavy sections into proof-card style.
- Link bulk screenshots through evidence index.
- Standardise tone with Release 2.
- Present Microsoft 365, identity, endpoint, security, compliance, and recovery work clearly.
- Reframe blocked or denied evidence as policy enforcement, guardrail validation, or control boundary where truthful.
- Avoid overclaiming production-scale maturity.

## Phase 6 - Release 2 normalization

### Status

Pending.

### Goals

- Improve Release 2 from implementation notes into premium platform engineering case-study quality.
- Explain Terraform root ownership and state boundaries.
- Explain GitHub Actions OIDC delivery model.
- Explain secure networking, AKS, AVD, AWX, backup, monitoring, and O6 patterns.
- Use text diagrams where they improve clarity.
- Summarise CLI/log evidence instead of dumping raw output.
- Add evidence-to-capability mapping.
- Separate implemented work from roadmap.
- Reframe blocked/failed evidence as guardrail or control validation where truthful.

## Phase 7 - Diagrams and evidence model

### Status

Pending.

### Goals

- Audit existing diagrams before creating new ones.
- Place one strong architecture diagram on the homepage.
- Improve architecture page diagram flow.
- Create or update evidence index.
- Add diagram placement mapping.
- Add evidence-to-capability mapping.
- Confirm Mermaid support before adding Mermaid dependency.
- Avoid diagrams that mention unconfirmed technologies.

## Phase 8 - Final QA and polish

### Status

Pending.

### Checks

- No mojibake.
- No broken Markdown tables.
- No duplicate flat status tables.
- Emoji/status scanning tables preserved in GitHub Markdown.
- Visual chips/badges used on frontend pages where appropriate.
- No public-facing `showroom` wording.
- No weak public metadata headers.
- No unsupported claims.
- No roadmap content written as implemented.
- No AI-sounding filler.
- No defensive wording.
- Release 1 and Release 2 tone is consistent.
- Important pages contain reviewer takeaways.
- No placeholder links.
- Homepage answers the required portfolio questions.
- Skills story is complete.
- Architecture page is stronger and diagram-led.
- Role Guide submenu exists or unsupported Role Guide claims are removed.

## Current stop conditions

Stop and review before continuing if:

- a claim cannot be mapped to evidence
- a file contains encoding corruption
- a rewrite changes technical meaning
- roadmap content appears as implemented content
- Release 1 or Release 2 style becomes inconsistent
- a page reads like internal notes instead of premium portfolio writing
- the AI proposes editing files outside the current phase
- the AI proposes pushing from `main`
- the AI proposes `git add .`
- the AI proposes renaming screenshots before evidence indexing exists
- the AI proposes Mermaid diagrams before support is confirmed

## Commit policy

Use focused commits.

Do not commit until:

- target files have been reviewed
- diff has been inspected
- `git diff --check` is clean
- mojibake scan is clean
- changed files match the phase scope
- tracker has been updated

Do not push after every small change. Push only after a meaningful milestone, such as after Phase 3 or Phase 4.

## Required phase closeout format

Every phase must end with:

```text
Phase status:
- Completed:
- Files audited:
- Files changed:
- Evidence linked:
- Encoding check:
- Quality score:
- Commit prepared:
- Push required:
- Next phase:
```
## Phase 3A - Homepage and frontend shell local inspection

### Status

Complete.

### Inspection summary

- Files inspected: `mkdocs.yml`, `site/index.md`, `site/portfolio-case-study.md`, `site/architecture.md`, `site/skills-matrix.md`, `site/proof-gallery.md`, `site/evidence-guide.md`, `CONTENT_STANDARD.md`, `PORTFOLIO_REFRESH_TRACKER.md`, diagrams folder inventory.
- Homepage source: `site/index.md`.
- Navigation: Portfolio menu had three items before Phase 3B; Role Guide was missing.
- Mermaid: Supported through `pymdownx.superfences` with a Mermaid fence.
- Diagram recommendation: `diagrams/platform/hero-diagram.png` for the homepage.
- `showroom`: two occurrences found in `site/index.md`.
- No weak scaffold headers found.
- Files changed: None during inspection.

## Phase 3B - Homepage and frontend shell implementation

### Status

Complete.

### Files changed

- `site/index.md` - homepage hero rewrite, public-facing `showroom` wording removed, architecture diagram reference added, evidence path strengthened.
- `site/role-guide.md` - new guided reviewer routing page.
- `mkdocs.yml` - Role Guide added to Portfolio submenu.
- `site/portfolio-case-study.md` - Role Guide added to reviewer entry points.
- `PORTFOLIO_REFRESH_TRACKER.md` - Phase 3A and Phase 3B status recorded.

### Evidence checked

- Homepage evidence paths point to the Proof Gallery and public GitHub repository.
- Featured proof links remain mapped to existing evidence folders.
- Role Guide links point to existing reviewer pathway pages.
- No release implementation claims were added.

### Encoding checked

Pending local verification before commit.

### Commit

Pending.

### Notes

Phase 3B was implemented within the approved frontend shell scope. No release documentation, backend root documentation, screenshots, diagrams, or evidence folders were modified.
