# Terraform State Boundaries

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/terraform-state-boundaries/">
    <span class="portfolio-chip-label">Delivery</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Terraform State</span>
  </a>
</div>

!!! summary "Scope"
    Engineering rationale, root ownership model, pipeline boundary, remote state design, and evidence paths for the Release 2 Terraform split-state architecture. The design reduces blast radius, keeps review scope bounded, and maps each platform lifecycle to a clear Terraform root.

## State boundary model

Release 2 uses a split-state Terraform model rather than a single monolithic root.

Each root owns a distinct platform lifecycle. This keeps network changes, platform services, governance controls, AWS branch resources, and workload resources from being planned and applied as one uncontrolled unit.

| Design choice | Engineering rationale | Evidence path |
|---|---|---|
| Split Terraform roots by operational lifecycle | Reduces blast radius and allows each area of the platform to be planned, reviewed, and applied independently. | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) |
| Store state remotely in Azure Storage | Keeps state files out of the repository and enables backend locking through Azure Storage blob leasing. | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) |
| Use a dedicated state boundary per active root | Prevents unrelated platform domains from sharing one state file or one uncontrolled state ownership model. | [Terraform root directory](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| Keep local apply exceptional | Normal delivery is through GitHub Actions controlled apply; local apply requires explicit approval and documentation. | [Terraform README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| Use active profile guardrails for optional resources | Prevents accidental destroy or recreation of cost-sensitive hybrid resources such as VPN Gateway, FortiGate, Cisco CSR, route tables, and validation infrastructure. | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) |

## Split-state topology

```text
terraform/
  governance
      -> Azure Storage remote state: governance boundary

  platform-shared/dev
      -> Azure Storage remote state: shared services boundary

  platform-networking/dev
      -> Azure Storage remote state: network boundary

  platform-aks/dev
      -> Azure Storage remote state: private AKS boundary

  platform-avd/dev
      -> Azure Storage remote state: AVD workspace boundary

  platform-management/dev
      -> Azure Storage remote state: management and automation boundary

  workloads/dev
      -> Azure Storage remote state: workload boundary

  aws-branch/dev
      -> Azure Storage remote state: AWS branch boundary
```

## Active Terraform roots

The repository separates platform ownership into multiple Terraform roots. The important engineering signal is not only that Terraform exists, but that state ownership follows platform responsibility.

| Terraform root | Lifecycle scope | Key resources and responsibilities | Evidence path |
|---|---|---|---|
| `governance` | Platform governance and management structure | Management groups, policy assignments, and RBAC definitions. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `platform-shared/dev` | Shared platform services | Key Vault, shared identities, shared platform outputs, and common service dependencies. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `platform-networking/dev` | Network fabric | Hub-spoke networking, Azure Firewall, VPN Gateway, FortiGate integration, routing, NSGs, and optional hybrid profile flags. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `platform-aks/dev` | Private container platform | Private AKS, ACR integration, managed monitoring, workload identity, and AKS-specific platform dependencies. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `platform-avd/dev` | Secure administrative workspace | AVD host pool, workspace, session hosts, FSLogix storage, and private endpoint orientation. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `platform-management/dev` | Management and automation tooling | Management VM, Bastion patterns, and AWX-related infrastructure dependencies. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `workloads/dev` | Workload resources | Workload-level infrastructure and application-layer resources. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| `aws-branch/dev` | AWS multi-cloud edge | AWS branch foundation, Transit Gateway, Cisco CSR 8000V, BGP configuration, and route-map integration. | [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |

The retired root `environments/dev-retired-after-state-split` remains as traceability evidence for the earlier state model. It documents the platform's evolution from a simpler root layout into the current granular state architecture.

## Remote state design

Release 2 stores Terraform state remotely in Azure Storage. Each active root has its own backend boundary, using a dedicated state container or state path so that one root does not share state ownership with another.

The design uses three controls:

- **Dedicated state boundary per root** - each Terraform root has its own remote backend boundary, preventing unrelated platform domains from sharing the same state file.
- **Pipeline-scoped service principal access** - the deployment identity used by GitHub Actions has access to the state boundary required for the selected root rather than broad, informal operator access.
- **No cross-root remote state sharing** - roots do not depend on direct reads of another root's Terraform state. Cross-root relationships are handled through published cloud resources, data lookups, documented outputs, or explicit platform handoff points.

This prevents the state layer from becoming an invisible coupling mechanism between networking, governance, AKS, AVD, workloads, management, shared services, and AWS branch resources.

## Isolation in practice

Split state is a delivery-control decision, not a cosmetic folder layout.

It gives the platform four practical controls:

| Control | Engineering effect |
|---|---|
| Blast-radius reduction | A change to the AVD workspace does not plan changes against AKS, networking, governance, or AWS branch resources. |
| Review clarity | Reviewers can inspect the plan for the root being changed instead of reviewing a large cross-platform plan. |
| Operational ownership | Network, private platform, governance, management, and workload areas can be treated as different lifecycle domains. |
| State-locking behavior | Azure Storage backend locking protects each remote state file from concurrent modification. |

## Pipeline boundary

Release 2 uses a GitHub Actions controlled-apply model. The normal path is not routine local `terraform apply`.

The delivery pattern is:

1. A feature branch proposes a change.
2. Terraform plan runs with OIDC-authenticated access.
3. Plan output is reviewed before apply.
4. Apply is controlled and approved.
5. The state boundary keeps execution scope tied to the selected root.

```text
Pull request or controlled workflow
        |
        v
OIDC-authenticated Terraform plan
        |
        v
Human review of plan output
        |
        v
Approval gate
        |
        v
OIDC-authenticated controlled apply
```

The important control is that the pipeline is designed around explicit root scope. A networking change should be reviewed as a networking plan. An AVD change should be reviewed as an AVD plan. An AWS branch change should be reviewed as an AWS branch plan.

## Active profile guardrails

Some roots include optional or cost-sensitive resources. The network and AWS branch roots are examples because they can include VPN Gateway, FortiGate, Cisco 8000V, route tables, public IPs, validation infrastructure, and other resources that should not be accidentally created, destroyed, or replaced.

The engineering rule is simple:

- Use profile-aware wrapper scripts for active optional roots where applicable.
- Treat a local plan as a preflight signal, not as permission to apply.
- Stop immediately if a plan proposes unexpected destroy or replacement of critical network, VPN, FortiGate, Cisco, route, or public-access components.
- Keep apply controlled through GitHub Actions unless explicitly approved.

## Enterprise state hardening pattern

The current implementation keeps state remote, scoped, and outside the repository. In a stricter enterprise environment, the same pattern can be hardened further by applying additional controls around the state storage plane:

- Customer-managed keys for storage encryption where regulatory or tenant policy requires key ownership.
- Private endpoint access to the storage account so state traffic does not traverse public network paths.
- Storage firewall restrictions and least-privilege RBAC for the pipeline identity.
- Blob versioning, soft delete, and immutable retention where recovery and audit requirements justify them.
- Separate storage accounts or subscriptions for highly sensitive control-plane state.
- Break-glass access procedures for state recovery, with audit logging enabled.

Terraform state can contain sensitive resource metadata. Treating the backend as a control-plane asset is part of the platform design, not an implementation detail.

## Engineering significance

Terraform State Boundaries demonstrates six delivery-engineering decisions:

1. The platform is split by lifecycle ownership rather than managed as one monolithic Terraform root.
2. Remote state is protected outside the repository and locked through Azure Storage.
3. Each active root has a dedicated state boundary instead of uncontrolled shared state ownership.
4. GitHub Actions OIDC is the normal delivery path, reducing dependency on long-lived static credentials.
5. Plan-review-apply separation gives reviewers a real control point before infrastructure mutation.
6. Active profile guardrails protect optional and cost-sensitive hybrid resources from accidental drift or destructive local plans.

This is the difference between using Terraform as a deployment script and using Terraform as a platform control plane.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Release 2 uses a split-state Terraform model | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | Split-state model and root-to-lifecycle mapping |
| Terraform roots are separated by platform lifecycle | [Terraform root directory](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) | `governance`, `platform-shared/dev`, `platform-networking/dev`, `platform-aks/dev`, `platform-avd/dev`, `platform-management/dev`, `workloads/dev`, and `aws-branch/dev` |
| Each active root has a separate remote state boundary | Backend configuration under the active Terraform roots | Root-specific backend key, container, or state path and clear separation between governance, networking, AKS, AVD, workloads, management, shared services, and AWS branch state |
| Pipeline identity is scoped to deployment operations | GitHub Actions workflows and backend authentication configuration | OIDC login path, pipeline identity, and absence of long-lived deployment secrets in workflow code |
| Roots do not use direct cross-root `terraform_remote_state` coupling | Full-text search across `terraform/` | Absence of uncontrolled cross-root state reads; dependencies resolved through explicit platform interfaces or cloud data lookups |
| Network resources have their own root and guardrails | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | `platform-networking/dev`, active profile guardrails, VPN Gateway, FortiGate, and route-table stop conditions |
| AWS branch resources have their own root | [Terraform root directory](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) | `aws-branch/dev` and its AWS branch lifecycle scope |
| Controlled apply is the normal delivery model | [Terraform README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) and [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | GitHub Actions controlled apply, plan-review-apply separation, and local apply exception rule |
| State files are not committed to the repository | [Terraform README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) | Safety notes and remote-state discipline |
| OIDC is used for delivery authentication | [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md) | Secretless authentication section and GitHub Actions pipeline model |
| Enterprise state hardening pattern is understood | This page | Remote state treated as a protected control-plane asset, with optional CMK, private endpoint, firewall, RBAC, versioning, soft delete, and immutable retention patterns documented |

## Review takeaway

Terraform State Boundaries shows that Release 2 was delivered with state ownership, root scope, review control, OIDC authentication, dedicated state boundaries, and active profile guardrails.

This page is the delivery-engineering entry point for the rest of Release 2: networking, private AKS, AVD, AWX, backup, and AWS branch resources all depend on this state-boundary discipline.