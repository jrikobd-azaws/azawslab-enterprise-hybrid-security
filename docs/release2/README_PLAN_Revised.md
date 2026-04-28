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
### 3. Recruiter Hook
"Built a library of reusable Terraform modules following the 'DRY' principle[cite: 1]. Integrated Azure Key Vault for dynamic secret management and implemented resource lifecycle protection, demonstrating a production-grade approach to automated infrastructure lifecycle management[cite: 6].

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

### 3. Recruiter Hook
"Automated post-deployment configuration using Ansible Roles, ensuring all Windows workloads adhere to a hardened security baseline and are integrated into the hybrid identity forest via secure Bastion proxies[cite: 1, 6].
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
### 3. Recruiter Hook
"Implemented a production-grade CI/CD pipeline using GitHub Actions and OIDC, establishing a 'Secretless' deployment model[cite: 1, 4]. Integrated Branch Protection and automated linting to ensure all infrastructure changes are peer-reviewed, validated, and auditable before reaching production[cite: 6].

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

### 3. Recruiter Hook: 
"Architected a 'Secure-by-Design' foundation by implementing Policy-as-Code guardrails at the Management Group level[cite: 1, 6]. Enforced data sovereignty (UK South) and strict cost management policies while managing the end-to-end secrets lifecycle through Azure Key Vault, ensuring 100% automated compliance across the landing zone[cite: 1, 5]."

---
## Phase 4: Azure Lighthouse (MSP Delegated Administration)

### 1. Refined Phase Detail
| Aspect | Refined Detail  |
| :--- | :--- |
| **Business Problem** | **Identity Sprawl & Operational Silos:** Managing external environments (e.g., corporate acquisitions, B2B clients) traditionally requires creating risky B2B guest accounts, sharing credentials, and constantly switching directories. |
| **Technical Solution** | **Azure Delegated Resource Management:** Utilizing **Azure Lighthouse** via ARM/IaC templates to logically project external subscriptions into the primary management tenant, establishing a centralized, Zero Trust administration plane[cite: 1, 2]. |
| **Acceptance Criteria** | 1. Customer tenant securely projected into the primary `entra.azawslab.co.uk` tenant[cite: 1, 5]. 2. Primary `azw-Platform-Admins` group granted scoped `Contributor` access without creating guest accounts[cite: 4, 5]. 3. Cross-tenant queries execute successfully[cite: 5]. |
| **Validation** | Successful execution of `az vm list --subscription <customer-sub-id>` from the primary tenant context without requiring a directory context switch[cite: 1, 5]. |
| **Evidence** | `docs/release2/evidence/P4/`: Portal "My Customers" view, cross-tenant CLI terminal outputs, and the deployed Lighthouse ARM template (JSON)[cite: 1, 5]. |

### 2. Operational Architecture (Cross-Tenant Trust)
This diagram illustrates the logical projection of resources across separate Entra ID boundaries, eliminating the need for context switching or shared credentials[cite: 1, 2].
```text
[ Primary Tenant (Provider) ]             [ Secondary Tenant (Customer) ]
   (entra.azawslab.co.uk)                    (Customer Entra ID)
             │                                        │
             ├── [ azw-Platform-Admins ]              ├── [ Customer Subscription ]
             │            │                           │         └── [ Customer Resources ]
             │            └── (Lighthouse Projection) └──┐
             │                                           │
             └───────────────────────────────────────────┘
                       (Zero Trust Delegated Access: No B2B Guest Accounts)
```
					   
### 3. Recruiter Hook
"Architected a Managed Service Provider (MSP) operating model using Azure Lighthouse. Demonstrated advanced cross-tenant identity management by projecting external subscriptions into a centralized management plane, enabling secure, scalable, and credential-less administration across multiple Azure AD boundaries[cite: 1, 2]."

