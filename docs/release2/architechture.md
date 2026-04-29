# Architecture Decision Records (ADR) – Azawslab Enterprise Hybrid Security

**Project:** Azawslab Enterprise Hybrid Security  
**Releases:** 1 (Hybrid Workplace Foundation) and 2 (Azure Platform & Security)  
**Status:** Active / Implemented  

This document records significant architectural decisions, their context, and the rationale behind them. It serves as a reference for maintainers and as evidence of professional design thinking for recruiters.

---

## ADR‑001: Use a single root domain with segregated subdomains

**Context:** The project needed clear separation between on‑premises Active Directory, cloud identity (Entra ID), and branch office identity. The root domain `azawslab.co.uk` was already owned.

**Decision:** Use subdomains for each distinct identity namespace:
- `corp.azawslab.co.uk` – Release 1 on‑prem AD (completed)
- `belfast.azawslab.co.uk` – Release 1 advanced validation (completed)
- `hq.azawslab.co.uk` – Release 2 corporate HQ AD (greenfield)
- `br1.azawslab.co.uk` – Release 2 branch office RODC
- `entra.azawslab.co.uk` – Release 2 Entra ID tenant (greenfield)

**Rationale:** Subdomains are free to delegate, easy to verify, and clearly separate concerns. Different subdomains can exist in different tenants (e.g., `entra` in new tenant, `corp` locked in old tenant). This mirrors real‑world enterprise restructures, mergers, or greenfield initiatives.

**Consequences:** UPN suffix transformation required in Entra Connect (on‑prem `@hq.azawslab.co.uk` → cloud `@entra.azawslab.co.uk`). Adds a small configuration step but proves advanced identity management.

---

## ADR‑002: Keep workload VMs private (no public IPs)

**Context:** In many lab projects, VMs are assigned public IPs for easy access. In production, this is a security risk.

**Decision:** All workload VMs (web servers, domain controllers, RODCs) have only private IPs. A **jumpbox** (Linux VM in Hub) or **Azure Bastion** provides administrative access. Public IPs are used only for VPN Gateway, Azure Firewall, and the jumpbox (or Bastion).

**Rationale:** Reduces attack surface. Forces use of secure pathways (VPN, Bastion, jumpbox). Simulates real enterprise "private‑only" networks.

**Consequences:** Ansible must be run from within the Azure environment (e.g., from the jumpbox) or via a self‑hosted runner. GitHub Codespaces cannot directly reach private VMs.

---

## ADR‑003: Server join to on‑prem AD, not Entra ID

**Context:** Windows Server workloads require Kerberos, Group Policy, and access to on‑prem resources. Entra ID join is designed for client OS (Windows 10/11).

**Decision:** All servers (DC1, DC2, MEM1, EXCH1, IIS servers) are joined to the on‑premises AD domain (`hq.azawslab.co.uk`). Client devices (if any) would be Entra ID joined.

**Rationale:** Maintains backward compatibility, centralises policy via Group Policy, and supports hybrid scenarios where users authenticate via AD credentials that are synced to Entra ID.

**Consequences:** A site‑to‑site VPN is required between Azure and the on‑prem AD (simulated in AWS Lightsail or local Hyper‑V). The VPN must be stable for domain join and authentication.

---

## ADR‑004: Infrastructure as Code (Terraform) with OIDC (Secretless Automation)

**Context:** The project must be repeatable, auditable, and automatable to demonstrate professional DevOps practices. Long‑lived secrets (client secrets) pose a security risk.

**Decision:** Use **Terraform** for all Azure resource provisioning, with modules for networking, security, compute, and monitoring. Use **OpenID Connect (OIDC)** from GitHub Actions instead of storing client secrets. Terraform state is stored in Azure Storage with state locking enabled.

**Rationale:** OIDC provides short‑lived, scoped tokens. No secrets stored in GitHub or rotated manually. State locking prevents concurrent corruption. This aligns with the “Secretless” security principle mandated in Phase 0.

**Consequences:** Requires a federated credential in the Entra ID app registration. Adds a few extra steps during setup but eliminates secret management and enables direct CLI validation from GitHub Actions.

---

## ADR‑005: Ansible for post‑deployment configuration, with roles

**Context:** VMs deployed by Terraform need additional configuration (domain join, security baselines, application installation). A monolithic playbook is hard to maintain and reuse.

