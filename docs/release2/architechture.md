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

## ADR‑004: Infrastructure as Code (Terraform) with OIDC

**Context:** The project must be repeatable, auditable, and automatable to demonstrate professional DevOps practices. Long‑lived secrets (client secrets) pose a security risk.

**Decision:** Use **Terraform** for all Azure resource provisioning, with modules for networking, security, compute, and monitoring. Use **OpenID Connect (OIDC)** from GitHub Actions instead of storing client secrets. Terraform state is stored in Azure Storage with state locking enabled.

**Rationale:** OIDC provides short‑lived, scoped tokens. No secrets stored in GitHub or rotated manually. State locking prevents concurrent corruption.

**Consequences:** Requires a federated credential in the Entra ID app registration. Adds a few extra steps during setup but eliminates secret management.

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

## ADR‑007: Use Azure Firewall as primary inspection point

**Context:** Need central traffic inspection, outbound filtering, and logging. Third‑party NVAs (like FortiGate) are optional for multi‑vendor demos.

**Decision:** Deploy **Azure Firewall** in the Hub VNet. Use its policy engine for network and application rule collections. Send logs to Log Analytics.

**Rationale:** Cloud‑native, fully managed, integrates with Azure Monitor and Sentinel. Cost is manageable using ephemeral deployment (destroy after validation).

**Consequences:** VPN Gateway and UDRs must route traffic through the firewall. Firewall private IP must be known before UDRs can point to it (use `depends_on` or output variables).

---

## ADR‑008: Dynamic secrets (no hardcoded passwords)

**Context:** Hardcoding admin passwords in Terraform variables (even if `.gitignore`’d) is a security anti‑pattern.

**Decision:** Use `random_password` resource to generate a secure password. Store it in **Azure Key Vault**. The VM references the password via the Terraform resource (not a variable). The password is never written to disk or logs as plain text.

**Rationale:** Passwords are encrypted at rest in Key Vault. No human ever needs to know them. The VM’s custom script extension can pull the secret if needed.

**Consequences:** Terraform must create the Key Vault before generating the password (implicit dependency). Adds a few resources but vastly improves security posture.

---

## ADR‑009: Use Azure Lighthouse for cross‑tenant delegation

**Context:** The project should demonstrate MSP‑style multi‑tenant administration.

**Decision:** Deploy an ARM template to a second (customer) tenant that delegates Contributor access to the main tenant. Validate by listing resources from the main tenant.

**Rationale:** Lighthouse is the Microsoft‑recommended way to manage multiple tenants securely. It shows understanding of delegated administration, least‑privilege roles, and cross‑tenant operations.

**Consequences:** Requires a second Entra tenant (free) and a second subscription (free trial). The demo can be ephemeral (destroy after evidence). If not possible, a design document and template suffice.

---

## ADR‑010: Prefer portal verification + CLI automation

**Context:** Recruiters expect both automation skills (Terraform, Ansible, CLI) and the ability to use portals and dashboards for validation.

**Decision:** Implementation is **code‑first** (Terraform, CLI, Ansible). Verification captures **both** terminal outputs **and** portal screenshots (policy compliance, Sentinel incidents, firewall rules).

**Rationale:** CLI proves automation; portal screenshots prove understanding of the Azure management plane and are easily consumed by non‑technical reviewers.

**Consequences:** Increase evidence capture time but produces a richer portfolio.

---

## Summary of Key Decisions

| Area | Decision |
|------|----------|
| Domain strategy | Subdomains per namespace (`hq`, `entra`, `br1`) |
| VM public IPs | Only for jumpbox, VPN Gateway, Firewall; workloads private |
| Server identity | AD joined (`hq.azawslab.co.uk`), not Entra joined |
| IaC | Terraform with modules, OIDC, remote state locking |
| Config management | Ansible roles, run from jumpbox, `ansible-lint` |
| Environments | Dev/prod via workspaces or separate folders |
| Firewall | Azure Firewall (primary); optional FortiGate |
| Secrets | Generated via `random_password`, stored in Key Vault |
| Cross‑tenant | Azure Lighthouse (ARM template + second tenant) |
| Verification | Both terminal and portal evidence |

---

**This ADR is a living document. Update it as new architectural decisions are made.**

# End‑to‑End Architecture Diagram – Azawslab Enterprise Hybrid Security (Release 1 & 2)

