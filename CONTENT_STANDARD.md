# AzAWSLab Portfolio Content, Navigation & Writing Standard

_For the AzAWSLab frontend portfolio, GitHub technical backend, and evidence documentation._

This standard controls all future portfolio refresh work. It exists to keep the frontend website, GitHub Markdown files, diagrams, screenshots, CLI evidence, and roadmap content consistent, evidence-led, and suitable for a premium cloud engineering / architecture portfolio.

## 1. Purpose of this standard

AzAWSLab has two connected presentation layers:

| Layer | Purpose | Audience |
|---|---|---|
| Frontend website | Public portfolio and case-study presentation | Recruiters, hiring managers, architects, technical reviewers |
| GitHub repository | Technical backend, implementation source of truth, and evidence record | Engineers, cloud reviewers, security reviewers, interviewers |

Both layers must tell the same story, but they must not duplicate the same content.

The frontend should be concise, guided, visual, and readable.  
The GitHub backend should be deeper, more technical, evidence-linked, and implementation-oriented.

## 2. Core operating principles

All future edits must follow these rules:

- No writing before audit.
- No editing before comparing the current file with the proposed replacement.
- No claim without evidence or a clear classification.
- No phase without tracker update.
- No commit before encoding and mojibake checks.
- No push from `main`.
- No broad rewrite without scoped phase approval.
- No implementation claim for roadmap-only work.
- No defensive wording that weakens the portfolio.
- No artificial, scaffold-like, or AI-generated tone.

Every major claim must map to one of the following:

| Status | Meaning |
|---|---|
| ✅ Implemented and evidenced | Implementation and evidence are both present |
| 🟡 Implemented; evidence linking needed | Implementation appears present, but evidence needs linking or indexing |
| 🔵 Design standard documented | Design or architecture is documented, but implementation evidence is not claimed |
| ⚪ Roadmap | Future direction only |
| 🔴 Remove or reword | Claim is unsupported, duplicated, weak, or misleading |

## 3. Frontend page structure

Every major frontend page should follow this structure:

1. **Title**  
   Clear, human, and portfolio-ready. Avoid internal metadata phrasing.

2. **Visual status chips/badges**  
   Use short visual labels for release coverage, evidence status, and platform area.

3. **Strong opening explanation**  
   Explain what the page is, why it exists, and why it matters.

4. **What this page proves**  
   A short evidence-backed statement.

5. **Architecture snapshot**  
   Use an annotated PNG, Mermaid diagram, or plain text diagram where it improves understanding. Diagrams must explain architecture, not decorate the page.

6. **Key capabilities**  
   Concrete, verifiable items. Avoid vague skill lists.

7. **Selected proof**  
   Use only the strongest screenshots, CLI excerpts, workflow outputs, or evidence cards. Do not overload frontend pages with raw evidence.

8. **Reviewer takeaway**  
   A calm, experienced observation that helps the reader understand the value of the work.

9. **Deeper GitHub evidence**  
   Link to the relevant GitHub page, evidence folder, README, workflow, Terraform root, Ansible playbook, or architecture document.

10. **Next recommended page**  
   Guide the reader to the next relevant portfolio path.

### Homepage exception

The homepage must also answer these questions naturally:

- What is AzAWSLab?
- Why was it built?
- What is inside it?
- What does it prove?
- Who should review it?
- Where does the evidence live?
- What should the reader inspect next?

Do not write those questions as headings unless it improves the page. The answers should be clear from the hero, architecture snapshot, release journey, proof highlights, and reviewer paths.

## 4. GitHub backend Markdown structure

Every major GitHub Markdown document should follow this structure:

1. **Title**
2. **Emoji/status scanning table**
3. **Purpose**
4. **Scope**
5. **Architecture model**
6. **Implementation summary**
7. **Terraform, Ansible, AWX, workflow, or evidence wiring** where relevant
8. **Evidence map**
9. **Validation notes**
10. **Reviewer takeaway**
11. **Related files**

GitHub Markdown is allowed to use structured headings such as `Purpose`, `Scope`, and `Validation notes` because the repository acts as the technical backend. Frontend pages should avoid sounding like internal documentation metadata.

