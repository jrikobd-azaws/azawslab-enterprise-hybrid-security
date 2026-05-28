# 04. Private Platform & Secure Workspace

> **Part of** [Release 2 - Azure Platform Engineering, Security, Automation, Private Platform & AI Operations](./README.md)
>
> **Status:** Implemented and evidenced.

---

## What This Solves

Workloads that rely on public endpoints, unmanaged administrator workstations, and non-persistent user profiles create security exposure and operational friction. A production-grade platform must deliver containerised workloads through private networking, provide a governed workspace for administrative operations, and maintain user state across non-persistent sessions.

This capability story demonstrates two complementary solutions: **Private AKS (O4)** as the secure container runtime, and **Azure Virtual Desktop + FSLogix (O5)** as the controlled administrative and development workspace. Together they prove that sensitive workloads and privileged tools can operate entirely within private, governed boundaries.

---

## What Was Built

| Component | Description | Evidence |
|---|---|---|
| **Private AKS Cluster (O4)** | Private AKS cluster with private API access pattern; Azure Container Registry private access pattern | `docs/release2/evidence/O4/` |
| **AKS Egress Control** | Azure CNI networking with User-Defined Route forcing pod egress through Azure Firewall; validated at firewall and pod level | `docs/release2/evidence/O4/` |
| **AKS Observability** | Managed Prometheus and Grafana, dedicated private-cluster dashboards | `docs/release2/evidence/O4/` |
| **AKS Automation Integration** | AWX control plane readiness audit, tier execution evidence for AKS operations | `docs/release2/evidence/O4/` |
| **AVD Secure Workspace (O5)** | Personal host pool, workspace, desktop application group; session host with no public IP | `docs/release2/evidence/O5/` |
| **FSLogix Profile Persistence** | Azure Files with private endpoint, private DNS; FSLogix profile containers for user state | `docs/release2/evidence/O5/` |
| **AVD Toolchain** | Admin/dev toolchain readiness for PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, and Helm | `docs/release2/evidence/O5/` |
| **AVD Region Governance** | Norway East primary, Norway West paired-region validation; provider/SKU/network preflight | `docs/release2/evidence/O5/` |

**O4 and O5 are intentionally paired.** O4 provides the private workload runtime; O5 provides the controlled operator workspace used to reach and manage that runtime. This pairing allows the platform to keep workload control surfaces private while still giving engineers a persistent, governed toolchain for Azure, AWS, Terraform, AWX, kubectl, and Helm workflows.

---

## Architecture

```text
┌-------------------------------------------------------------┐
|                   Azure Hub VNet                             |
|                                                             |
|  ┌------------------┐  ┌--------------┐  ┌--------------┐   |
|  | Azure Firewall   |  | VPN Gateway  |  | FortiGate NVA |   |
|  `--------┬---------┘  `--------------┘  `--------------┘   |
|           |                                                  |
`-----------┼--------------------------------------------------┘
            |
   ┌--------┴--------┐
   ▼                 ▼
┌--------------┐  ┌------------------┐
| Spoke: AKS   |  | Spoke: AVD       |
|              |  |                  |
| ┌----------┐ |  | ┌--------------┐ |
| | Private  | |  | | Session Host | |
| | AKS      | |  | | (no public   | |
| | Cluster  | |  | |  IP)         | |
| `----------┘ |  | `------┬-------┘ |
| ┌----------┐ |  |        |         |
| | ACR      | |  | ┌------▼-------┐ |
| | (private | |  | | Azure Files  | |
| |  access) | |  | | (private     | |
| `----------┘ |  | |  endpoint)   | |
|              |  | `--------------┘ |
| ┌----------┐ |  |                  |
| | Prom/    | |  | ┌--------------┐ |
| | Grafana  | |  | | FSLogix      | |
| | (managed)| |  | | Profile      | |
| `----------┘ |  | `--------------┘ |
`--------------┘  `------------------┘

Operator Access Path:
  Entra ID + Conditional Access
        |
        ▼
  O5 AVD Secure Workspace
   |-- Terraform / Azure CLI / kubectl / Helm
   |-- AWX access path
   `-- O4 Private AKS operations path