---
## Phase 5: Hub-Spoke Networking Foundation

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Lateral Movement & Uninspected Egress:** Flat networks allow attackers to move freely, and direct internet access from workloads bypasses corporate security inspection[cite: 1, 5]. |
| **Technical Solution** | **Hub-Spoke Topology & Forced Tunneling:** Deploying a central Hub VNet and peered Spoke VNets via Terraform[cite: 1, 5]. Implementing User Defined Routes (UDRs) to force all egress traffic to a central inspection point, and replacing public jump-boxes with **Azure Bastion**. |
| **Acceptance Criteria** | 1. Hub VNet contains specific subnets (`AzureBastionSubnet`, `AzureFirewallSubnet`, `GatewaySubnet`)[cite: 5]. 2. Bidirectional peering established between Hub and Spoke[cite: 5]. 3. UDR (0.0.0.0/0) attached to Spoke subnet[cite: 5]. 4. Workload VMs have **zero Public IPs**[cite: 2, 6]. |
| **Validation** | Pinging across the peering connection is successful. RDP from the internet fails, but access via Azure Bastion succeeds[cite: 5, 6]. |
| **Evidence** | `docs/release2/evidence/P5/`: CLI outputs of `az network vnet peering list`, effective route tables showing forced tunneling, and Bastion connection screenshots[cite: 1, 5]. |

### 2. Operational Architecture (Network Boundary)
This diagram illustrates the secure network boundary. Notice that the `GatewaySubnet` is provisioned to act as a future "socket" for the local Hyper-V lab connection[cite: 2, 5].
```text
[ Internet / Admin ]
          │
          └── (HTTPS) ──> [ Azure Bastion ] (Subnet: AzureBastionSubnet)[cite: 5, 6]
                                 │
  [ Local Hyper-V Lab ]          │ (RDP/SSH over Private IP)[cite: 6]
          │                      │
          : (Future VPN)         ▼
          :               [ Hub VNet (10.0.0.0/16) ]
          V                      ├── [ AzureFirewallSubnet ] (Next-Hop Target)[cite: 5]
 [ GatewaySubnet ] <──────────── └── [ Mgmt Subnet ]
                                         │
                                         │ (VNet Peering)[cite: 5]
                                         │
                                 [ Spoke VNet: Workload (10.1.0.0/16) ]
                                         ├── NSG: Inbound Allow from Bastion[cite: 5]
                                         ├── UDR: 0.0.0.0/0 -> Azure Firewall IP[cite: 5]
                                         └── [ vm-dev-client-01 ] (Private IP Only)[cite: 5, 6]
```
### 3. Recruiter Hook
"Architected an enterprise-grade Hub-Spoke network topology using Terraform. Implemented strict Zero Trust network boundaries by eliminating public IPs on workloads, utilizing Azure Bastion for secure access, and configuring User Defined Routes (UDRs) to ensure all traffic is forced through central security inspection[cite: 5, 6]."

---

## Phase 6: Azure Firewall & Central Inspection

### 1. Refined Phase Detail
| Aspect | Refined Detail  |
| :--- | :--- |
| **Business Problem** | **Data Exfiltration & Unaudited Traffic:** Direct outbound internet access from workloads exposes the enterprise to malware command-and-control (C2) communication and data theft. |
| **Technical Solution** | **Centralized Inspection:** Deploying **Azure Firewall** into the Hub VNet to act as the primary inspection point for all North-South and East-West traffic[cite: 2]. Managing rules via hierarchical **Firewall Policies** and streaming diagnostics to Log Analytics[cite: 5]. |
| **Acceptance Criteria** | 1. Firewall deployed in `AzureFirewallSubnet`[cite: 5]. 2. Network Rule allows outbound DNS (UDP/53)[cite: 5]. 3. Application Rule allows HTTPS to `*.microsoft.com` / `*.azure.com`[cite: 5]. 4. Spoke UDR dynamically updated with Firewall's private IP[cite: 5]. |
| **Validation** | From private Spoke VM: `nslookup` succeeds, but `curl http://example.com` is actively blocked by the firewall[cite: 5]. KQL query in Log Analytics proves the block was logged[cite: 1, 5]. |
| **Evidence** | `docs/release2/evidence/P6/`: Firewall policy screenshots, Spoke VM terminal output showing blocked traffic, and Log Analytics KQL query results[cite: 1, 5]. |

