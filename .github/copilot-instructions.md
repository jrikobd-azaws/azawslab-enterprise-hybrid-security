# Copilot Instructions - Azawslab Enterprise Hybrid Security Platform

## Project Identity

This repository is one flagship enterprise platform portfolio, structured as three staged releases.

It presents a staged enterprise platform journey from hybrid Microsoft operations into Azure platform engineering, multi-cloud security, automation, private platform operations, AI-assisted CloudOps, and future multi-cloud Kubernetes delivery.

Always read `STATUS.md` first before rewriting or reorganizing documentation.

## Canonical Project Truth

These facts are fixed unless the human owner explicitly changes them:

- This is one flagship platform repository, not multiple disconnected projects.
- Keep `release1`, `release2`, and `release3` naming.
- Release 1 = Hybrid Modern Workplace, Identity & Endpoint Security.
- Release 2 = Azure Platform Engineering, Security, Automation, Private Platform, and AI Operations.
- Release 3 = Multi-Cloud Kubernetes, GitOps, and DevSecOps with AKS, EKS, and Argo CD.
- Final branch namespace is `br1.azawslab.co.uk`.
- A2 AWX automation control plane is complete and evidenced.
- O4 Private AKS is complete and evidenced.
- O5 AVD + FSLogix is complete and evidenced.
- O6 AI Operations Enclave work is complete and evidenced.
- GitHub Actions controlled apply is the default path.
- Local Terraform apply is exceptional and should be documented when used.

## Six Portfolio Capability Tracks

Use these tracks as the public mental model of the portfolio:

1. Hybrid Modern Workplace, Identity & Endpoint Security
2. Azure Landing Zone, IaC and Governance
3. Secure Hybrid and Multi-Cloud Networking
4. Automation, SecOps and Resilience
5. Private Platform, Secure Workspace and AI Operations
6. Multi-Cloud Kubernetes, GitOps and DevSecOps

Do not lead public documentation with internal phase codes such as P0, P1, A2, O4, O5, or O6. Use phase codes only as supporting references inside technical sections.

## Portfolio Writing Tone

Write like a senior platform engineer presenting a world-class flagship portfolio to recruiters, hiring managers, and technical reviewers.

The tone must be:

- confident
- human
- evidence-led
- recruiter-friendly
- technically credible
- clear without sounding basic
- strong without sounding inflated

Avoid generic AI phrases such as:

- dive into
- unleash
- embark on a journey
- game changer
- cutting-edge solution
- robust and scalable solution
- seamless integration
- comprehensive suite

Use direct, professional engineering language.

## Implementation Positioning

Do not use defensive front-page language.

Avoid:

- this project does not claim
- only a lab
- not production
- limitations include
- weakness
- partial implementation
- out of scope

Use stronger positioning:

- production-style portfolio lab
- portfolio-scale validation
- evidence-backed implementation
- staged enterprise platform journey
- operationally validated pattern
- implementation positioning
- platform evolution path
- human-approved AI operations model
- Release 3 direction

When future work is mentioned, frame it positively as platform evolution or Release 3 direction.

## Evidence and Truth Rules

Never invent completed work.

Every substantial claim should be one of:

- implemented and evidenced
- implemented with evidence link pending
- companion implementation evidence
- roadmap direction
- platform evolution
- design decision
- implementation positioning

When evidence is missing, write:

- evidence link needed
- diagram placeholder
- proof path pending
- Release 3 direction
- companion evidence reference

Do not create fake links, fake screenshots, fake logs, or fake command outputs.

## Release 1 Writing Rules

Release 1 is complete and evidenced.

Present Release 1 as the Hybrid Modern Workplace, Identity & Endpoint Security:

- Active Directory
- Microsoft Entra ID
- Entra Connect Sync
- Microsoft 365
- Exchange hybrid
- Intune
- Autopilot
- endpoint compliance and security
- Purview
- monitoring
- recovery scenarios
- Microsoft Graph and PowerShell operational tooling