```

![Release 2 private platform and secure workspace](../../diagrams/release2/private-platform-secure-workspace.png)

---

## How It Works

### 1. Private AKS as the Secure Container Runtime

The AKS cluster is deployed with a **private API access pattern** and no public API exposure in the validated design. Administrative access to the cluster follows the private network path defined for the platform, using controlled operator access rather than public endpoints.

Pod networking runs on **Azure CNI**, assigning real IP addresses within the spoke subnet space. A **User-Defined Route** (UDR) table bound to the AKS subnet captures all outbound traffic (`0.0.0.0/0`) and forces it to the next-hop address of the Azure Firewall private IP. This design is validated by both firewall-level and pod-level egress tests (e.g., `o4-aks-firewall-egress-validation.txt` and `o4-aks-firewall-egress-pod-validation.txt`).

Managed **Prometheus and Grafana** provide cluster and workload observability, with dedicated dashboards configured during deployment. AWX integration has been validated: readiness audits and tier-execution evidence confirm the automation control plane can manage AKS workloads alongside the rest of the platform.

### 2. AVD + FSLogix as the Secure Administrative Workspace

The O5 workspace is not a generic virtual desktop - it is the **governed operator console** for the entire Release 2 platform. It also functions as the exclusive trusted plane for executing `kubectl` and Helm commands against the private AKS API endpoint.

A personal host pool, workspace, and desktop application group are deployed within the AVD spoke VNet. The session host has **no public IP**; all inbound access is gated through Entra ID and Conditional Access, requiring compliant, managed devices.

The host is pre-staged with the full administrative toolchain: PowerShell 7, Azure CLI, AWS CLI, Terraform, Git, VS Code, kubectl, and Helm. This readiness has been validated as part of the O5 design and preflight checks.

**FSLogix** profile containers store user state on **Azure Files**, accessed over a **private endpoint**. Private DNS supports resolution of the FSLogix storage path inside the VNet. The profile persists independently of the session host lifecycle, allowing the host to be re-imaged or replaced without loss of tool configurations, command history, or workspace state.

### 3. Region Governance and Paired-Region Validation

The O5 deployment involved deliberate architectural decision-making around Azure service regional constraints. The broader O1-O4 platform is governed around **Norway East and Norway West**. AVD metadata and workspace planning required alignment with Microsoft Desktop Virtualization regional availability. The final O5 governance validation (captured in `o5-governance-paired-region-validation.txt`) confirms **Norway East** as the primary region, with **Norway West** enabled for paired-region backup, disaster recovery, and geo-redundant services. Preflight checks for provider registration, SKU quotas, and network overlap were also validated (`o5-preflight-policy-provider-sku-network.txt`).

---

## Evidence

| What | Where | Why It Matters |
|---|---|---|
| Private AKS running state, private API posture | `docs/release2/evidence/O4/` | Proves cluster operates without public API exposure |
| Azure Firewall egress validation (firewall + pod) | `docs/release2/evidence/O4/` | Proves forced-tunneling and UDR steering work as designed |
| Internal application reachability | `docs/release2/evidence/O4/` | Proves private network paths for hosted apps |
| Managed Prometheus / Grafana | `docs/release2/evidence/O4/` | Proves observability without self-managed monitoring infra |
| AWX readiness and tier execution | `docs/release2/evidence/O4/` | Proves automation control plane can operate AKS workloads |
| AVD workspace: host pool, workspace, app group | `docs/release2/evidence/O5/` | Proves secure workspace deployed and configured |
| FSLogix private endpoint readiness | `docs/release2/evidence/O5/` | Proves private profile-storage design and readiness |
| Governance paired-region validation (Norway East / West) | `docs/release2/evidence/O5/` (`o5-governance-paired-region-validation.txt`) | Proves architectural handling of regional service constraints |
| Provider, SKU, and network preflight | `docs/release2/evidence/O5/` (`o5-preflight-policy-provider-sku-network.txt`) | Proves operational readiness checks before deployment |

---

## Operational Notes

- **Private AKS uses a private API access pattern in the validated design.** All cluster operations require private network connectivity from the hub or via the AVD workspace.
- **Validated pod egress follows the Azure Firewall inspection path.** Workloads cannot bypass the Azure Firewall for outbound connectivity as confirmed by pod-level tests.
- **The AVD session host has no public IP.** It is reachable only through the AVD control plane and Entra-authenticated sessions.
- **FSLogix profiles are stored on Azure Files with a private endpoint.** The storage account is not accessible from the public internet.
- **The AVD workspace is the intended operations console.** Engineers use it for all privileged platform operations; local workstation access to production subscriptions is unnecessary and discouraged.
- **Region governance is enforced.** Norway East is the primary deployment region, with Norway West as the paired-region DR target.

---

## What I Learned

- **Private AKS changes the security model completely.** With a private API access pattern, the attack surface shrinks dramatically, and every operational path must be deliberate.
- **AVD as an administrative workspace is a forcing function for good access hygiene.** When all tools live inside a governed boundary, there is no temptation to run privileged commands from an unmanaged device.
- **FSLogix solves the state problem for non-persistent desktops elegantly.** Profile persistence is a prerequisite for administrative workspaces; FSLogix delivers it without complicating the host lifecycle.
- **Regional service constraints are a real architectural challenge.** AVD metadata regions, VM SKU availability, and provider registration all had to be checked, validated, and documented - just as they would in a production planning exercise.

---

## Implementation Positioning

This capability demonstrates two essential production-style patterns: a **secure, private container runtime** and a **governed, persistent administrative workspace**. The private AKS cluster proves that containerised workloads can operate without public exposure, while the AVD + FSLogix workspace proves that privileged operations can be centralised inside controlled boundaries. Together, they provide strong evidence for **Senior Cloud Platform Engineer**, **DevOps / SRE**, and **Cloud Security Architect** roles.

Reviewers should focus on:
- The private API access pattern and the firewall-enforced pod egress path (including UDR steering and Azure CNI).
- The deliberate toolchain pre-staging and the exclusive AVD-to-AKS operations path.
- The regional governance validation and preflight checks, which demonstrate architectural maturity beyond simple resource deployment.