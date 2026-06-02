# AVD Secure Workspace

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/avd-secure-workspace/">
    <span class="portfolio-chip-label">Platform</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">AVD Workspace</span>
  </a>
</div>

!!! summary "Scope"
    Implementation detail and evidence paths for the Azure Virtual Desktop workspace that serves as the governed operator environment for private platform operations. This page covers host pool design, no-public-IP posture, FSLogix profile storage with private endpoint readiness, access governance through Entra ID and Conditional Access, platform toolchain readiness, and deployment preflight validation.

This page is intentionally scoped to the AVD workspace itself. Private AKS implementation is documented in the [Private AKS Platform](private-aks-platform/) page, and the combined AKS-and-AVD operating model is documented in the [Private AKS & AVD Architecture](private-aks-avd/) page.

## Workspace role

The AVD workspace is not presented as a general-purpose end-user desktop. It is the governed operator environment for Release 2 platform work.

Its purpose is to give engineers a controlled desktop from which they can reach private platform services, run approved tooling, and operate the environment without exposing AKS, storage, management services, or session hosts directly to unmanaged public access paths.

The workspace proves four platform design concerns:

- Operators enter through an identity-governed AVD access path.
- Session hosts are not exposed through public IP addresses.
- User and operator profiles persist through FSLogix on private storage paths.
- Platform tooling is staged inside a controlled workspace rather than depending on unmanaged local laptops.

## Architecture

```text
Engineer / operator
        |
        | Entra ID and Conditional Access
        v
Azure Virtual Desktop control plane
        |
        | brokered session access
        v
AVD host pool
  - session host with no public IP exposure
  - governed operator desktop
  - platform toolchain
        |
        v
FSLogix profile storage
  - Azure Files
  - private endpoint readiness
  - private DNS path where evidenced
        |
        v
Hub and private platform paths
  - firewall-governed routing
  - private platform services
  - AKS operations path
  - management services
```

This design separates user entry from private platform reachability. Users access the workspace through AVD and identity controls. Once inside the workspace, platform operations follow hub routing, firewall policy, and private endpoint patterns where evidenced.

## Design decisions

| Decision | Rationale | Evidence |
|---|---|---|
| AVD as governed workspace | Keeps platform administration inside a controlled desktop layer instead of unmanaged local workstations. | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) |
| No-public-IP session host posture | Reduces direct exposure of the operator workspace and avoids treating the session host as a public management VM. | O5 host/session evidence and `terraform/platform-avd/dev` |
| FSLogix profile containers | Preserves operator profile state, shell configuration, tool settings, and workspace continuity. | O5 FSLogix readiness evidence |
| Azure Files private endpoint readiness | Keeps profile traffic on private service paths where evidenced. | O5 private endpoint and DNS readiness evidence |
| Platform toolchain readiness | Prepares the workspace for platform operations using PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, and Helm. | O5 tool version and readiness evidence |
| Entra ID and Conditional Access access path | Aligns workspace entry with the identity and access model established in Release 1. | O5 access governance evidence and Release 1 identity evidence |
| Region, provider, SKU, and network preflight | Validates deployment constraints before buildout instead of relying on trial-and-error provisioning. | O5 preflight evidence and `terraform/platform-avd/dev` |

## Host pool and no-public-IP posture

The host pool provides the governed desktop layer for Release 2 operators. The session host is deployed without a public IP, so it is not exposed as a directly reachable management VM.

User access is brokered through the Azure Virtual Desktop control plane and gated by Entra ID and Conditional Access. From inside the session, platform operations follow the private routing model: tools on the AVD host reach private platform services through hub and spoke paths, firewall controls, and private endpoints where evidenced.

This design separates two concerns cleanly:

| Concern | Control |
|---|---|
| User entry into workspace | AVD control plane, Entra ID, Conditional Access |
| Workspace reachability to private services | Hub routing, firewall policy, private endpoint patterns |
| Operator tooling | Pre-staged platform toolchain on the AVD host |
| Host exposure | No public IP on the session host |

The design avoids direct public RDP exposure. Session access is brokered through AVD, while private platform reachability from the session host follows hub and spoke routing controls.

## FSLogix profile design

FSLogix provides profile persistence for the governed workspace. Operator state can survive session restarts and host lifecycle changes without depending on local machine state.

The O5 evidence focuses on FSLogix readiness and private profile storage paths. The design uses Azure Files as the profile storage layer and private endpoint readiness to keep profile access aligned with the private network model.

Profile persistence matters because an operator workspace is not just a disposable shell. Tool configuration, shell history, repository workspace state, and editor settings all affect operational consistency.

## Private endpoint and name-resolution readiness

The FSLogix storage path is designed around private endpoint readiness. The important control is that profile traffic follows a private service access model rather than unmanaged public storage paths.

Reviewers should inspect the O5 evidence for:

- Private endpoint readiness.
- Private DNS resolution path where captured.
- Storage account and file share readiness.
- FSLogix profile path validation.
- Session host access to the profile storage path.