**Decision:** Use **Ansible roles** (`common`, `ad-join`, `webserver`). A `site.yml` imports the roles. Run `ansible-lint` in CI.

**Rationale:** Roles are reusable, composable, and easier to test. `ansible-lint` enforces best practices. The structure mirrors enterprise automation.

**Consequences:** Requires Ansible installed on a jumpbox (or self‑hosted runner) that can reach private VMs. Inventory file must use `ansible_ssh_common_args` to proxy through Bastion or jumpbox.

---

## ADR‑006: Multi‑environment separation (Dev / Prod)

**Context:** Real projects have separate development and production environments. The IaC should support both without code duplication.

**Decision:** Use **Terraform workspaces** (or folder‑based `environments/dev`, `environments/prod`). Each environment uses different CIDR blocks, naming prefixes (`-dev-` vs `-prod-`), and separate state files.

**Rationale:** Isolates changes, reduces risk of production outages, and demonstrates mature DevOps practices.

**Consequences:** GitHub Actions must select the correct workspace based on branch (e.g., `release-2` → dev, `main` → prod). Adds complexity but is expected in professional settings.

---

## ADR‑007: Functional traffic separation – Azure Firewall (internet egress) + FortiGate NVA (East‑West/Hybrid)

**Context:** Using a single firewall for all traffic types leads to policy bloat and performance bottlenecks. Native Azure Firewall lacks deep BGP capabilities for multi‑cloud routing, while third‑party NVAs add complexity for simple internet egress.

**Decision:** Deploy **two parallel security appliances**:
- **Azure Firewall** in the Hub VNet – handles all `0.0.0.0/0` internet egress using FQDN tags for Microsoft services.
- **FortiGate NVA** (in a dedicated Spoke or Hub) – handles East‑West (Spoke‑to‑Spoke) and hybrid traffic (AWS, on‑prem). Acts as the BGP routing engine.
Traffic is steered via User Defined Routes (UDRs) based on destination prefix: `0.0.0.0/0` → Azure Firewall private IP; `10.0.0.0/8` (internal) → FortiGate NVA IP.

**Rationale:** Best‑of‑breed approach: Azure Firewall is cloud‑native, fully managed, and cost‑effective for internet egress. FortiGate provides advanced BGP, route manipulation, and deep packet inspection for hybrid and multi‑cloud traffic. Functional separation avoids single points of policy overload.

**Consequences:** Requires careful UDR design and maintenance of two sets of rules. Adds complexity but demonstrates enterprise‑grade defense‑in‑depth. FortiGate is ephemeral (deploy → validate → destroy) to respect the $200 budget.

---

## ADR‑008: Dynamic secrets (no hardcoded passwords)

**Context:** Hardcoding admin passwords in Terraform variables (even if `.gitignore`’d) is a security anti‑pattern.

**Decision:** Use `random_password` resource to generate a secure password. Store it in **Azure Key Vault**. The VM references the password via the Terraform resource (not a variable). The password is never written to disk or logs as plain text.

**Rationale:** Passwords are encrypted at rest in Key Vault. No human ever needs to know them. The VM’s custom script extension can pull the secret if needed.

**Consequences:** Terraform must create the Key Vault before generating the password (implicit dependency). Adds a few resources but vastly improves security posture.

---

## ADR‑009: Use Azure Lighthouse for cross‑tenant delegation (MSP simulation)

**Context:** The project should demonstrate MSP‑style multi‑tenant administration.

**Decision:** Deploy an ARM template to a second (customer) tenant that delegates Contributor access to the main tenant. Validate by listing resources from the main tenant (CLI: `az vm list --subscription <customer-sub-id>`).

**Rationale:** Lighthouse is the Microsoft‑recommended way to manage multiple tenants securely. It shows understanding of delegated administration, least‑privilege roles, and cross‑tenant operations.

**Consequences:** Requires a second Entra tenant (free) and a second subscription (free trial). The demo can be ephemeral (destroy after evidence). If not possible, a design document and template suffice.

---

## ADR‑010: Replace legacy VPN with Entra Global Secure Access (GSA) – Zero Trust SSE

**Context:** Legacy OpenVPN P2S creates a “dial‑in” culture, provides excessive network‑level access, incurs high costs (Azure VPN Gateway ~$138/month), and lacks identity‑aware granularity or device compliance checks.

