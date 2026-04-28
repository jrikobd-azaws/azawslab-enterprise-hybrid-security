# Phase 0: Foundation & Automation Bootstrap

## 1. Overview
Before deploying infrastructure, Phase 0 establishes the "Identity and Automation Plumbing." This phase follows the "Secretless" security principle by using **OpenID Connect (OIDC)** for GitHub Actions, ensuring no long-lived secrets are stored in the repository[cite: 2, 4].

| Aspect | Detail |
| :--- | :--- |
| **Business Problem** | Manual deployments are unauditable; static secrets (passwords) expire and create security vulnerabilities. |
| **Technical Solution** | Bootstrap an Azure Landing Zone with **OIDC Workload Identity Federation** and a remote **Terraform Backend** with state locking[cite: 2, 4, 6]. |
| **Standard Naming** | `[resource]-[service]-[env]-[region]` (e.g., `rg-dev-terraformstate-uksouth`)[cite: 5]. |

## 2. Implementation Steps

### Step 1: Governance & Identity Bootstrap
*   **Account Upgrade:** Upgrade the Azure Free Trial to **Pay-As-You-Go** to enable subscription democratization and higher resource limits while retaining the $200 credit[cite: 4].
*   **Domain Verification:** Verify `entra.azawslab.co.uk` in Entra ID to establish a professional hybrid identity namespace[cite: 4].
*   **Management Groups:** Deploy the initial hierarchy (`mg-platform`, `mg-landingzones`, `mg-sandbox`) to enable top-down policy inheritance[cite: 4].

### Step 2: Secretless Automation (OIDC)
*   **Service Principal:** Create `sp-terraform-gh` for GitHub Actions[cite: 4].
*   **Federated Credential:** Establish an OIDC trust relationship between the Azure App Registration and the `release-2` GitHub environment[cite: 2, 4].
*   **RBAC:** Assign the `Contributor` role to the Service Principal at the Subscription level to allow automated provisioning[cite: 4].

### Step 3: Infrastructure-as-Code (IaC) Backend
*   **State Storage:** Deploy `rg-dev-terraformstate-uksouth` and a globally unique storage account (e.g., `stdevterraform001`)[cite: 4].
*   **State Locking:** Create the `tfstate` container. The `azurerm` backend will automatically utilize blob leases to prevent concurrent state corruption[cite: 4, 6].

### Step 4: Repository Scaffolding
*   **Structure:** Initialize the standard folder hierarchy:
    *   `terraform/modules/` (Reusable infrastructure code)[cite: 4].
    *   `ansible/roles/` (Configuration management)[cite: 4, 6].
    *   `.github/workflows/` (CI/CD pipelines)[cite: 4].
    *   `docs/release2/evidence/` (Audit and validation captures)[cite: 4].

## 3. Verification Checklist
- [ ] **OIDC Handshake:** `.github/workflows/oidc-test.yml` completes successfully without static secrets[cite: 4].
- [ ] **Subscription Placement:** Subscription is nested under `mg-landingzones`[cite: 4].
- [ ] **State Lock:** Terraform successfully initializes with the remote `azurerm` backend[cite: 4, 6].
- [ ] **Identity:** Service Principal is visible in subscription **Access Control (IAM)** as a `Contributor`[cite: 4].

## 4. Recruiter Hook
"Established a production-grade automation foundation using **GitHub Actions with OIDC** for secretless authentication. Implemented a remote **Terraform backend** with state locking and a CAF-aligned **Management Group** hierarchy, ensuring all infrastructure changes are auditable, secure, and version-controlled from the first commit."

---


# Phase 1: Azure Landing Zone & Governance Foundation

| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Uncontrolled Spend & Compliance Risk:** Lack of granular cloud governance leads to unorganized subscriptions, data residency (GDPR) risks, and runaway costs due to unmanaged resource deployment. |
| **Technical Solution** | **CAF-Aligned Management Groups:** Deploying a `Root > Platform & Landing Zones` hierarchy using **Terraform**. Implementing **Policy-as-Code** (Azure Policy) to enforce "Foundational Guardrails" (Allowed Regions: UK South, Allowed VM SKUs: B-Series/Free Tier). |
| **Acceptance Criteria** | 1. MG Hierarchy (mg-platform, mg-landingzones, mg-sandbox) deployed via **GitHub Actions**. 2. **Deny Policies** active at the Root level for non-compliant regions. 3. **Tagging enforced via Policy** (Environment, Project, Owner, CostCenter). 4. Subscription moved to the Root MG to centralize $200 credit usage while logically simulating hub/spoke boundaries. |
| **Validation** | **Policy Compliance Report:** Dashboard showing 100% compliance for "Allowed Locations". **Terraform State:** Verified in a remote Azure Storage Backend to ensure team-based state locking. |
| **CLI / IaC Focus** | `terraform plan` for execution and `az policy assignment list --scope "/providers/Microsoft.Management/managementGroups/mg-azawslab"` for verification. |
| **Evidence** | `docs/release2/evidence/P1/`: Terraform modules, Policy definitions (JSON), and **Azure Resource Graph** queries showing the hierarchical structure. |
| **Recruiter Hook** | "Architected a CAF-aligned Landing Zone using **Terraform and Azure Policy** to enforce Data Sovereignty and Cost Management at scale. Established a **'Secure-by-Design'** foundation that prevents non-compliant resources from being created, ensuring 100% governance automation from Day 1." |

---

## 1. Architectural Evolution: Target vs. Lab Implementation

To demonstrate enterprise architectural maturity while staying within project budget constraints, this project documents the delta between a full-scale corporate deployment and this technical proof-of-concept.

### A. Target Enterprise Architecture (The "Senior Engineer" Goal)
In a production environment, we utilize **Subscription Democratization** to provide physical isolation for billing, security, and networking limits.
```text
[Tenant Root Group]
      │
      └── [mg-azawslab-prod-global] (Enforced Guardrails)
            │
            ├── [mg-platform-prod-global]
            │     ├── [sub-connectivity-prod] (Hub VNet, Firewall, VPN)
            │     ├── [sub-identity-prod]     (Entra ID, Key Vault)
            │     └── [sub-management-prod]   (Log Analytics, Sentinel)
            │
            └── [mg-landingzones-prod-global]
                  └── [mg-corp-prod-global]
                        └── [sub-workload-prod] (Production Applications)
```
### Lab Implementation Diagram (Budget-Optimized)
Following the naming standard: `[resource]-[service]-[env]-[region]`.
```text
[Tenant Root Group]
      │
      └── [mg-azawslab-prod-global] (Policy: UK South Only | B-Series SKUs Only)
            │
            ├── [sub-azaws-enterprise-prod] (Upgraded Free Trial Sub)
            │     │
            │     ├── [rg-connectivity-prod-uksouth] (Simulated Platform Hub)
            │     ├── [rg-corp-prod-uksouth]         (Simulated Workload Spoke)
            │     └── [rg-identity-prod-uksouth]     (Simulated Shared Identity)
            │
            ├── [mg-platform-prod-global]      (Empty - Logical Placeholder)
            ├── [mg-landingzones-prod-global] (Empty - Logical Placeholder)
            └── [mg-sandbox-prod-global]      (Empty - Logical Placeholder)
			
```
---			

## Phase 2a: Terraform – Reusable Modules (The Modular Engine)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Inconsistent Infrastructure:** Manual or monolithic Terraform leads to "configuration drift," unmanaged secrets, and high maintenance debt[cite: 1, 6]. |
| **Technical Solution** | **Modular IaC Framework:** Implementing reusable modules for scale. Integration of **Dynamic Secrets** (Key Vault) and **Resource Lifecycle Protection**. |
| **Acceptance Criteria** | 1. Modular directory tree validated (`terraform/modules/`)[cite: 4, 5]. 2. `terraform validate` passes across all components[cite: 1]. 3. Admin passwords are 100% dynamic (Key Vault)[cite: 6]. 4. Workload VMs have zero Public IPs[cite: 2, 6]. |
| **Validation** | Successful `terraform plan` execution. Output must confirm `admin_password` is handled as a **(sensitive value)**[cite: 1, 6]. |
| **Evidence** | `docs/release2/evidence/P2a/`: Terminal output of `tf plan`, screenshot of Key Vault secrets, and the module directory tree[cite: 1, 4, 5]. |