Release 1 writing should preserve the existing storytelling tone: validated, supportable, operationally credible, and evidence-led.

## Release 2 Writing Rules

Release 2 is implemented and evidenced, with portfolio documentation reorganization in progress.

Present Release 2 through capability stories, not as a long phase list:

1. Azure Landing Zone, IaC and Governance
2. Hybrid and Multi-Cloud Network Security
3. Automation, SecOps and Resilience
4. Private Platform and Secure Workspace
5. AI Operations Enclave

Internal phase documents remain useful as technical references, but public-facing Release 2 documents should be reader-friendly capability narratives.

## Release 3 Writing Rules

Release 3 is roadmap.

Present Release 3 as:

Multi-Cloud Kubernetes, GitOps and DevSecOps Workload Platform

It includes:

- AKS
- EKS
- Argo CD
- DevSecOps controls
- image scanning
- policy gates
- protected ingress
- TLS
- observability
- resilience

Do not imply Release 3 is implemented unless future evidence is added.

## O6 AI Operations Enclave Rules

O6 is complete and evidenced.

Present O6 as a human-approved AI Operations Enclave model where AI assists with analysis, drafting, validation, and recommendation while operators retain change authority.

Use positive language:

- human-approved AI operations model
- AI-assisted CloudOps pattern
- RAG-informed operations support
- MCP/tool boundary
- deterministic validation
- companion implementation evidence
- local-ai-lab-infra companion project

Do not describe O6 as uncontrolled autonomous remediation.

## Terraform and GitHub Actions Safety Rules

Terraform owns infrastructure.

GitHub Actions controlled apply is the default path.

Local Terraform is normally limited to:

- fmt
- init
- validate
- plan
- preflight

Local apply is exceptional and should be documented when used.

Do not suggest:

- terraform apply -auto-approve
- terraform destroy -auto-approve
- committing tfstate
- committing tfplan
- committing secrets
- committing kubeconfigs
- committing private keys
- committing raw credentials

Respect Release 2 active profile guardrails and do not propose raw local plans for optional active roots unless the profile-aware wrapper or approved flag set is used.

## Documentation Migration Rules

Use `STATUS.md` as the source-truth lock during migration.

Do not let stale Release 2 text override `STATUS.md`.

Do not use mojibake or corrupted Markdown as final prose. Use corrupted files only for facts until encoding cleanup is complete.

Do not rewrite the whole repository in one step.

Work one document at a time:

1. source pack
2. draft
3. challenger review
4. synthesis
5. human-tone polish
6. evidence confidence review
7. human approval
8. approved edit
9. commit

## File Editing Rules

Before editing, state:

- target file
- reason for change
- source files used
- evidence links needed
- expected output

Only edit approved files.

Do not move files unless the user explicitly approves the migration step.

Do not modify Terraform, Ansible, AWX, GitHub Actions, or scripts while doing documentation rewriting unless the task is specifically about those files.

## Preferred Public Writing Pattern

Use this order for public-facing pages:

1. what this is
2. why it matters
3. what was built
4. diagram
5. evidence
6. skills demonstrated
7. implementation positioning

## Release 2 Capability Document Pattern

Use this structure for Release 2 capability documents:

1. What This Solves
2. What Was Built
3. Architecture
4. How It Works
5. Evidence
6. Operational Notes
7. What I Learned
8. Implementation Positioning

Each Release 2 capability document should include:

- one text-based diagram
- one image diagram placeholder
- an evidence table
- reader-friendly narrative
- technical reviewer depth
- positive implementation positioning

## Human Tone Requirements

The final output should sound like a skilled engineer wrote it after building the platform.

Prefer:

- short strong paragraphs
- precise engineering terms
- clear reader guidance
- evidence-led claims
- practical design reasoning

Avoid:

- over-polished marketing
- excessive adjectives
- vague transformation language
- repetitive claims
- defensive disclaimers