```mermaid
flowchart TB
    subgraph OnPrem [🖥️ On‑Premises / Simulated (Release 1 & RODC)]
        AD[Active Directory Domain Controllers<br/>DC1, DC2 (on‑prem)<br/>Domain: hq.azawslab.co.uk]
        MEM[Microsoft Endpoint Manager]
        EXCH[Exchange Server]
        RODC[Read‑Only Domain Controller<br/>br1.azawslab.co.uk<br/>(Branch Site)]
    end

    subgraph AWS [☁️ AWS (Optional Simulation)]
        AWSServer[AWS Lightsail Windows VM<br/>Simulates on‑prem / Branch RODC]
    end

    subgraph Azure [☁️ Microsoft Azure (Release 2)]
        subgraph Identity [🔐 Identity & Governance]
            EntraID[Microsoft Entra ID<br/>entra.azawslab.co.uk<br/>Hybrid Identity Sync]
            Policy[Azure Policy<br/>Allowed Locations, Tags]
            RBAC[RBAC + Key Vault<br/>Secrets & Access Control]
        end

        subgraph Networking [🌐 Hub‑Spoke Networking]
            HubVNet[Hub VNet<br/>10.0.0.0/16]
            SpokeWorkload[Spoke – Workloads<br/>10.1.0.0/16]
            SpokeAVD[Spoke – AVD<br/>10.2.0.0/16]
            SpokeForti[Spoke – FortiGate NVA<br/>(Optional)<br/>10.3.0.0/16]
            VPNGW[VPN Gateway]
            Firewall[Azure Firewall<br/>Central Inspection]
            Bastion[Azure Bastion / Jumpbox]
        end

        subgraph Compute [💻 Compute & Configuration]
            WinVM[Windows Server VM<br/>(IIS, test workloads)]
            LinuxJumpbox[Linux Jumpbox<br/>(Ansible execution)]
            AVD[Azure Virtual Desktop<br/>Session Hosts + FSLogix]
        end

        subgraph Security [🛡️ Security & Monitoring]
            Defender[Defender for Cloud<br/>Secure Score, CSPM]
            Sentinel[Microsoft Sentinel<br/>SIEM, Analytics Rules]
            Logs[Log Analytics Workspace<br/>Centralised Logs]
            Alerts[Azure Monitor Alerts<br/>Email Action Group]
        end

        subgraph DR [💾 Disaster Recovery]
            Backup[Azure Backup<br/>Daily backups, 30‑day retention]
            ASR[Azure Site Recovery<br/>Replication to secondary region]
        end
    end

    subgraph Mgmt [⚙️ Management & CI/CD]
        GitHub[GitHub Repository<br/>Terraform modules, Ansible roles]
        Actions[GitHub Actions<br/>OIDC auth, plan/apply pipeline]
        Terraform[Terraform Cloud / CLI<br/>State locked in Azure Storage]
        Ansible[Ansible<br/>Role‑based config (ad‑join, IIS, baseline)]
    end

    %% Connectivity
    OnPrem -->|Site‑to‑Site VPN<br/>IPsec| VPNGW
    AWS -->|VPN or Simulated| VPNGW
    VPNGW --> HubVNet
    HubVNet --> Firewall
    Firewall --> SpokeWorkload
    Firewall --> SpokeAVD
    Firewall --> SpokeForti
    HubVNet --> Bastion
    Bastion -->|RDP/SSH| WinVM
    Bastion -->|RDP/SSH| LinuxJumpbox
    LinuxJumpbox -->|Ansible over private IP| WinVM

    %% Identity Flow
    AD -->|Entra Connect| EntraID
    RODC -->|Read‑only replication| AD
    EntraID -->|Conditional Access| Sentinel
    EntraID -->|RBAC| RBAC

    %% Management Flow
    GitHub --> Actions
    Actions -->|Terraform apply| Terraform
    Terraform -->|Deploys| HubVNet
    Terraform -->|Deploys| WinVM
    Terraform -->|Deploys| Firewall
    Actions -->|SSH into jumpbox| LinuxJumpbox
    LinuxJumpbox -->|Runs Ansible| WinVM

    %% Security Monitoring
    WinVM -->|Logs & Metrics| Logs
    Firewall -->|Diagnostics| Logs
    Defender -->|Recommendations| Sentinel
    Logs --> Sentinel
    Sentinel -->|Alerts| Alerts
    Alerts -->|Email| Mgmt

    %% DR
    WinVM -->|Backup| Backup
    WinVM -->|ASR replication| ASR

    %% Tags & Evidence
    Policy -->|Enforces tags| WinVM
    RBAC -->|Least privilege| Actions