## 5. Evidence page structure

Every evidence page or evidence section must explain:

1. **Evidence item**  
   What the reviewer is looking at.

2. **Capability proven**  
   Which architectural, operational, security, automation, or platform claim the evidence supports.

3. **Evidence type**  
   Use one of: `screenshot`, `CLI`, `workflow`, `diagram`, `config`, `validation note`.

4. **What the reviewer should verify**  
   Short guidance that explains how to interpret the evidence.

5. **Related implementation file**  
   Link to Terraform, Ansible, workflow, Markdown documentation, config, or architecture file where available.

6. **Redaction note**  
   Explain if values are masked, renamed, or intentionally hidden.

## 6. Emoji/status scanning table standard for GitHub Markdown

Use emoji/status scanning tables in GitHub Markdown because they improve fast reader comprehension.

Use this format:

| Capability | Status | Evidence |
|---|---|---|
| 🔵 Capability name | ✅ Implemented / 🟡 Evidence linking needed / 🔵 Design standard / ⚪ Roadmap / 🔴 Remove | Link or path |

Rules:

- Keep the scanning table near the top of the document, directly after the title or short opening.
- Preserve emoji/status-style tables in GitHub Markdown.
- Remove duplicate flat tables when they repeat the same content.
- Do not use both a flat table and an emoji/status scanning table for the same purpose.
- Keep status labels consistent across files.
- Do not mark something as ✅ Implemented unless evidence or implementation can be traced.

## 7. Visual chip/badge standard for frontend pages

Frontend pages should use small visual chips or badges at the top of major pages.

Examples:

- `Platform · Public Ready`
- `Release 1 · Workplace & Identity`
- `Release 2 · Platform Engineering`
- `Release 3 · Roadmap`
- `Evidence · Linked`
- `Evidence · Verified`
- `Terraform · Delivery Model`
- `Policy · Enforced`
- `Security · Guardrails`
- `AI Operations · Governed`

Rules:

- Place chips as a row directly under the page title.
- Use `Evidence · Verified` only where the evidence path exists and directly supports the claim.
- Use `Evidence · Linked`, `Evidence · Mapping Needed`, or omit the evidence chip when proof has not yet been fully mapped.
- Never use long sentences inside chips.
- Do not use chips to overclaim implementation status.
- Keep frontend chips visually scannable and consistent.

## 8. Navigation model

The frontend navigation should support different audience journeys.

Recommended structure:

- **Home**
- **Architecture**
- **Portfolio**
  - Overview
  - Role Guide
  - Release 1 · Workplace & Identity
  - Release 2 · Platform Engineering
  - Release 3 · Multi-Cloud Roadmap
- **Skills**
- **Evidence & Decisions** or **Architectural Decisions & Insights**
- **Blog** only if maintained and useful

Rules:

- The Portfolio menu must include a Role Guide.
- No claim about Role Guide availability is allowed unless the page exists or a visible stub exists.
- The frontend should guide readers.
- GitHub does not need a frontend-style menu; it should be navigated through README links, status tables, and related-file sections.

## 9. Portfolio submenu model

The Portfolio menu should support reviewer intent.

Recommended submenu:

| Page | Purpose |
|---|---|
| Overview | High-level portfolio case study and release story |
| Role Guide | Guided reviewer pathway; may become interactive later |
| Release 1 · Workplace & Identity | Hybrid identity, endpoint, compliance, Microsoft 365, recovery |
| Release 2 · Platform Engineering | Terraform, Azure platform, AKS, AVD, AWX, multi-cloud, security, AI operations |
| Release 3 · Multi-Cloud Roadmap | DevSecOps, Argo CD, multi-cloud Kubernetes roadmap |

The frontend Role Guide should be human-friendly.  
A short GitHub reviewer path may also exist for technical readers browsing the repository directly.

## 10. Screenshot evidence wording standard

Release 1 uses important screenshot-based evidence. These screenshots should remain part of the portfolio, but they must be curated.

Rules:

