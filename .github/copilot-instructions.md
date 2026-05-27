# Copilot Instructions — Azawslab Enterprise Hybrid Security Platform

## 1. Start here every session

Read **STATUS.md** first. That file is the source-truth lock for the entire portfolio. If any other document appears to conflict with STATUS.md, treat STATUS.md as authoritative.

## 2. Canonical project truths

- This is **one flagship enterprise platform portfolio**, not multiple disconnected projects.
- Release naming: `release1`, `release2`, `release3`.
- **Release 1** = Hybrid Modern Workplace, Identity & Endpoint Security. **Status:** Complete and evidenced.
- **Release 2** = Azure Platform Engineering, Security, Automation, Private Platform & AI Operations. **Status:** Implemented and evidenced.
  - A2 AWX automation control plane is complete and evidenced.
  - O4 Private AKS is complete and evidenced.
  - O5 AVD + FSLogix is complete and evidenced.
  - O6 AI Operations Enclave is complete and evidenced.
- **Release 3** = Multi-Cloud Kubernetes, GitOps & DevSecOps. **Status:** Roadmap / platform evolution.
- **Branch namespace** `br1.azawslab.co.uk` is a network identity boundary, not a Git branch.
- **Terraform apply model:** GitHub Actions controlled apply is the default. Local Terraform apply is exceptional.

## 3. Six capability tracks

1. Hybrid Modern Workplace, Identity & Endpoint Security (Release 1)
2. Azure Landing Zone, IaC & Governance (Release 2)
3. Secure Hybrid & Multi-Cloud Networking (Release 2)
4. Automation, SecOps & Resilience (Release 2)
5. Private Platform, Secure Workspace & AI Operations (Release 2)
6. Multi-Cloud Kubernetes, GitOps & DevSecOps (Release 3, roadmap)

## 4. Evidence locations

- **Release 1 evidence:** `screenshots/release1/`
- **Release 2 evidence:** `docs/release2/evidence/`
- **Release 3:** roadmap only — no implementation evidence yet.
- **O6 Kubernetes support manifests:** `kubernetes/`
  - These are supporting manifests and live-validation scaffolding.
  - Formal O6 evidence remains under `docs/release2/evidence/O6/`.
- If a proof path is unconfirmed, use `proof link to be inserted`. Never invent file names or evidence folders.

## 5. Forbidden language

Do not use:

- "Hybrid Microsoft Foundation"
- "Modern Workplace and Hybrid Identity"
- "only a lab", "not production", "limitations", "weakness", "this project does not claim"
- "Release 2 roadmap"
- "A2 incomplete", "O4 incomplete", "O5 incomplete", "O6 incomplete"
- `br1.azawslab.co.uk` described as a Git branch
- Customer, partner, or product-user sales language
- Defensive or self-deprecating public-facing wording

## 6. Preferred portfolio language

Use confident, evidence-led phrasing:

- flagship enterprise platform portfolio
- staged enterprise platform journey
- production-style portfolio lab
- operationally validated
- evidence-backed implementation
- human-approved AI operations model
- Release 3 platform evolution
- implementation positioning

## 7. What to suggest and what not to suggest

Do:

- Draft reader-facing documentation.
- Draft capability stories.
- Draft evidence indexes.
- Draft roadmap descriptions.
- Preserve the canonical release structure.
- Use existing evidence paths only.

Do not:

- Recommend Terraform apply during documentation work.
- Invent evidence.
- Invent file names.
- Edit multiple files without explicit approval.
- Weaken Release 1 or Release 2 status.
- Treat Release 3 as implemented.

## 8. Key repository files to reference

- `README.md` — portfolio storefront
- `PORTFOLIO.md` — full narrative case study
- `ARCHITECTURE.md` — platform evolution and technical architecture overview
- `SKILLS_MATRIX.md` — role-to-evidence mapping
- `EVIDENCE_GUIDE.md` — evidence organisation and redaction rules
- `STATUS.md` — canonical source-truth lock
- `PROOF_GALLERY.md` — curated flagship evidence highlights
- `ROLE_GUIDE.md` — role-based reading paths
- `DESIGN_DECISIONS.md` — senior engineering decision record
- `docs/release2/README.md` — Release 2 capability-led entry point
- `docs/release2/01-05` — Release 2 capability stories
- `docs/release2/06-skills-and-evidence-index.md`
- `docs/release2/11-terraform-state-and-pipeline-map.md`
- `docs/release3/` — Release 3 roadmap direction documents
- `terraform/README.md` — Terraform root map and safety notes
- `scripts/README.md` — script usage and safety notes
- `kubernetes/README.md` — O6 Kubernetes manifest support
- `collections/README.md` — Ansible collection dependency context

## 9. Repository structure notes

- `ansible.cfg` at the repository root is intentional. It supports Ansible/AWX execution behaviour and should not be treated as loose clutter.
- `collections/` contains Ansible collection dependency declarations.
- `kubernetes/` supports O6 AI Operations Enclave manifests and live validation.
- `docs/release2/10-phase-reference/` contains implementation-era Release 2 reference material, not the primary reader path.
- `docs/release3/10-roadmap-reference/` contains earlier Release 3 planning reference material, not implemented evidence.
