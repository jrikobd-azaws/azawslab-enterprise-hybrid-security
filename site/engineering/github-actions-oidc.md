# GitHub Actions OIDC

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
    Engineering rationale, authentication flow, workflow boundary, and evidence paths for the secretless GitHub Actions delivery model used in Release 2. The page focuses on OIDC, bounded Terraform execution, plan-review-apply separation, and controlled apply behavior.

## Delivery model

Release 2 uses GitHub Actions as the normal Terraform delivery path.

The delivery model is intentionally different from a local-apply workflow. A local Terraform plan may be useful for validation, but infrastructure mutation is expected to flow through controlled GitHub Actions workflows using OpenID Connect and explicit review.

| Design choice | Engineering rationale | Evidence path |
|---|---|---|
| Use GitHub Actions OIDC instead of static cloud deployment secrets | Reduces the risk of long-lived credential exposure and removes routine secret rotation from the deployment path. | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) |
| Use `id-token: write` and `azure/login@v2` | Allows GitHub Actions to request an OIDC token and exchange it for an Azure access token at runtime. | [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml) |
| Keep plan and apply as separate control points | Terraform plan output is reviewed before apply, preventing silent infrastructure mutation. | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) |
| Prefer root-specific apply workflows | Keeps apply scope bounded to the selected platform root rather than using a generic multi-root apply workflow. | [Disabled generic apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-apply.yml) |
| Require explicit apply confirmation for sensitive roots | Prevents plan execution from automatically becoming infrastructure mutation. | [Platform networking hybrid apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-platform-networking-hybrid-apply.yml) |

## Authentication flow

The OIDC delivery path removes the need to store an Azure client secret in the repository.

```text
GitHub Actions workflow
        |
        v
GitHub OIDC token request
        |
        v
Azure federated credential validation
        |
        v
Short-lived Azure access token
        |
        v
Terraform plan or controlled apply
        |
        v
Azure Resource Manager
```

The workflow identity is based on a trust relationship between GitHub Actions and Azure. GitHub issues a token for the workflow run; Azure validates the token against the configured federated credential; the workflow receives a short-lived Azure access token for the permitted operation.

The important engineering property is that the repository does not need to store a long-lived Azure deployment secret.

## Delivery control chain

```text
Git commit
    |
    v
GitHub Actions workflow
    |
    v
OIDC-authenticated Terraform plan
    |
    v
Human review / approval gate
    |
    v
Root-specific controlled apply
    |
    v
Azure Resource Manager
    |
    v
Validation output and evidence folder
```

The control chain is deliberately visible. A reviewer can follow a platform change from source control, through workflow execution, into a bounded Terraform root, and then into validation output or evidence.

## Workflow implementation signals

The current workflow structure separates validation, root-specific planning, and controlled apply.

| Workflow pattern | Implementation signal | Evidence path |
|---|---|---|
| CI matrix checks | The Release 2 Terraform CI workflow uses a matrix of Terraform roots for checks and validation. | [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml) |
| OIDC login | The workflow grants `id-token: write` and uses `azure/login@v2` with client ID, tenant ID, and subscription ID. | [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml) |
| Generic apply disabled | The generic multi-root apply workflow is disabled and points reviewers to dedicated root-specific workflows. | [Disabled generic apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-apply.yml) |
| Root-specific apply | Platform networking has a dedicated workflow with explicit profile input and apply confirmation. | [Platform networking hybrid apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-platform-networking-hybrid-apply.yml) |
| Apply confirmation | Apply is skipped unless the workflow input confirms the reviewed plan should be applied. | [Platform networking hybrid apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-platform-networking-hybrid-apply.yml) |

## Controlled apply boundary

The controlled apply model is not just about authentication. It is also about operator intent.

For roots that can affect expensive or sensitive infrastructure, the workflow uses explicit input and profile selection before running plan or apply. The platform networking workflow is the clearest example because it supports hybrid profiles for FortiGate, VPN Gateway, Azure Firewall, O3b AWS Cisco VPN, O4, O5, and service-chain validation.

This pattern creates three useful controls:

1. The selected profile is visible in the workflow run.
2. Terraform plan is generated with the selected root and profile flags.
3. Apply is skipped unless the operator explicitly confirms the reviewed plan should be applied.

## Relationship to Terraform state boundaries

OIDC does not replace Terraform state discipline. It protects the authentication path into the state-controlled delivery model.

The complete Release 2 delivery model combines:

- Split Terraform roots.
- Remote state in Azure Storage.
- Backend locking through blob leasing.
- GitHub Actions OIDC authentication.
- Plan-review-apply separation.
- Root-specific workflows.
- Active profile guardrails for optional or cost-sensitive resources.

This combination is what turns GitHub Actions from a task runner into a controlled infrastructure delivery plane.

## Relationship to code traceability

OIDC provides the authenticated deployment identity. Code Traceability explains how a reviewer follows a change from source to evidence.

The audit chain is:

```text
Git commit
    -> GitHub Actions workflow run
    -> OIDC-authenticated Terraform plan
    -> review or approval gate
    -> controlled Terraform apply
    -> evidence folder or validation output
```

The detailed traceability model remains in the [Code Traceability](code-traceability.md) engineering note.

## Security properties

| Property | How the design supports it |
|---|---|
| No long-lived Azure deployment secret in workflow code | GitHub Actions uses OIDC token exchange instead of storing a client secret in the repository. |
| Runtime identity is explicit | Azure receives a token issued for the workflow context and validates it through the federated credential trust. |
| Apply is deliberate | Root-specific apply workflows require explicit operator intent before mutation. |
| Review scope is bounded | Root selection and workflow design keep Terraform execution tied to the platform area being changed. |
| Generic apply is avoided | The generic multi-root apply workflow is disabled in favor of dedicated root-specific workflows. |

## Engineering significance

GitHub Actions OIDC demonstrates five delivery-engineering decisions:

1. Cloud deployment authentication avoids long-lived client secrets.
2. Terraform validation, planning, and apply are treated as separate lifecycle stages.
3. Root-specific workflows keep execution scope bounded.
4. Sensitive or cost-impacting roots require explicit profile selection and apply confirmation.
5. The delivery model is connected to the split-state architecture rather than operating as an isolated CI/CD script.

This is the delivery control plane for Release 2: Terraform state boundaries define what a workflow can affect; OIDC defines how the workflow authenticates; review and approval define when mutation is allowed.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| OIDC is part of the Release 2 delivery model | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | Secretless authentication and GitHub Actions pipeline model |
| Terraform CI uses OIDC permissions and Azure login | [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml) | `permissions: id-token: write` and `azure/login@v2` |
| Generic multi-root apply is disabled | [Disabled generic apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-apply.yml) | Workflow exits and directs users to dedicated root-specific workflows |
| Platform networking apply is root-specific and profile-aware | [Platform networking hybrid apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-platform-networking-hybrid-apply.yml) | Root working directory, profile input, selected Terraform flags, and `confirm_apply` gate |
| Plan-review-apply separation is documented | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | Pipeline flow and human review before apply |
| OIDC belongs to the split-state delivery model | [Terraform State Boundaries](terraform-state-boundaries.md) | Root ownership, remote state, active profile guardrails, and bounded execution scope |

## Review takeaway

GitHub Actions OIDC proves that Release 2 delivery was designed around secretless authentication, bounded root execution, explicit review, and controlled apply.

This is the mechanism that lets Terraform operate as a platform delivery control plane rather than a local operator script.