### 2. Operational Architecture (Traffic Flow)
This diagram illustrates the "Forced Tunneling" path. The workload has no direct internet access; all traffic must pass through the Firewall policy engine[cite: 1, 2, 5].
```text
[ Internet / External Services ]
          ▲ (Blocked: [http://example.com](http://example.com))
          │ (Allowed: *.microsoft.com)
  ┌───────┴─────────────────────────────────────────┐
  │ [ afwp-dev-uksouth ] (Firewall Policy Engine)   │[cite: 5]
  │   ├── Network Rules: Allow DNS (8.8.8.8)        │[cite: 5]
  │   └── Application Rules: Allow Azure APIs       │[cite: 5]
  └───────▲─────────────────────────────────────────┘
          │
 [ afw-dev-uksouth-01 ] (Azure Firewall in Hub)[cite: 5]
          ▲
          │ (Diagnostic Logs ──> Log Analytics Workspace)[cite: 5]
          │
[ UDR: 0.0.0.0/0 -> Firewall Private IP ][cite: 5]
          ▲
          │
[ vm-dev-client-01 ] (Private Workload in Spoke)[cite: 5]
```
### 3. Recruiter Hook
"Deployed Azure Firewall as the central security appliance for the Hub-Spoke architecture. Enforced Zero Trust egress by utilizing Firewall Policies for application and network rule collections, and integrated diagnostic logging into Azure Monitor to ensure 100% visibility of blocked traffic streams[cite: 1, 5]."  

### 4. FinOps / Cost Notice
Azure Firewall is a premium resource (~$1.20/hour). This phase operates on an ephemeral deployment model. The firewall is provisioned via Terraform to generate KQL evidence and is destroyed immediately after validation to strictly protect the lab budget.

---

## Phase 7: Cloud Security Posture Management (CSPM)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Security Blind Spots:** Without continuous assessment, cloud environments drift out of compliance, and vulnerabilities remain undiscovered until exploited. |
| **Technical Solution** | **Proactive Posture Management:** Utilizing **Terraform** to enable Microsoft Defender for Cloud, establishing a baseline Secure Score and deploying Cloud Workload Protection (CWPP) for targeted assets. |
| **Acceptance Criteria** | 1. Free CSPM enabled at the subscription level via the `azurerm` provider. 2. Targeted Defender plan enabled via IaC. 3. Documented remediation of a high-priority security recommendation. |
| **Validation** | Track and verify a measurable increase in the Azure Secure Score after applying infrastructure remediations. |
| **Evidence** | `docs/release2/evidence/P7/`: Terraform apply output, before-and-after Secure Score screenshots, and validation of the remediated control. |

### 2. Operational Architecture (Continuous Assessment)
This diagram illustrates how Defender continuously scans the environment to prioritize security hygiene.
```text
[ Azure Infrastructure (Hub & Spoke VNets, VMs, Key Vault) ]
          │
          └── (Continuous Scanning) ──> [ Microsoft Defender for Cloud ]
                                                 ├── [ Free CSPM ] -> Generates Secure Score
                                                 └── [ CWPP Plans ] -> Deep Workload Protection
                                                          │
                                                          └── (Action) ──> [ Apply Remediation ]
                                                                                  │
                                                                                  ▼
                                                                     [ Improved Security Posture ]
```
### 3. Recruiter Hook
"Implemented Microsoft Defender for Cloud to establish continuous Cloud Security Posture Management (CSPM)[cite: 1]. Demonstrated the ability to assess, prioritize, and remediate cloud vulnerabilities, resulting in a measurable improvement to the environment's Secure Score[cite: 1, 5]."

### 4. FinOps Notice
Premium Defender plans (CWPP) will be enabled only during the validation window and immediately disabled to preserve the lab budget[cite: 1, 5].

---

## Phase 8: Microsoft Sentinel (Cloud-Native SIEM)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Decentralized Logs & Alert Fatigue:** Raw logs stored in Log Analytics are difficult to parse manually. Without a SIEM, security teams cannot correlate events or detect sophisticated attacks. |
| **Technical Solution** | **Detection-as-Code:** Deploying **Microsoft Sentinel** via **Terraform** to ingest centralized logs, and utilizing KQL Analytic Rules to generate high-fidelity security incidents. |
| **Acceptance Criteria** | 1. Sentinel onboarded to the core Log Analytics workspace via IaC. 2. Azure Activity data connector active. 3. Custom analytic rule deployed to detect anomalies (e.g., failed sign-ins). |
| **Validation** | Simulate a security event (e.g., brute-force login attempt) and verify that Sentinel successfully correlates the logs and triggers an actionable Incident in the dashboard. |
| **Evidence** | `docs/release2/evidence/P8/`: Terraform apply outputs, data connector status, KQL rule configuration, and a screenshot of the generated Sentinel Incident. |