### 2. Automation Architecture & Data Flow
This diagram illustrates how the **Root Configuration** orchestrates specialized **Modules** to build a secure environment[cite: 1].
```text
[ environments/dev/main.tf ]
          │
          ├── (01) Calls ──> [ modules/security ]
          │                    └── Deploy: kv-dev-platform-001[cite: 5]
          │                    └── Logic: Generate Random Password -> Store in KV[cite: 6]
          │
          ├── (02) Calls ──> [ modules/networking ]
          │                    └── Deploy: vnet-dev-uksouth-hub[cite: 5]
          │                    └── Logic: Hub-Spoke Peering & Subnets[cite: 5, 6]
          │
          ├── (03) Calls ──> [ modules/compute ]
          │                    └── Deploy: vm-dev-client-01[cite: 5]
          │                    └── Logic: NIC-only (No Public IP) + Get Password from KV[cite: 2, 6]
          │
          └── (04) Calls ──> [ modules/monitoring ]
                               └── Deploy: la-dev-platform[cite: 5]
                               └── Logic: Central Log Analytics Workspace[cite: 5]
```

---

## Phase 2b: Ansible Configuration Management (The Fleet Orchestrator)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Manual Configuration Debt:** Deployed VMs are "naked" and vulnerable[cite: 1]. Manual setup is slow, inconsistent, and lacks a "Source of Truth"[cite: 6]. |
| **Technical Solution** | **Role-Based Fleet Orchestration:** Utilizing Ansible roles for modular configuration management[cite: 6]. Connectivity is maintained via **Secure Bastion Proxies** to satisfy private-only networking[cite: 2, 6]. |
| **Acceptance Criteria** | 1. `ansible-lint` passes for all roles (`common`, `ad-join`, `webserver`)[cite: 6]. 2. VMs successfully join `hq.azawslab.co.uk` via private-only NICs[cite: 2, 6]. 3. Credentials managed via **Ansible Vault**[cite: 1]. |
| **Validation** | Successful execution of `site.yml` (Master Playbook) showing `changed=0` on re-run (Idempotency) and verified IIS connectivity. |
| **Evidence** | `docs/release2/evidence/P2b/`: Terminal outputs of role execution, Active Directory "Computer Object" screenshots, and security baseline verification[cite: 1, 5]. |

### 2. Operational Architecture
Ansible orchestrates configuration across the secure management boundary established in Phase 0[cite: 4, 6].
```text
[ GitHub Actions / CLI ]
          │
          └── (SSH/WinRM over Proxy) ──> [ Azure Bastion ]
                                              │
                                              └── (ProxyJump) ──> [ Private Spokes ]
                                                                        │
                                                  ┌─────────────────────┴─────────────────────┐
                                                  │                     │                     │
                                           [ Role: Common ]      [ Role: AD-Join ]     [ Role: Web ]
                                           - Security Hardening  - Domain Integration  - App Delivery							   
```

---
## Phase 2c: CI/CD Pipeline (The Automation Heartbeat)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Manual Deployment Risk:** Lack of audit trails, manual errors, and "click-ops" lead to unstable environments and security leaks[cite: 1]. |
| **Technical Solution** | **Secretless CI/CD Pipeline:** Implementing GitHub Actions with **OIDC authentication**[cite: 2, 4]. Integrated automated linting (Terraform/Ansible) and PR-based approval workflows[cite: 1, 6]. |
| **Acceptance Criteria** | 1. **Branch Protection** active on `release-2` (requires PR + Status Checks). 2. `terraform plan` automatically comments on PRs[cite: 1]. 3. `ansible-lint` passes before any apply[cite: 6]. |
| **Validation** | Successful PR cycle: Create PR -> Auto-Plan succeeds -> Review -> Merge -> Auto-Apply executes correctly in Azure[cite: 1]. |
| **Evidence** | `docs/release2/evidence/P2c/`: Screenshots of Green GitHub Action runs, PR comments with Terraform plans, and the branch protection configuration. |

