# Code Traceability

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-identity/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value">Workplace</span>
  </a>
  <a class="portfolio-chip" href="/engineering/terraform-state-boundaries/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Delivery</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-multicloud-networking/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Network</span>
  </a>
  <a class="portfolio-chip" href="/engineering/private-aks-platform/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform</span>
  </a>
  <a class="portfolio-chip" href="/engineering/automation-control-plane/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Operations</span>
  </a>
</div>

!!! summary "Scope"
    Engineering rationale and evidence paths for tracing AzAWSLab claims from portfolio narrative to implementation source, workflow execution, Terraform roots, and public-safe evidence. This page focuses on verified repository traceability rather than undocumented tagging assumptions.

## Traceability model

AzAWSLab uses two complementary traceability models.

The first model maps a portfolio claim to implementation source and evidence. This is the reviewer-facing model: a claim should lead to a repository path, and that path should lead to public-safe evidence.

The second model maps an infrastructure change through the delivery pipeline. This is the delivery-engineering model: a Git change flows through GitHub Actions, Terraform plan, review, controlled apply, and validation evidence.

```text
Portfolio claim
    |
    v
Documentation or engineering note
    |
    v
Implementation source
    |
    v
Evidence folder
    |
    v
Reviewer verification
```

```text
Git commit
    |
    v
GitHub Actions workflow run
    |
    v
OIDC-authenticated Terraform plan
    |
    v
Review or approval gate
    |
    v
Controlled Terraform apply
    |
    v
Validation output and evidence folder
```

This gives reviewers two routes through the same platform: they can start from a business capability or from the delivery pipeline.

## Capability-to-source map

| Capability | Documentation or source | Evidence path |
|---|---|---|
| Hybrid workplace, identity, endpoint security, and Microsoft 365 operations | [`docs/release1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release1), [`scripts/release1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/scripts/release1) | [`screenshots/release1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1) |
| Graph and PowerShell operations | [`scripts/release1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/scripts/release1), Release 1 engineering notes | [`screenshots/release1/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1) |
| Terraform state boundaries | [`terraform/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform), [Terraform state map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | [`docs/release2/evidence/P2a/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P2a) |
| Secretless GitHub Actions OIDC | [`.github/workflows/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows) | [`docs/release2/evidence/P0/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P0) |
| Ansible and AWX automation | [`ansible/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible), [`terraform/platform-management/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-management/dev) | [`docs/release2/evidence/A2-awx-control-plane/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) |
| Hybrid BGP and multi-cloud transit | [`terraform/platform-networking/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev), [`terraform/aws-branch/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/aws-branch/dev) | [`O3b`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b), [`O3c`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) |
| Secure transmission, inspection, and private routing | [`terraform/platform-networking/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev), [`terraform/platform-aks/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev), [`terraform/platform-avd/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) | [`docs/release2/evidence/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) |
| Private AKS platform | [`terraform/platform-aks/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev), [`terraform/modules/private-aks-platform/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/modules/private-aks-platform) | [`docs/release2/evidence/O4/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) |
| AVD secure workspace and FSLogix | [`terraform/platform-avd/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev), [`terraform/modules/avd-secure-workspace/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/modules/avd-secure-workspace) | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) |
| Governed AI operations enclave | [`kubernetes/o6-ai-enclave/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/kubernetes/o6-ai-enclave), [`kubernetes/o6-ai-enclave-live/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/kubernetes/o6-ai-enclave-live) | [`docs/release2/evidence/O6/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6) |

## Delivery traceability chain

The Release 2 state and pipeline map documents the delivery path from Git to Azure through GitHub Actions, OIDC-authenticated Terraform plan, review, controlled apply, and evidence.

| Stage | What it proves | Where to inspect |
|---|---|---|
| Git commit | The change starts from version-controlled source. | Git history and pull request context |
| GitHub Actions workflow | The change enters a controlled workflow rather than a manual local apply path. | [`.github/workflows/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows) |
| OIDC-authenticated Terraform plan | The workflow authenticates without long-lived Azure deployment secrets and generates reviewable plan output. | [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml) |
| Review or approval gate | The plan is reviewed before infrastructure mutation. | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) |
| Controlled apply | Apply is bounded to the selected root and profile-aware workflow. | [Release 2 workflow folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows) |
| Evidence folder | Validation output is preserved for public-safe review. | [`docs/release2/evidence/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) |

## Reviewer workflow

A technical reviewer should be able to validate a claim without relying on trust.

Use this sequence:

1. Start from a claim on the portfolio page.
2. Open the related engineering note or release document.
3. Follow the source path to Terraform, Ansible, Kubernetes, workflow, or script code.
4. Open the evidence folder linked from the note.
5. Confirm the evidence shows the expected implementation signal.
6. Check the Release 2 state map when the claim involves Terraform root ownership, OIDC, controlled apply, or active profile guardrails.

This is why Code Traceability is separate from GitHub Actions OIDC. OIDC explains how delivery authenticates. Code Traceability explains how reviewers move from claim to source to evidence.

## Enterprise traceability hardening pattern

The current public portfolio already provides claim-to-source-to-evidence traceability. In stricter enterprise environments, the same pattern can be hardened further:

| Hardening pattern | Purpose |
|---|---|
| Required resource tags | Enforce source, owner, environment, Terraform root, and deployment context on resources. |
| Activity Log export | Preserve cloud control-plane operations in a central logging workspace or immutable storage target. |
| Protected environments | Require reviewer approval before workflow apply jobs can run. |
| Signed plan or provenance records | Attach a signed artifact linking commit, workflow run, plan, and apply output. |
| Azure Policy tag enforcement | Prevent resource creation when required traceability tags are absent. |
| Evidence retention policy | Keep validation output, sanitized logs, and screenshots according to review or audit needs. |

These controls are not a replacement for the current evidence structure. They are the next hardening layer for organizations that require formal audit evidence retention.

## Engineering significance

Code Traceability demonstrates four delivery-engineering decisions:

1. Portfolio claims are mapped to implementation source and evidence, not left as narrative statements.
2. Release 2 delivery is traceable from Git through GitHub Actions, Terraform plan, approval, controlled apply, and validation evidence.
3. Reviewers can inspect public-safe evidence without needing privileged access to the live tenant.
4. Enterprise-grade traceability patterns can be layered on top through resource tags, Activity Log export, policy enforcement, and provenance records.

This page is the reviewer bridge between architecture presentation and implementation proof.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Portfolio claims map to source and evidence | [CODE_TRACEABILITY.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/CODE_TRACEABILITY.md) | Claim-to-documentation-to-source-to-evidence mapping |
| Release 2 delivery path is documented | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | Git commit, workflow, plan, review, apply, and evidence flow |
| OIDC workflow implementation is inspectable | [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml) | `id-token: write`, `azure/login@v2`, and Terraform validation stages |
| Release 2 evidence is organized by capability | [Release 2 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) | Evidence folders for Terraform, networking, AWX, AKS, AVD, AWS branch, and O6 |
| Full site page provides reviewer-friendly traceability | This page | Capability map, delivery chain, reviewer workflow, and hardening pattern |

## Review takeaway

Code Traceability shows that AzAWSLab is not just documented; it is reviewable.

A reviewer can start with a portfolio claim, follow it to source implementation, inspect the evidence folder, and understand how the delivery pipeline connects code changes to platform validation.