### 2. Operational Architecture (Threat Detection Flow)
This diagram illustrates the aggregation of logs into the central SIEM for active threat hunting and alerting.
```text
[ Firewall Logs ]     [ Azure Activity Logs ]     [ Defender Alerts ]
       │                        │                         │
       └──────────────┬─────────┴─────────┬───────────────┘
                      ▼                   ▼
               [ Log Analytics Workspace (la-dev-platform) ]
                                │
                                ▼
                  [ Microsoft Sentinel (SIEM) ]
                                ├── (Ingest: Azure Activity Connector)
                                └── (Evaluate: KQL Analytic Rules)
                                │             (e.g., >5 failed logins)
                                ▼
                       [ Security Incident ] -> (Triggers SOC Response)
```
### 3. Recruiter Hook
"Architected a cloud-native Security Operations Center (SOC) using Microsoft Sentinel[cite: 1]. Integrated centralized log ingestion and authored custom KQL analytic rules to correlate events, automate threat detection, and generate actionable security incidents[cite: 1, 5]."

---

## Phase 9a: Azure Monitor & Alerts (Observability)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Silent Failures:** Without proactive alerting, the business only knows a server is down or degraded when users start complaining, leading to unacceptable downtime. |
| **Technical Solution** | **Observability-as-Code:** Deploying **Azure Monitor**, **Data Collection Rules (DCRs)**, and **Action Groups** via **Terraform** to establish automated alerting for critical infrastructure thresholds. |
| **Acceptance Criteria** | 1. Action Group (email notification) created via IaC. 2. Metric Alert Rule deployed via IaC targeting the Spoke VM. 3. DCR configured and associated with the workload to route metrics. |
| **Validation** | Execute a CPU stress test script on the Spoke VM. Verify that the threshold is breached and an automated alert email is successfully delivered. |
| **Evidence** | `docs/release2/evidence/P9a/`: Terraform apply outputs, alert configuration screenshots in the portal, and a screenshot of the received email alert. |

### 2. Operational Architecture (Proactive Alerting)
This diagram illustrates the automated observability flow from the workload agent to the administrator's inbox.
```text
[ Spoke VM (vm-dev-client-01) ]
          │
          └── (Azure Monitor Agent via DCR) ──> [ Azure Monitor ]
                                                       │
                                                       └── (Rule: CPU > 85%) ──> [ Action Group: Email Admin ]

```

### 3. Recruiter Hook
"Engineered comprehensive observability using Azure Monitor & Action Groups deployed entirely via Terraform. Demonstrated 'Day 2' operational maturity by establishing automated, proactive alerting to prevent silent infrastructure failures and reduce Mean Time to Detect (MTTD)."

---
## Phase 9b: Disaster Recovery & BCDR (Resilience-as-Code)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Insider Threats & Ransomware:** Standard backup vaults are vulnerable to compromised highly-privileged accounts (e.g., Global Admins) who can disable security features and maliciously wipe recovery data. |
| **Technical Solution** | **Zero Trust BCDR:** Deploying Recovery Services Vaults (RSV) via **Terraform**. Enforcing **Vault Immutability** and implementing **Multi-User Authorization (MUA)** via an Azure Resource Guard to ensure no single administrator can permanently destroy backups. |
| **Acceptance Criteria** | 1. RSV and Backup Policy created via IaC. 2. Spoke VM associated with the backup policy. 3. Resource Guard deployed and linked to the RSV to enforce MUA for critical operations. 4. Documented BCDR plan outlining RPO/RTO. |
| **Validation** | Attempt to disable Soft Delete or delete a backup item using the primary admin account; verify the action is blocked by the Resource Guard MUA policy. Execute a successful ASR test failover. |
| **Evidence** | `docs/release2/evidence/P9b/`: Terraform apply outputs, portal screenshots of the blocked deletion attempt (MUA enforcement), ASR replication health, and the completed DR plan document. |

### 2. Operational Architecture (Zero Trust Resilience)
This diagram illustrates the tamper-proof backup architecture, separating backup execution from deletion authority.

    [ Spoke VM (vm-dev-client-01) ]
              │
              └── (Automated Backup) ──> [ Recovery Services Vault ]
                                                  ├── Policy: Daily, Retain 30 Days
                                                  ├── Security: Soft Delete (14 Days) + Immutability
                                                  │
                                                  └── (MUA Enforcement)
                                                            ▲
                                                            │ (Blocks critical operations without secondary approval)
                                                            ▼
                                                 [ Azure Resource Guard ] (Isolated Security Context)