This keeps the AVD page focused on workspace implementation while the broader Secure Transmission page covers the network security model.

## Platform toolchain readiness

The AVD workspace is pre-staged with the tools needed for platform operations.

The O5 evidence validates readiness for tools such as:

- PowerShell 7.
- Azure CLI.
- AWS CLI.
- Terraform.
- Git.
- Visual Studio Code.
- kubectl.
- Helm.

This is a key platform-engineering signal. Operators are not expected to run private platform operations from unmanaged local machines. The workspace contains the approved tooling required to manage infrastructure, Kubernetes, and cloud resources from inside the governed environment.

## Access governance with Entra ID and Conditional Access

Access to the AVD workspace is gated by Entra ID and Conditional Access. The broader Release 1 identity and endpoint controls provide the compliance signals used by this access model.

This page does not re-document the full identity architecture. That belongs in the Hybrid Identity Engineering and Modern Endpoint Management pages. The AVD-specific point is that the workspace is integrated into the same access governance model rather than standing apart as an unmanaged remote desktop.

## Deployment preflight and region governance

The AVD deployment includes preflight validation before buildout. This is important because AVD depends on regional availability, provider registration, VM SKU support, quota, subnet readiness, and storage/profile dependencies.

The O5 evidence documents the preflight approach, including:

- Region and paired-region readiness.
- Provider validation.
- SKU and quota checks.
- Network and subnet readiness.
- FSLogix and private endpoint readiness.

This is mature platform delivery: the design validates constraints before provisioning rather than discovering them halfway through deployment.

## Integration boundary with private AKS

The AVD workspace is a consumer of private platform services, including the private AKS platform. Operators can use the staged toolchain to work with private platform resources when routing, identity, and access controls permit it.

The detailed integration pattern between AVD and AKS is documented in the [Private AKS & AVD Architecture](private-aks-avd/) page. This page remains focused on AVD as the secure management entry point.

## Enterprise production hardening pattern

The Release 2 implementation demonstrates the AVD workspace pattern in a cost-controlled lab. In production, the same pattern can be hardened further.

| Area | Enterprise hardening pattern |
|---|---|
| Access governance | Conditional Access, MFA, compliant device requirements, sign-in risk controls, and privileged access workflows. |
| Session protection | Screen capture protection, watermarking, clipboard restrictions, and session timeout controls. |
| Operator separation | Separate host pools for platform operators, workload developers, and break-glass administration. |
| Profile protection | FSLogix storage backup, soft delete, storage firewall restrictions, private endpoint enforcement, and least-privilege share permissions. |
| Toolchain governance | Approved tool versions, golden image pipeline, package integrity checks, and change-controlled image promotion. |
| Monitoring | AVD diagnostic logs, sign-in logs, session activity, and Sentinel analytics for suspicious access patterns. |
| Privileged operations | Just-in-time elevation, PIM, approval workflow, and recording of sensitive administrative sessions where required by policy. |

These controls show how the demonstrated workspace pattern maps to a stricter enterprise operating standard.

## Engineering significance

AVD Secure Workspace demonstrates five platform-engineering decisions:

1. Platform administration is performed from a governed workspace rather than unmanaged local endpoints.
2. Session hosts avoid public IP exposure.
3. FSLogix preserves operator state while aligning profile access with private service paths.
4. The workspace contains the platform toolchain needed to operate Azure, AWS, Terraform, and Kubernetes workloads.
5. Deployment preflight and region governance are treated as part of the engineering process.

This page proves that Release 2 includes a controlled operator workspace, not just a remote desktop.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| AVD secure workspace is implemented | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5), [`terraform/platform-avd/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) | Host pool, workspace, desktop application group, session host, and Terraform root evidence |
| Session host avoids public IP exposure | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | Session host NIC posture and no-public-IP evidence |
| FSLogix private profile path is ready | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | FSLogix readiness, Azure Files profile path, private endpoint and DNS readiness where captured |
| Toolchain is staged for platform operations | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, and Helm readiness |
| Access governance uses Entra ID and Conditional Access | O5 evidence and Release 1 identity evidence | AVD access path, identity governance, and Conditional Access alignment |
| Deployment preflight checks are documented | [`docs/release2/evidence/O5/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5), [`terraform/platform-avd/dev/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) | Region, paired-region, provider, SKU, quota, subnet, and profile-storage readiness |
| AVD workspace supports private platform operations | [Private AKS & AVD Architecture](private-aks-avd/) and O5 evidence | Toolchain readiness, private operations path, and relationship to AKS platform operations |
| Enterprise hardening path is understood | This page | CA controls, screen protection, host pool separation, FSLogix protection, toolchain governance, monitoring, and PIM patterns documented as production extensions |

## Review takeaway

AVD Secure Workspace shows that Release 2 includes a governed operator desktop for private platform operations.

A reviewer can inspect O5 evidence, Terraform AVD code, FSLogix readiness, private endpoint readiness, access governance notes, and toolchain output to confirm that the workspace is part of the platform operating model rather than a standalone remote desktop.