- Keep important screenshots visible on frontend pages where they strengthen the story.
- Move bulk screenshots to GitHub evidence folders or evidence index pages.
- Describe the context before showing the screenshot.
- Explain what the screenshot proves.
- Do not claim success if the screenshot proves a blocked request, denied action, or policy restriction.
- Use control-oriented wording where appropriate.

Preferred wording:

| Evidence pattern | Strong wording |
|---|---|
| Policy denied a deployment | Governance enforcement validated |
| Access denied | Least-privilege boundary confirmed |
| Device blocked | Compliance guardrail enforced |
| Region denied | Location policy boundary validated |
| Single-region recovery blocked | Recovery design boundary confirmed |

Suggested caption format:

```text
Evidence: [capability] — [source file or evidence path]
```

## 11. CLI and log evidence wording standard

Release 2 uses CLI, workflow, Terraform, and log-based evidence. This should be presented selectively.

Rules:

- Show only relevant output lines.
- Do not paste full logs into frontend pages.
- Link to raw evidence files for full detail.
- Explain the meaning outside the code block.
- Do not place interpretation inside the code block.
- Use CLI evidence to prove capability, not to overwhelm the reader.

Preferred framing:

```text
The following output confirms [capability]. The full evidence file is linked for reviewer inspection.
```

## 12. Terraform text diagram standard

Terraform workflows should be represented with Mermaid or plain text diagrams where they improve reviewer understanding. Mermaid source files may be added after MkDocs support is confirmed.

Example flow:

```text
plan → validate → apply → state check → drift detection
```

The diagram may be embedded in `ARCHITECTURE.md` and the frontend Architecture page when MkDocs rendering is verified.

Suggested caption:

```text
Terraform execution workflow — root ownership, validation, state handling, and drift-control model.
```

Terraform diagrams should show only decision-critical information:

- root ownership
- module relationship
- remote state dependency
- workflow trigger
- state boundary
- validation point
- drift-control model

Do not show every resource unless the page is specifically a deep technical implementation page.

## 13. Roadmap wording standard

Any feature not yet implemented must be described only in roadmap sections and clearly marked as ⚪ Roadmap.

Allowed phrasing:

- Planned for Release 3
- Roadmap extension
- Future extension; not yet evidenced
- Design direction documented; implementation pending
- Candidate enhancement for later release

Avoid:

- coming soon
- fully planned
- should work
- nearly complete
- not completed
- unfinished

Roadmap content must not appear as implemented capability.

## 14. Failure, guardrail, and policy enforcement wording standard

When evidence shows a blocked action or failed validation, reframe it as a validated control boundary where truthful.

| Evidence pattern | Stronger interpretation |
|---|---|
| Policy blocked deployment | Governance enforcement validated |
| Single-region DR blocked | Recovery design boundary confirmed |
| Route did not follow expected path | Routing or inspection boundary identified |
| Permission denied | RBAC or least-privilege control validated |
| Workflow failed safely | Delivery guardrail validated |
| Missing final screenshot | Describe the boundary proven; do not claim final success |
| Alert not evidenced | Mark as design standard or evidence mapping needed |

Rules:

- Do not fabricate success evidence.
- Do not hide material facts.
- Do not use weak self-critical wording.
- Explain the architectural control proven by the evidence.
- If the final success evidence is missing, do not say the final success was evidenced.

## 15. Banned phrases and patterns

Avoid these phrases in public-facing content:

| Banned phrase | Reason |
|---|---|
| showroom | Scaffold-like wording |
| I tried | Intern tone |
| failed because | Weak interpretation; reframe as guardrail or control boundary |
| not completed | Use roadmap, scoped, or design-standard language where accurate |
| basic lab | Diminishes the architecture |
| simple setup | Diminishes the work |
| just a demo | Weakens credibility |
| Part of / Best for / Purpose as frontend headers | Internal metadata tone |
| maybe / probably | Vague; state fact or mark as not confirmed |
| full enterprise production | Overclaiming unless explicitly true and evidenced |
| end-to-end production | Overclaiming unless explicitly true and evidenced |

## 16. Preferred phrases

Use these where accurate:

| Preferred phrase | Context |
|---|---|
| portfolio | General public wording |
| case study | Architecture or release narrative |
| evidence-backed platform record | Homepage or portfolio overview |
| implemented and evidenced | Confirmed capability |
| evidence-linked | Evidence path exists |
| evidence mapping needed | Implementation exists but proof needs indexing |
| design standard documented | Design exists but implementation evidence is not claimed |
| roadmap extension | Future work |
| controlled implementation | Scoped lab or pilot-style implementation |
| lab-validated platform pattern | Neutral and credible lab wording |
| production-style | Enterprise-pattern implementation without claiming production operation |
| enterprise-pattern | Architecture style |
| governed AI-assisted operations | O6 / AI operations wording |
| policy enforcement validated | Deny or policy evidence |
| guardrail confirmed | Blocked action or safe failure |
| recovery design boundary confirmed | DR or region-control evidence |

## 17. Human premium portfolio writing rules

All public content must feel:

- **Human** — written like an experienced engineer or architect, not a template.
- **Experienced** — calm, practical, and precise.
- **Organised** — clear hierarchy, no duplication, no clutter.
- **Confident** — no unnecessary hedging.
- **Evidence-led** — claims trace to files, screenshots, logs, diagrams, workflows, or design notes.
- **Architect-level** — explains why decisions matter, not only what was configured.
- **Readable** — accessible for recruiters and hiring managers.
- **Credible** — precise enough for engineers and reviewers.
- **Not salesy** — the evidence should carry the strength.
- **Not scaffold-like** — no placeholder tone, no generic filler.
- **Not internal metadata style** — frontend pages should feel like a polished portfolio, not a planning file.

## 18. Diagram usage standard

Before adding new diagrams:

1. Inspect the existing `diagrams/` folder.
2. Reuse strong diagrams where possible.
3. Confirm whether Mermaid rendering is supported.
4. Prefer simple diagrams that reduce cognitive load.
5. Do not create diagrams that mention unconfirmed technology.

Diagram types:

| Diagram type | Best used for |
|---|---|
| Annotated PNG | Frontend overview, high-level architecture |
| Mermaid flowchart | Workflows, traffic paths, reviewer journeys |
| Mermaid sequence diagram | Terraform, automation, approval flows |
| Plain text diagram | GitHub Markdown, Terraform roots, state dependencies |
| Evidence flow diagram | Proof mapping and reviewer inspection |

Diagram captions must explain what the diagram proves.

## 19. Frontend versus GitHub content split

| Content type | Frontend | GitHub |
|---|---|---|
| Executive explanation | Yes | Short version only |
| Deep implementation details | Summary only | Yes |
| Raw CLI logs | Selected excerpts only | Full evidence files |
| Screenshots | Curated examples | Full evidence record |
| Terraform root details | Diagram and explanation | Full documentation |
| Skills matrix | Curated role-based summary | Full source of truth |
| Role Guide | Guided public path | Optional technical reviewer path |
| Roadmap | Clear high-level roadmap | Detailed roadmap and design notes |
| Evidence index | Summary cards | Full evidence map |

## 20. Quality gate before commit

Before committing any rewritten page, score it against these criteria:

| Criterion | Target |
|---|---|
| Human-written tone | 8/10 or higher |
| Premium portfolio quality | 8/10 or higher |
| Technical credibility | 8/10 or higher |
| Recruiter readability | 8/10 or higher |
| Architect-level clarity | 8/10 or higher |
| Evidence alignment | 8/10 or higher |
| Navigation usefulness | 8/10 or higher |
| Release consistency | 8/10 or higher |
| No defensive wording | Required |
| No AI-sounding filler | Required |

If any important page scores below 8, revise before commit.

## 21. Encoding and mojibake rule

All Markdown, YAML, and site source files must remain UTF-8.

Before every commit:

- Check for mojibake.
- Check for replacement characters.
- Check that emoji tables render correctly.
- Check Markdown tables.
- Check `git diff --check`.
- Avoid default Windows PowerShell encoding when writing files.
- Use explicit UTF-8 when scripting file edits.

## 22. Implementation control

All future implementation phases must end with:

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

This standard is the control document for Phase 3 through Phase 8.