### 3. Recruiter Hook
"Engineered a Zero Trust Business Continuity and Disaster Recovery (BCDR) architecture utilizing **Azure Backup** and **Azure Site Recovery (ASR)**. Implemented 'Resilience-as-Code' via Terraform, enforcing Vault Immutability and **Multi-User Authorization (MUA) via Azure Resource Guard** to establish a ransomware-proof recovery baseline aligned with Microsoft Cybersecurity Architect (SC-100) standards."

## Phase 9c: Platform Handover & FinOps Teardown

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Knowledge Silos & Cloud Waste:** Undocumented platforms mean only the original author can maintain the system. Leaving unused infrastructure running generates massive, unnecessary cloud consumption costs. |
| **Technical Solution** | **DevEx & FinOps Lifecycle:** Authoring enterprise-grade Developer Experience (DevEx) documentation (`onboarding.md`, `CONTRIBUTING.md`)[cite: 1]. Executing a strict FinOps teardown via Terraform to validate state cleanliness and enforce a $0 run-rate. |
| **Acceptance Criteria** | 1. `docs/onboarding.md` details the PR, OIDC, and deployment workflow[cite: 1]. 2. `CONTRIBUTING.md` enforces branch strategies and naming conventions[cite: 1, 6]. 3. `terraform destroy` completes successfully without orphaned resources. |
| **Validation** | Another engineer can clone the repo and deploy the environment from scratch within 60 minutes. Azure Cost Analysis projects $0 in ongoing compute charges. |
| **Evidence** | `docs/release2/evidence/P9c/`: Committed documentation files[cite: 1], and a terminal output screenshot of a successful, error-free `terraform destroy` execution. |

### 2. Operational Architecture (The Lifecycle Loop)
This diagram illustrates the complete infrastructure lifecycle, ensuring the platform is both maintainable by the team and financially responsible.

    [ GitHub Repository ]
          │
          ├── (1. DevEx) ──> [ onboarding.md & CONTRIBUTING.md ] -> (Team scales autonomously)
          │
          └── (2. FinOps) ──> [ terraform destroy ] -> (State lock clears, Azure bills drop to $0)
                                      │
                                      ▼
                           [ Clean Azure Environment ]

### 3. Recruiter Hook
"Concluded the platform lifecycle by prioritizing Developer Experience (DevEx) and FinOps. Authored comprehensive onboarding and contribution governance documentation to eliminate knowledge silos, and executed an automated infrastructure teardown to validate state cleanliness and enforce strict cost-control measures."

---

## Phase O1: Multi-Vendor Security (FortiGate NVA)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Vendor Lock-in & Advanced Threat Protection:** Enterprises often require third-party Next-Generation Firewalls (NGFW) like FortiGate for unified threat management (UTM) and deep packet inspection across hybrid environments[cite: 3]. |
| **Technical Solution** | **NVA Deployment & Advanced Routing:** Deploying a FortiGate Network Virtual Appliance (NVA) from the Azure Marketplace via Terraform[cite: 3]. Updating User Defined Routes (UDRs) to steer specific Spoke traffic through the NVA for inspection. |
| **Acceptance Criteria** | 1. FortiGate VM deployed in a dedicated subnet. 2. UDR configured with the NVA's private IP as the Next Hop. 3. Firewall policies configured via the FortiOS management interface. |
| **Validation** | Verify traffic from the workload spoke is successfully routed through and inspected by the FortiGate NVA before reaching the internet or other spokes. |
| **Evidence** | `docs/release2/evidence/O1/`: Terraform apply outputs, effective route table showing the NVA Next Hop, and FortiOS traffic logs. |

### 2. Operational Architecture (NVA Routing)
This diagram illustrates how User Defined Routes (UDRs) are manipulated to force traffic through a third-party appliance.

    [ Spoke VM ]
          │
          └── (UDR: 0.0.0.0/0 -> NVA IP) ──> [ FortiGate NVA (Hub VNet) ]
                                                     ├── (FortiOS Inspection)
                                                     └── (Outbound to Internet)

### 3. Recruiter Hook
"Demonstrated multi-vendor network security expertise by deploying a **FortiGate Network Virtual Appliance (NVA)**. Configured advanced User Defined Routes (UDRs) to establish a custom traffic inspection path, proving the ability to integrate third-party Next-Gen Firewalls into an Azure Hub-Spoke architecture[cite: 3]."

### 4. FinOps Notice
The FortiGate appliance utilizes a 30-day free trial or BYOL (Bring Your Own License) model[cite: 3]. The underlying compute VM will be deployed ephemerally and destroyed post-validation to prevent continuous hourly charges.