**Decision:** Decommission the Azure VPN Gateway and migrate to **Microsoft Entra Global Secure Access (GSA)**:
- **Private Access:** Clientless ZTNA for RDP and private applications.
- **Internet Access:** Identity‑based Secure Web Gateway (SWG).
- **Remote Networks:** BGP/IPSec integration with FortiGate (Azure) and Cisco (AWS) to protect entire branch locations without per‑device agents.

**Rationale:** GSA enforces Zero Trust at the identity and device level, not network perimeter. Eliminates VPN infrastructure costs (FinOps). Provides deeper auditing (Entra Traffic Logs) and integrates with Conditional Access policies.

**Consequences:** Requires Terraform provider (`microsoft-graph`) and updates to client devices (GSA client). For this lab, validation focuses on router‑to‑PoP BGP handshake and clientless Private Access demo. The VPN Gateway is destroyed after Phase O4 evidence.

---

## ADR‑011: Ephemeral deployments for premium resources (FinOps)

**Context:** The project operates on a strict $200 Azure credit limit. Always‑on premium services (Azure Firewall, FortiGate NVA, AVD session hosts, Defender for Cloud premium plans) would exhaust the budget within days.

**Decision:** Implement an **ephemeral deployment model** for expensive resources:
- Deploy via Terraform → run validation (CLI commands, KQL queries, connectivity tests) → capture evidence → run `terraform destroy` immediately.
- Azure Firewall, FortiGate, Cisco NVA, and AVD scaling plans are only active during validation windows.
- The core Hub‑Spoke networking and Key Vault remain as low‑cost persistent state.

**Rationale:** Proves the ability to automate the full lifecycle (deploy → validate → teardown) while respecting cost controls. Demonstrates FinOps maturity essential for cloud engineering roles.

**Consequences:** Evidence must include terminal outputs showing both successful apply and clean destroy. State locking ensures no orphaned resources.

---

## ADR‑012: CLI‑First validation with portal screenshots as secondary evidence

**Context:** Recruiters expect deep automation skills, but non‑technical reviewers often prefer visual dashboards.

**Decision:** All validation **must** include CLI/terminal outputs as primary evidence:
- `terraform plan/apply` outputs
- `az` CLI queries (`az vm list`, `az policy assignment list`, `az resource-graph query`)
- KQL queries from Log Analytics
- Effective route table dumps
- BGP summary (`get router info bgp summary` from FortiGate)
Portal screenshots are captured only as supporting material (e.g., compliance dashboard, Sentinel incident view).

**Rationale:** CLI outputs are verifiable, scriptable, and eliminate ambiguity. Portal screenshots provide context for documentation but do not replace automation proof.

**Consequences:** Evidence directories (`docs/release2/evidence/`) contain plain text logs alongside limited images.

---

## Summary of Key Decisions (Updated)

| Area | Decision |
|------|----------|
| Domain strategy | Subdomains per namespace (`hq`, `entra`, `br1`) |
| VM public IPs | Only for jumpbox, VPN Gateway, Firewall; workloads private |
| Server identity | AD joined (`hq.azawslab.co.uk`), not Entra joined |
| IaC | Terraform with modules, **OIDC**, remote state locking |
| Config management | Ansible roles, run from jumpbox, `ansible-lint` |
| Environments | Dev/prod via workspaces or separate folders |
| Firewall | **Dual‑appliance**: Azure Firewall (internet egress) + FortiGate (East‑West/hybrid BGP) |
| Secrets | Generated via `random_password`, stored in Key Vault |
| Cross‑tenant | Azure Lighthouse (ARM template + second tenant) |
| Remote access (users) | **Entra Global Secure Access** (replaces legacy VPN) |
| Cost control | Ephemeral deployment for premium resources |
| Validation | **CLI‑first** (terminal outputs, KQL), portal secondary |

---

## End‑to‑End Architecture Diagram – Azawslab Enterprise Hybrid Security (Release 2 – Global Transit Hub)