### 2. CI/CD Workflow Architecture
This diagram illustrates the automated path from a code change to a live Azure resource[cite: 1, 6].
```text
[ Developer Branch ] 
          │
          └── (01) git push ──> [ GitHub Pull Request ]
                                         │
                                         ├── (02) Trigger: CI Workflow
                                         │     └── terraform fmt & validate
                                         │     └── ansible-lint roles/[cite: 6]
                                         │     └── terraform plan[cite: 1]
                                         │
                                         ├── (03) Outcome: Plan Comment on PR
                                         │     └── "Plan: 5 to add, 0 to change"
                                         │
          ┌── (04) Manual Review & Approval ──┘
          │
          └── (05) Merge to 'release-2' ──> [ Trigger: CD Workflow ]
                                                  │
                                                  └── (06) OIDC Login (No Secrets)[cite: 4]
                                                  └── (07) terraform apply -auto-approve[cite: 1]
```

---
## Phase 3: Enterprise Governance & Guardrails

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Compliance & Cost Drift:** Unmanaged deployments risk data residency violations (GDPR), cost overruns from oversized resources, and security gaps from exposed secrets. |
| **Technical Solution** | **Policy-as-Code (PaC) & Identity Governance:** Automated enforcement of "Deny" policies for regional compliance and cost control. Implementation of Least Privilege RBAC and automated secret rotation via **Azure Key Vault**[cite: 6]. |
| **Acceptance Criteria** | 1. **Data Sovereignty:** "Deny" policy for non-UK South regions active at Root MG[cite: 1, 5]. 2. **Cost Guardrails:** Allowed VM SKUs restricted to B-Series[cite: 1]. 3. **Governance:** Mandatory tagging enforced for all resources[cite: 5]. 4. **RBAC:** Least privilege roles assigned to `sp-terraform-gh` and security groups[cite: 3, 6]. |
| **Validation** | 100% compliance score in **Azure Policy Dashboard**[cite: 1, 5]. CLI verification: Attempting to deploy in `East US` or without tags must trigger an automated `Deny` action[cite: 1, 5]. |
| **Evidence** | `docs/release2/evidence/P3/`: Policy compliance reports, RBAC assignment lists, and CLI terminal outputs for secret retrieval[cite: 1, 5]. |

### 2. Operational Architecture
This diagram illustrates how governance "guardrails" flow from the management root down to the simulated workload boundaries[cite: 1, 3, 4].
```text
[ mg-azawslab-prod-global ] (Root Management Group)
          │
          ├── [ Policy: Data Sovereignty ] ──> (Deny: All regions except UK South)[cite: 1, 5]
          ├── [ Policy: Cost Management ]  ──> (Deny: All VM SKUs except B-Series)[cite: 1]
          ├── [ Policy: Mandatory Tags ]   ──> (Deny: Missing Env/Project/Owner)[cite: 5]
          │
          └── [ sub-azaws-enterprise-prod ] (Simulated Corporate Subscription)
                │
                ├── [ rg-dev-platform-uksouth ]
                │     └── [ kv-dev-platform-001 ] ──> (Managed Secrets Lifecycle)[cite: 5, 6]
                │           └── RBAC: azw-Security-Engineers (Reader)[cite: 5]
                │
                └── [ rg-dev-networking-uksouth ]
                      └── RBAC: sp-terraform-gh (Contributor)[cite: 4, 5]
```

Architected a 'Secure-by-Design' foundation by implementing Policy-as-Code guardrails at the Management Group level[cite: 1, 6]. Enforced data sovereignty (UK South) and strict cost management policies while managing the end-to-end secrets lifecycle through Azure Key Vault, ensuring 100% automated compliance across the landing zone[cite: 1, 5].
---