---

## Phase O2: Hybrid Cloud Management (Azure Arc)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Operational Silos:** Managing on-premises servers separately from cloud infrastructure creates blind spots, inconsistent security policies, and fragmented monitoring[cite: 3]. |
| **Technical Solution** | **Unified Hybrid Governance:** Deploying the **Azure Arc** connected machine agent to local Hyper-V virtual machines[cite: 3]. Projecting on-premises infrastructure into Azure Resource Manager (ARM) to centralize governance, policy enforcement, and logging. |
| **Acceptance Criteria** | 1. Azure Arc agent installed on a local Hyper-V VM. 2. The local VM appears as a "Connected Machine" in the Azure Portal[cite: 3]. 3. An Azure Policy (e.g., tag enforcement) is successfully applied to the on-premises server. |
| **Validation** | Run `az connectedmachine list` in the Azure CLI to verify the Hyper-V VM is communicating with Azure ARM[cite: 3]. Verify Defender for Cloud assessments are evaluating the local server[cite: 3]. |
| **Evidence** | `docs/release2/evidence/O2/`: CLI output of connected machines, and portal screenshots showing Azure Policy applied to the Hyper-V resource[cite: 3]. |

### 2. Operational Architecture (Hybrid Projection)
This diagram illustrates how on-premises hardware is logically projected into the Azure control plane.

    [ Local Hyper-V Lab ]                          [ Azure Resource Manager (ARM) ]
            │                                                 ▲
            ├── [ DC1 (Windows Server) ]                      │
            │          └── (Azure Arc Agent) ─────────────────┤ (Projects Resource)
            │                                                 │
            └── [ App1 (Linux) ]                              │
                       └── (Azure Arc Agent) ─────────────────┘
                                                              │
                                                              ├── (Enforces) <- [ Azure Policy ]
                                                              └── (Monitors) <- [ Defender & Sentinel ]

### 3. Recruiter Hook
"Architected a unified hybrid-cloud management plane utilizing **Azure Arc**. Successfully projected on-premises Hyper-V virtual machines into Azure Resource Manager (ARM), enabling centralized governance, consistent policy enforcement, and unified security monitoring across physical and cloud boundaries[cite: 3]."

---

## Phase O3a: Dynamic Routing Foundation (Azure to On-Prem HQ)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Routing Overhead:** Relying on static routes for hybrid connectivity does not scale. Manual route table updates cause administrative overhead and increase the risk of routing loops or outages. |
| **Technical Solution** | **Dynamic Route Exchange:** Enabling **BGP (Border Gateway Protocol)** on the Azure VPN Gateway and establishing a BGP peering session with the simulated on-premises HQ router (Hyper-V RRAS). |
| **Acceptance Criteria** | 1. Azure VPN Gateway deployed with BGP enabled (ASN: 65515). 2. Local Network Gateway deployed reflecting the Hyper-V router (ASN: 65001). 3. IPSec Site-to-Site tunnel established and routing natively. |
| **Validation** | Execute `az network vnet-gateway list-bgp-peer-status` to verify the Hyper-V peer state is "Connected". Verify effective routes on a Spoke VM show the HQ subnets learned dynamically. |
| **Evidence** | `docs/release2/evidence/O3a/`: CLI output of the BGP peer status, and portal screenshots of the dynamically learned effective routes. |

### 2. Operational Architecture (HQ Peering)
This diagram illustrates the foundational BGP peering relationship to the simulated HQ.

    [ Azure VPN Gateway (Hub VNet) ]
    (ASN: 65515)
          │
          ├── (IPSec Tunnel + BGP Session)
          │
    [ On-Premises Router (Hyper-V RRAS) ]
    (ASN: 65001 | Subnet: 192.168.1.0/24)

### 3. Recruiter Hook
"Architected a scalable hybrid networking topology by configuring **BGP (Border Gateway Protocol)** over an IPSec Site-to-Site VPN. Eliminated static routing overhead by establishing automated, dynamic route propagation between Azure and a simulated legacy data center."

---