```mermaid
flowchart TB
    subgraph OnPrem [🏢 On‑Premises HQ]
        AD[Active Directory<br/>hq.azawslab.co.uk]
        HyperV[Hyper‑V RRAS<br/>BGP ASN 65001<br/>Subnet 192.168.1.0/24]
    end

    subgraph AWS [☁️ AWS Branch]
        VPC[AWS VPC 172.16.0.0/16]
        CiscoNVA[Cisco Catalyst 8000V<br/>BGP ASN 65002]
        DMZ[DMZ Subnet 172.16.2.0/24]
        Trusted[Trusted Subnet 172.16.1.0/24]
    end

    subgraph Azure [☁️ Microsoft Azure – Global Transit Hub]
        subgraph Identity [🔐 Identity & Governance]
            EntraID[Microsoft Entra ID<br/>entra.azawslab.co.uk]
            GSA[Entra Global Secure Access<br/>SSE Edge – ZTNA + SWG]
            Policy[Azure Policy<br/>Allowed Locations, Tags]
            RBAC[RBAC + Key Vault]
        end

        subgraph Hub [🌐 Hub VNet 10.0.0.0/16]
            AzFirewall[Azure Firewall<br/>Internet Egress<br/>0.0.0.0/0 inspection]
            FortiGate[FortiGate NVA<br/>BGP ASN 65515<br/>East‑West & Hybrid Routing]
            Bastion[Azure Bastion / Jumpbox]
            VPNGW[VPN Gateway<br/>Legacy – to be decommissioned]
        end

        subgraph Spokes [🔌 Spoke VNets]
            SpokeWorkload[Workload Spoke<br/>10.1.0.0/16]
            SpokeAVD[AVD Spoke<br/>10.2.0.0/16<br/>FSLogix + Azure Files]
        end

        subgraph Security [🛡️ Security & Monitoring]
            Defender[Defender for Cloud<br/>CSPM, Secure Score]
            Sentinel[Microsoft Sentinel<br/>SIEM, KQL rules]
            Logs[Log Analytics Workspace]
            Alerts[Azure Monitor Alerts]
        end

        subgraph DR [💾 Disaster Recovery]
            Backup[Azure Backup<br/>Immutable Vault + MUA]
            ASR[Azure Site Recovery]
        end
    end

    subgraph Mgmt [⚙️ CI/CD & Automation]
        GitHub[GitHub Repo<br/>Terraform + Ansible roles]
        Actions[GitHub Actions<br/>OIDC – Secretless]
    end

    %% Hybrid & Multi‑Cloud Connectivity
    FortiGate -->|"BGP over IPSec"| HyperV
    FortiGate -->|"BGP over IPSec"| CiscoNVA
    CiscoNVA -->|"Routes 172.16.1.0/24 and 172.16.2.0/24"| FortiGate
    FortiGate -->|"Readvertises prefixes"| HyperV
    HyperV -->|"Readvertises 192.168.1.0/24"| FortiGate

    %% Traffic Steering (UDRs)
    SpokeWorkload -->|"0.0.0.0/0 -> Azure Firewall"| AzFirewall
    SpokeWorkload -->|"10.0.0.0/8 -> FortiGate"| FortiGate
    SpokeAVD -->|"0.0.0.0/0 -> Azure Firewall"| AzFirewall
    SpokeAVD -->|"10.0.0.0/8 -> FortiGate"| FortiGate

    %% Identity & Access
    EntraID -->|"Conditional Access"| GSA
    GSA -->|"ZTNA / Private Access"| SpokeWorkload
    GSA -->|"Remote Networks BGP"| FortiGate
    AD -->|"Entra Connect"| EntraID

    %% Management Flow
    GitHub --> Actions
    Actions -->|"Terraform apply (OIDC)"| Hub
    Actions -->|"Terraform apply"| SpokeWorkload
    Actions -->|"Ansible (via jumpbox)"| SpokeWorkload

    %% Monitoring & Security
    AzFirewall -->|"Diagnostics"| Logs
    FortiGate -->|"Logs"| Logs
    SpokeWorkload -->|"Metrics"| Logs
    Logs --> Sentinel
    Sentinel -->|"Incidents"| Alerts
    Defender -->|"Recommendations"| Sentinel

    %% DR
    SpokeWorkload -->|"Backup"| Backup
    SpokeWorkload -->|"ASR"| ASR

    %% Ephemeral / FinOps
    style AzFirewall fill:#f9f,stroke:#333,stroke-dasharray: 5 5
    style FortiGate fill:#f9f,stroke:#333,stroke-dasharray: 5 5
    style CiscoNVA fill:#f9f,stroke:#333,stroke-dasharray: 5 5
    style VPNGW fill:#ccc,stroke:#333,stroke-dasharray: 5 5