## Phase O3b: Multi-Cloud Foundation (AWS Infrastructure & Peering)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Cloud Expansion & Configuration Drift:** Expanding into AWS requires standardizing infrastructure deployment. Manually configuring AWS networking while automating Azure leads to configuration drift and operational blind spots. |
| **Technical Solution** | **Multi-Provider IaC:** Utilizing Terraform with **both** the `hashicorp/azurerm` and `hashicorp/aws` providers simultaneously. Deploying the AWS Branch infrastructure (VPC, Subnet, Route Table, EC2 Instance, Virtual Private Gateway) alongside the Azure Local Network Gateway to establish the BGP-enabled IPSec tunnel. |
| **Acceptance Criteria** | 1. AWS VPC (172.16.0.0/16) and test EC2 instance deployed via Terraform. 2. AWS Virtual Private Gateway (VGW) and Customer Gateway (CGW) configured for BGP (ASN: 65002). 3. Azure Local Network Gateway deployed reflecting the AWS IP. 4. IPSec tunnel established between both clouds. |
| **Validation** | Execute `az network vnet-gateway list-bgp-peer-status` to verify the AWS peer state is "Connected". Connect to the AWS EC2 instance (via SSM or SSH) and successfully ping the private IP of an Azure Spoke VM. |
| **Evidence** | `docs/release2/evidence/O3b/`: Terraform apply output showing both Azure and AWS resource creation, CLI output of the BGP peer status, and a screenshot of the successful ping from the EC2 terminal. |

### 2. Operational Architecture (Dual-Provider Deployment)
This diagram illustrates the explicit infrastructure deployed across both cloud providers via a single Terraform state.

    [ Azure (Terraform 'azurerm' provider) ]        [ AWS (Terraform 'aws' provider) ]
                                                            
    [ Hub VNet ]                                    [ Branch VPC: 172.16.0.0/16 ]
         │                                               │
         ├── [ Local Network Gateway ]                   ├── [ Customer Gateway (Azure IP) ]
         │                                               │
         └── [ Azure VPN Gateway ] <──(IPSec + BGP)──> [ AWS Virtual Private Gateway (VGW) ]
               (ASN: 65515)                                  (ASN: 65002)
                                                                 │
                                                                 └── [ EC2 Instance (Test Workload) ]

### 3. Recruiter Hook
"Expanded hybrid infrastructure into a true Multi-Cloud architecture using a **Dual-Provider Terraform strategy**. Simultaneously provisioned AWS infrastructure (VPC, EC2, VGW) and Azure networking to establish a secure, BGP-routed IPSec Site-to-Site VPN, proving advanced cross-cloud orchestration capabilities."

---

## Phase O3c: Multi-Cloud Transit Routing (HQ to AWS via Azure)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Transitive Complexity:** Establishing direct, full-mesh connectivity between all physical sites and all cloud providers is cost-prohibitive and administratively impossible to maintain. |
| **Technical Solution** | **Transitive BGP Hub:** Positioning Azure as the central transit hub. Leveraging the active BGP sessions from O3a and O3b to allow Azure to automatically propagate the Hyper-V routes to AWS, and the AWS routes to Hyper-V. |
| **Acceptance Criteria** | 1. BGP Transit routing successfully advertises across all three environments. 2. No direct physical link exists between Hyper-V and AWS; all traffic must flow through the Azure VPN Gateway. |
| **Validation** | From a local Hyper-V VM (HQ), successfully ping the private IP of an AWS EC2 instance (Branch). Run a `tracert` (Trace Route) to prove the traffic is physically hopping through the Azure Virtual Network backbone. |
| **Evidence** | `docs/release2/evidence/O3c/`: A terminal screenshot showing a successful `tracert` from Hyper-V to AWS, explicitly displaying the Azure VPN Gateway IP as the intermediate hop. |

### 2. Operational Architecture (Transitive Hub)
This diagram illustrates Azure actively routing traffic between the legacy physical network and the secondary cloud provider.

                          [ Azure VPN Gateway (Hub VNet) ]
                          (Transit Hub | ASN: 65515)
                                    │
               ┌────────────────────┴────────────────────┐
               │                                         │ 
               ▼                                         ▼
    [ Hyper-V RRAS (Corp HQ) ]                [ AWS VPN Gateway (Branch) ]
         (ASN: 65001)                                (ASN: 65002)
               │                                         │
               └─────── (Traffic flows via Azure) ───────┘

### 3. Recruiter Hook
"Engineered a highly advanced Multi-Cloud transit network using **BGP Transitive Routing**. Positioned Azure Virtual WAN/VPN Gateway as the central transit hub, enabling seamless, dynamic communication between a simulated legacy on-premises HQ and an AWS branch office without requiring direct peer-to-peer links."

---

