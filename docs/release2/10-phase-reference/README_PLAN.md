# Phase 0: Foundation & Automation Bootstrap

## 1. Overview

> **Implementation alignment note:** Region and VM size were treated as a subscription-and-region validation task rather than static assumptions. Because Azure SKU availability and restrictions vary over time by subscription, region, and capacity, deployable options were validated first and the implementation was then aligned to the confirmed target: `norwayeast` and `Standard_B2als_v2`.
Before deploying infrastructure, Phase 0 establishes the "Identity and Automation Plumbing." This phase follows the "Secretless" security principle by using **OpenID Connect (OIDC)** for GitHub Actions, ensuring no long-lived secrets are stored in the repository[cite: 2, 4].

| Aspect | Detail |
| :--- | :--- |
| **Business Problem** | Manual deployments are unauditable; static secrets (passwords) expire and create security vulnerabilities. |
| **Technical Solution** | Bootstrap an Azure Landing Zone with **OIDC Workload Identity Federation** and a remote **Terraform Backend** with state locking[cite: 2, 4, 6]. |
| **Standard Naming** | `[resource]-[service]-[env]-[region]` (e.g., `rg-dev-terraformstate-norwayeast`)[cite: 5]. |

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
*   **State Storage:** Deploy `rg-dev-terraformstate-norwayeast` and a globally unique storage account (e.g., `stdevtfstatene01`)[cite: 4].
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
| **Technical Solution** | **CAF-Aligned Management Groups:** Deploying a `Root > Platform & Landing Zones` hierarchy using **Terraform**. Implementing **Policy-as-Code** (Azure Policy) to enforce "Foundational Guardrails" (Allowed region and VM SKU set finalized after subscription-level deployability validation). |
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
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-azawslab-prod-global] (Enforced Guardrails)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-platform-prod-global]
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [sub-connectivity-prod] (Hub VNet, Firewall, VPN)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [sub-identity-prod]     (Entra ID, Key Vault)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [sub-management-prod]   (Log Analytics, Sentinel)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-landingzones-prod-global]
                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-corp-prod-global]
                        ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [sub-workload-prod] (Production Applications)
```
### Lab Implementation Diagram (Budget-Optimized)
Following the naming standard: `[resource]-[service]-[env]-[region]`.
```text
[Tenant Root Group]
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-azawslab-prod-global] (Policy: finalized implementation region and validated SKU set only)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [sub-azaws-enterprise-prod] (Upgraded Free Trial Sub)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [rg-connectivity-prod-norwayeast] (Simulated Platform Hub)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [rg-dev-workload-norwayeast]         (Simulated Workload Spoke)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [rg-identity-prod-norwayeast]     (Simulated Shared Identity)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-platform-prod-global]      (Empty - Logical Placeholder)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-landingzones-prod-global] (Empty - Logical Placeholder)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [mg-sandbox-prod-global]      (Empty - Logical Placeholder)

```
---

## Phase 2a: Terraform ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã¢â'¬Å" Reusable Modules (The Modular Engine)

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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (01) Calls ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ modules/security ]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Deploy: kv-dev-platform-001[cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Logic: Generate Random Password -> Store in KV[cite: 6]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (02) Calls ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ modules/networking ]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Deploy: vnet-dev-norwayeast-hub[cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Logic: Hub-Spoke Peering & Subnets[cite: 5, 6]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (03) Calls ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ modules/compute ]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Deploy: vm-dev-client-01[cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Logic: NIC-only (No Public IP) + Get Password from KV[cite: 2, 6]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (04) Calls ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ modules/monitoring ]
                               ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Deploy: la-dev-platform[cite: 5]
                               ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Logic: Central Log Analytics Workspace[cite: 5]
```
### 3. Recruiter Hook
"Built a library of reusable Terraform modules following the 'DRY' principle[cite: 1]. Integrated Azure Key Vault for dynamic secret management and implemented resource lifecycle protection, demonstrating a production-grade approach to automated infrastructure lifecycle management[cite: 6].

---

## Phase 2b: Ansible Configuration Management (The Fleet Orchestrator)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Manual Configuration Debt:** Deployed VMs are "naked" and vulnerable[cite: 1]. Manual setup is slow, inconsistent, and lacks a "Source of Truth"[cite: 6]. |
| **Technical Solution** | **Role-Based Fleet Orchestration:** Utilizing Ansible roles for modular configuration management[cite: 6]. Connectivity is maintained via **an Azure-connected Linux management host over private WinRM** to satisfy private-only networking[cite: 2, 6]. |
| **Acceptance Criteria** | 1. `ansible-lint` passes for all roles (`common`, `ad-join`, `webserver`)[cite: 6]. 2. Private-only Windows VMs are reachable from the Azure-connected management host over WinRM for Ansible-based administration[cite: 2, 6]. 3. Credentials managed via **Ansible Vault**[cite: 1]. 4. Execution of the `ad-join` role is deferred until `hq.azawslab.co.uk` and the required hybrid connectivity path are ready. |
| **Validation** | Successful execution of `site.yml` (Master Playbook) showing `changed=0` on re-run (Idempotency) for currently in-scope roles. Domain join validation is deferred until `hq.azawslab.co.uk` and hybrid connectivity are ready. |
| **Evidence** | `docs/release2/evidence/P2b/`: Terminal outputs of role execution, Active Directory "Computer Object" screenshots, and security baseline verification[cite: 1, 5]. |

### P2b Management Path Principle

For Phase P2b, configuration management is executed from a separate Azure-connected management host in the **same Azure subscription**.

This management host is treated as an **operations-plane resource**, not as part of the workload tier.

#### Design intent
- the workload VM remains **private-only**
- Ansible is not run from a general local laptop path for production-style configuration
- the management host provides a controlled internal execution path for Ansible-based administration
- separation is maintained by **role, network path, and lifecycle**, rather than by using a separate subscription

#### Boundary model
- **Governance plane**
  policy assignments and guardrails
- **Shared security plane**
  Key Vault, secret flow, and shared security resources
- **Workload plane**
  application/workload networking and compute
- **Management plane for P2b**
  temporary Azure-connected host used to run Ansible against private targets

#### Operational rule
The P2b management host:
- exists only to support controlled configuration management
- is not part of the business/application workload
- should be kept minimal
- should be deallocated or destroyed after P2b validation unless explicitly needed by the next dependent phase

#### Rationale
This approach preserves the private-only workload design while keeping the management path realistic for an enterprise-style environment. It avoids unnecessary subscription sprawl while still maintaining clear separation of concerns.

### 2. Operational Architecture

Ansible orchestrates configuration across the secure management boundary established in earlier foundation work.

```text
[Operator / Controlled Runner]
            |
            | GitHub Actions, CLI, or approved automation trigger
            v
[Azure-Connected Management Host]
            |
            | private management path
            | WinRM for Windows targets
            | SSH for Linux targets if used later
            v
[Private Azure Workload Network]
            |
            +---------------------------+---------------------------+
            |                           |                           |
            v                           v                           v
   [Role: Common]               [Role: AD-Join]              [Role: Web]
   - security baseline          - domain integration         - app / IIS delivery
   - base config                - OU / hostname tasks        - site / service config
   - common packages            - post-join validation       - deployment validation
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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (01) git push ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ GitHub Pull Request ]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (02) Trigger: CI Workflow
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ terraform fmt & validate
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ ansible-lint roles/[cite: 6]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ terraform plan[cite: 1]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (03) Outcome: Plan Comment on PR
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ "Plan: 5 to add, 0 to change"
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (04) Manual Review & Approval ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (05) Merge to 'release-2' ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Trigger: CD Workflow ]
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (06) OIDC Login (No Secrets)[cite: 4]
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (07) terraform apply -auto-approve[cite: 1]
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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Policy: Data Sovereignty ] ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> (Deny: All regions except UK South)[cite: 1, 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Policy: Cost Management ]  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> (Deny: All VM SKUs except B-Series)[cite: 1]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Policy: Mandatory Tags ]   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> (Deny: Missing Env/Project/Owner)[cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ sub-azaws-enterprise-prod ] (Simulated Corporate Subscription)
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ rg-dev-security-norwayeast ]
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ kv-dev-platform-001 ] ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> (Managed Secrets Lifecycle)[cite: 5, 6]
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ RBAC: azw-Security-Engineers (Reader)[cite: 5]
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ rg-dev-workload-norwayeast ]
                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ RBAC: sp-terraform-gh (Contributor)[cite: 4, 5]
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
             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                        ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ azw-Platform-Admins ]              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Customer Subscription ]
             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Customer Resources ]
             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Lighthouse Projection) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (HTTPS) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Azure Bastion ] (Subnet: AzureBastionSubnet)[cite: 5, 6]
                                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
  [ Local Hyper-V Lab ]          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (RDP/SSH over Private IP)[cite: 6]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          : (Future VPN)         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
          :               [ Hub VNet (10.0.0.0/16) ]
          V                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ AzureFirewallSubnet ] (Next-Hop Target)[cite: 5]
 [ GatewaySubnet ] <ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Mgmt Subnet ]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (VNet Peering)[cite: 5]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                 [ Spoke VNet: Workload (10.10.0.0/16) ]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ NSG: Inbound Allow from Bastion[cite: 5]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ UDR: 0.0.0.0/0 -> Azure Firewall IP[cite: 5]
                                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ vm-dev-client-01 ] (Private IP Only)[cite: 5, 6]
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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â² (Blocked: [http://example.com](http://example.com))
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (Allowed: *.microsoft.com)
  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ [ afwp-dev-norwayeast ] (Firewall Policy Engine)   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡[cite: 5]
  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Network Rules: Allow DNS (8.8.8.8)        ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡[cite: 5]
  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Application Rules: Allow Azure APIs       ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡[cite: 5]
  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
 [ afw-dev-norwayeast-01 ] (Azure Firewall in Hub)[cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (Diagnostic Logs ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> Log Analytics Workspace)[cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
[ UDR: 0.0.0.0/0 -> Firewall Private IP ][cite: 5]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Continuous Scanning) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Microsoft Defender for Cloud ]
                                                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ Free CSPM ] -> Generates Secure Score
                                                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ CWPP Plans ] -> Deep Workload Protection
                                                          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                                          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Action) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Apply Remediation ]
                                                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
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
       ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                        ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
       ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
               [ Log Analytics Workspace (la-dev-platform) ]
                                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
                  [ Microsoft Sentinel (SIEM) ]
                                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Ingest: Azure Activity Connector)
                                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Evaluate: KQL Analytic Rules)
                                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡             (e.g., >5 failed logins)
                                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
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
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Azure Monitor Agent via DCR) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Azure Monitor ]
                                                       ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                                       ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Rule: CPU > 85%) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Action Group: Email Admin ]

```

### 3. Recruiter Hook
"Engineered comprehensive observability using Azure Monitor & Action Groups deployed entirely via Terraform. Demonstrated 'Day 2' operational maturity by establishing automated, proactive alerting to prevent silent infrastructure failures and reduce Mean Time to Detect (MTTD)."

---
## Phase 9b: Disaster Recovery & BCDR (Resilience-as-Code)

### 1. Refined Phase Detail
| Aspect | Refined Detail  |
| :--- | :--- |
| **Business Problem** | **Insider Threats & Ransomware:** Standard backup vaults are vulnerable to compromised highly-privileged accounts (e.g., Global Admins) who can disable security features and maliciously wipe recovery data. |
| **Technical Solution** | **Zero Trust BCDR:** Deploying Recovery Services Vaults (RSV) via **Terraform**. Enforcing **Vault Immutability** and implementing **Multi-User Authorization (MUA)** via an Azure Resource Guard to ensure no single administrator can permanently destroy backups. |
| **Acceptance Criteria** | 1. RSV and Backup Policy created via IaC. 2. Spoke VM associated with the backup policy. 3. Resource Guard deployed and linked to the RSV to enforce MUA for critical operations. 4. Documented BCDR plan outlining RPO/RTO. |
| **Validation** | Attempt to disable Soft Delete or delete a backup item using the primary admin account; verify the action is blocked by the Resource Guard MUA policy. Execute a successful ASR test failover. |
| **Evidence** | `docs/release2/evidence/P9b/`: Terraform apply outputs, portal screenshots of the blocked deletion attempt (MUA enforcement), ASR replication health, and the completed DR plan document. |

### 2. Operational Architecture (Zero Trust Resilience)
This diagram illustrates the tamper-proof backup architecture, separating backup execution from deletion authority.

    [ Spoke VM (vm-dev-client-01) ]
              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Automated Backup) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Recovery Services Vault ]
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Policy: Daily, Retain 30 Days
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ Security: Soft Delete (14 Days) + Immutability
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                                  ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (MUA Enforcement)
                                                            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
                                                            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (Blocks critical operations without secondary approval)
                                                            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
                                                 [ Azure Resource Guard ] (Isolated Security Context)

### 3. Recruiter Hook
"Engineered a Zero Trust Business Continuity and Disaster Recovery (BCDR) architecture utilizing **Azure Backup** and **Azure Site Recovery (ASR)**. Implemented 'Resilience-as-Code' via Terraform, enforcing Vault Immutability and **Multi-User Authorization (MUA) via Azure Resource Guard** to establish a ransomware-proof recovery baseline aligned with Microsoft Cybersecurity Architect (SC-100) standards."

## Phase 9c: Platform Handover & FinOps Teardown

### 1. Refined Phase Detail
| Aspect | Refined Detail () |
| :--- | :--- |
| **Business Problem** | **Knowledge Silos & Cloud Waste:** Undocumented platforms mean only the original author can maintain the system. Leaving unused infrastructure running generates massive, unnecessary cloud consumption costs. |
| **Technical Solution** | **DevEx & FinOps Lifecycle:** Authoring enterprise-grade Developer Experience (DevEx) documentation (`onboarding.md`, `CONTRIBUTING.md`)[cite: 1]. Executing a strict FinOps teardown via Terraform to validate state cleanliness and enforce a $0 run-rate. |
| **Acceptance Criteria** | 1. `docs/onboarding.md` details the PR, OIDC, and deployment workflow[cite: 1]. 2. `CONTRIBUTING.md` enforces branch strategies and naming conventions[cite: 1, 6]. 3. `terraform destroy` completes successfully without orphaned resources. |
| **Validation** | Another engineer can clone the repo and deploy the environment from scratch within 60 minutes. Azure Cost Analysis projects $0 in ongoing compute charges. |
| **Evidence** | `docs/release2/evidence/P9c/`: Committed documentation files[cite: 1], and a terminal output screenshot of a successful, error-free `terraform destroy` execution. |

### 2. Operational Architecture (The Lifecycle Loop)
This diagram illustrates the complete infrastructure lifecycle, ensuring the platform is both maintainable by the team and financially responsible.

    [ GitHub Repository ]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (1. DevEx) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ onboarding.md & CONTRIBUTING.md ] -> (Team scales autonomously)
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (2. FinOps) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ terraform destroy ] -> (State lock clears, Azure bills drop to $0)
                                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
                           [ Clean Azure Environment ]

### 3. Recruiter Hook
"Concluded the platform lifecycle by prioritizing Developer Experience (DevEx) and FinOps. Authored comprehensive onboarding and contribution governance documentation to eliminate knowledge silos, and executed an automated infrastructure teardown to validate state cleanliness and enforce strict cost-control measures."

---

## Phase O1: Integrated Security Hub (Defense-in-Depth)

### 1. Refined Phase Detail
| Aspect | Refined Detail () |
| :--- | :--- |
| **Business Problem** | **Security Tool Proliferation & Inefficiency:** Using a single firewall for all traffic types often leads to "policy bloat" and performance bottlenecks. Native firewalls lack deep multi-cloud BGP support, while NVAs can be complex for simple cloud-native internet egress. |
| **Technical Solution** | **Parallel Security Architecture:** Implementing functional traffic separation. **1. Azure Firewall** handles all Internet Egress (0.0.0.0/0) using FQDN tags for Microsoft services. **2. FortiGate NVA** handles all East-West (Spoke-to-Spoke) and Hybrid (AWS/HQ) traffic, acting as the BGP routing engine. |
| **Acceptance Criteria** | 1. UDR on Spokes configured to route `0.0.0.0/0` to the Azure Firewall private IP. 2. UDR on Spokes configured to route `10.0.0.0/8` (Internal) to the FortiGate NVA IP. 3. Multi-vendor BGP peering established on the NVA. |
| **Validation** | From a Spoke VM: `curl google.com` is verified in Azure Firewall logs. `ping [AWS_VM_IP]` is verified as inspected and logged within the FortiGate FortiOS monitor. |
| **Evidence** | `docs/release2/evidence/O1/`: Terraform outputs for both security resources, comparative log exports showing the traffic split, and the effective route table showing dual Next Hops based on destination. |

### 2. Operational Architecture (Functional Traffic Separation)
This architecture utilizes User Defined Routes (UDRs) to steer traffic to the appliance best suited for the destination.

                           [ Public Internet ]
                                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
                                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (Egress Traffic)
                          [ Azure Firewall ]
                                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
      [ Spoke VNet ] ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(UDRs)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Hub VNet ]
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
                                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
                          [ FortiGate NVA ]
                                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
                                   ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (Hybrid / East-West Traffic)
                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
             [ AWS Branch ]                [ Hyper-V HQ ]

###  3. Detailed Resource Mapping
To implement this via Terraform, we need these specific resources:

Azure Firewall: azurerm_firewall + azurerm_firewall_policy.

Rule: Allow HTTPS to *.microsoft.com (FQDN Tag).

FortiGate NVA: azurerm_linux_virtual_machine (Marketplace Image) + fortios_router_static.

Rule: Allow SMB/RDP from AWS (172.16.x.x) to Azure Spokes.

Spoke UDR Table: azurerm_route_table with two key routes:

Route A: 0.0.0.0/0 -> NextHop: VirtualAppliance -> IP: AzureFirewall_IP.

Route B: 10.0.0.0/8 -> NextHop: VirtualAppliance -> IP: FortiGate_IP.

### 4. Recruiter Hook
"Architected a high-performance Defense-in-Depth security model by implementing functional traffic separation. Utilized Azure Firewall for cloud-native internet egress and a FortiGate NVA for deep packet inspection of multi-cloud and hybrid traffic, proving my ability to integrate third-party appliances into a standard Azure Landing Zone architecture."

### 5. FinOps Notice
The FortiGate appliance utilizes a 30-day free trial or BYOL (Bring Your Own License) model[cite: 3]. The underlying compute VM will be deployed ephemerally and destroyed post-validation to prevent continuous hourly charges.

---

## Phase O2: Hybrid Cloud Management (Azure Arc)

### 1. Refined Phase Detail
| Aspect | Refined Detail () |
| :--- | :--- |
| **Business Problem** | **Operational Silos:** Managing on-premises servers separately from cloud infrastructure creates blind spots, inconsistent security policies, and fragmented monitoring[cite: 3]. |
| **Technical Solution** | **Unified Hybrid Governance:** Deploying the **Azure Arc** connected machine agent to local Hyper-V virtual machines[cite: 3]. Projecting on-premises infrastructure into Azure Resource Manager (ARM) to centralize governance, policy enforcement, and logging. |
| **Acceptance Criteria** | 1. Azure Arc agent installed on a local Hyper-V VM. 2. The local VM appears as a "Connected Machine" in the Azure Portal[cite: 3]. 3. An Azure Policy (e.g., tag enforcement) is successfully applied to the on-premises server. |
| **Validation** | Run `az connectedmachine list` in the Azure CLI to verify the Hyper-V VM is communicating with Azure ARM[cite: 3]. Verify Defender for Cloud assessments are evaluating the local server[cite: 3]. |
| **Evidence** | `docs/release2/evidence/O2/`: CLI output of connected machines, and portal screenshots showing Azure Policy applied to the Hyper-V resource[cite: 3]. |

### 2. Operational Architecture (Hybrid Projection)
This diagram illustrates how on-premises hardware is logically projected into the Azure control plane.

    [ Local Hyper-V Lab ]                          [ Azure Resource Manager (ARM) ]
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â²
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ DC1 (Windows Server) ]                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Azure Arc Agent) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¤ (Projects Resource)
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
            ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ [ App1 (Linux) ]                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                       ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Azure Arc Agent) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
                                                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                                                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Enforces) <- [ Azure Policy ]
                                                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Monitors) <- [ Defender & Sentinel ]

### 3. Recruiter Hook
"Architected a unified hybrid-cloud management plane utilizing **Azure Arc**. Successfully projected on-premises Hyper-V virtual machines into Azure Resource Manager (ARM), enabling centralized governance, consistent policy enforcement, and unified security monitoring across physical and cloud boundaries[cite: 3]."

---

## Phase O3a: Dynamic Routing Foundation (VyOS Edge Router)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Routing Convergence & Human Error:** Manual static route management in hybrid environments leads to "black-holed" traffic and slow failover. Enterprises require a self-healing network that automatically updates when on-premises subnets change. |
| **Technical Solution** | **Multi-Vendor BGP Integration:** Establishing a BGP-over-IPSec tunnel between the **Azure-based FortiGate NVA** and **VyOS** (open-source Linux NOS) running on Hyper-V. VyOS API is bootstrapped manually, then Terraform (community provider) automates IPSec and BGP configuration. |
| **IaC Implementation** | **Cross-Provider Automation:** `azurerm` (Azure networking), `fortios` (FortiGate NVA), and `vyos` (community provider for VyOS). |
| **Acceptance Criteria** | 1. IPSec tunnel status is "Up" on both FortiGate and VyOS. 2. BGP Peering state is "Established". 3. FortiGate routing table contains `192.168.1.0/24` learned via BGP. |
| **Validation** | From FortiGate CLI: `get router info bgp summary`. From VyOS: `show bgp summary`. Verify Spoke VM effective routes show `192.168.1.0/24` next-hop FortiGate. |
| **Evidence** | `docs/release2/evidence/O3a/`: Terraform config for VyOS, BGP summary outputs, effective route table screenshot. |

### 2. Operational Architecture (Dynamic Hybrid Link)
This diagram illustrates the BGP peering between FortiGate NVA (Azure) and VyOS (on-prem Hyper-V).
```text
[ Azure Hub VNet ]
(ASN: 65515)
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
[ FortiGate NVA ] <ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
(BGP Speaker)                        ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                     (BGP over IPSec Tunnel)
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
[ Azure Spoke VNets ]      [ VyOS on Hyper-V (HQ) ]
(Dynamic Routes)           (ASN: 65001 | Subnet: 192.168.1.0/24)
```

### 3. Step-by-Step Actions

#### 3.1 Deploy VyOS VM on Hyper-V
- Download VyOS rolling release `.iso` from official site.
- Create Gen2 VM (1 vCPU, 1 GB RAM, 8 GB disk) with two NICs:
  - **NIC1 (WAN):** Connected to NAT/Hyper-V switch, static IP `192.168.1.1/24`.
  - **NIC2 (LAN):** Connected to internal switch for on-prem VMs (no IP needed).
- Boot ISO, log in (user `vyos` / password `vyos`), run `install image`, reboot.

#### 3.2 Bootstrap VyOS API (manual one-time)
```bash
ssh vyos@192.168.1.1
configure
set service https api keys id tf-key key 'YourSuperSecretKey123!'
set service https api port 443
set service https certificates system-generated-certificate
commit
save
```

#### 3.3 Configure FortiGate IPSec tunnel (Terraform ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã¢â'¬Å" same as original)
> (Keep existing FortiGate IPSec configuration; ensure peer address points to VyOS public IP, e.g., `192.168.1.1`.)

#### 3.4 Configure VyOS via Terraform provider
Create `vyos-bgp.tf`:
```hcl
terraform {
  required_providers {
    vyos = {
      source = "Foltik/vyos"
      version = "~> 0.3.4"
    }
  }
}

provider "vyos" {
  url = "[https://192.168.1.1](https://192.168.1.1)"
  key = "YourSuperSecretKey123!"
  # For self-signed cert in lab, add: insecure = true
}

resource "vyos_protocols_bgp_neighbor" "azure_fortigate" {
  asn        = "65001"
  address    = "10.1.1.4"       # FortiGate trust IP in Azure
  remote_as  = "65515"
}

resource "vyos_protocols_bgp_address_family_ipv4_unicast_network" "on_prem_subnet" {
  asn     = "65001"
  network = "192.168.1.0/24"
}
```

#### 3.5 Validate
```bash
# On VyOS
show bgp summary
# Expected: neighbor 10.1.1.4 state Established

# On FortiGate CLI
get router info bgp summary
# Expected: neighbor 192.168.1.1 state Established
```

PHASE O3a: BGP OVER IPSEC (AZURE FORTIGATE ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'Â ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'Â VYOS ON-PREM)
===========================================================

[Azure Hub ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã¢â'¬Å" FortiGate NVA: vm-dev-fortigate-01]
   ASN: 65515
   BGP Router ID: 10.1.1.4
         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (IPSec tunnel ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã¢â'¬Å" IKEv2 / AES256)
         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ (BGP peering over tunnel)
         ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
[On-Premises Hyper-V ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã¢â'¬Å" VyOS VM]
   ASN: 65001
   BGP Router ID: 192.168.1.1
   Advertised routes: 192.168.1.0/24

Routes exchanged:
   FortiGate advertises: 10.0.0.0/8, 172.16.0.0/12
   VyOS advertises: 192.168.1.0/24

Spoke VM: vm-dev-client-01 (10.1.0.4)
   Effective route: 192.168.1.0/24 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'Â ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â'¬Å¾Ã'Â¢ NextHop: 10.1.1.4 (FortiGate)

Result: Azure workloads can reach on-prem servers via VyOS.

### 4. Recruiter Hook
"Replaced legacy Windows RRAS with VyOS (open-source Linux NOS) to simulate the on-premises edge. Bootstrapped the VyOS HTTP API manually, then orchestrated IPSec tunnel and BGP peering to Azure FortiGate entirely via Terraform, demonstrating multi-vendor infrastructure-as-code."
---

## Phase O3b: Multi-Cloud Foundation (AWS Cisco NVA & Segmented Peering)

### 1. Refined Phase Detail
| Aspect | Refined Detail () |
| :--- | :--- |
| **Business Problem** | **Granular Route Control:** Native cloud gateways often lack the ability to selectively advertise specific subnets (DMZ vs. Trusted) to different peers, leading to a broader attack surface and inefficient routing. |
| **Technical Solution** | **Multi-Vendor Transit Fabric:** Deploying a **Cisco Catalyst 8000V (NVA)** in the AWS Branch VPC via Terraform. Configuring a multi-interface "Zone" architecture to isolate **Trusted (172.16.1.0/24)** and **DMZ (172.16.2.0/24)** traffic, using BGP `network` statements to selectively project these segments into the Azure Hub. |
| **AWS Resources** | 1. **VPC:** 172.16.0.0/16. 2. **Cisco 8000V:** EC2 (t3.medium) with three ENIs (Mgmt, Untrusted/Public, Trusted/Private). 3. **Segmentation:** Dedicated DMZ and Trusted subnets with associated AWS Route Tables. |
| **IaC Strategy** | **Cross-Vendor Orchestration:** Utilizing the `aws` provider to provision infrastructure and the `ios-xe` or `shell-local` provider to automate the Cisco IOS-XE configuration. This is synchronized with the `fortios` provider to complete the Azure-side BGP handshake. |
| **Acceptance Criteria** | 1. Cisco 8000V status is "Up" and peering with Azure FortiGate (ASN 65515). 2. Azure FortiGate routing table shows distinct prefixes for the AWS DMZ and Trusted subnets. 3. AWS Route Tables point to the Cisco NVA ENI for all 10.x.x.x traffic. |
| **Validation** | From Cisco CLI: `show ip bgp summary`. From Azure Spoke VM: Verify `traceroute` reaches an AWS DMZ instance, showing the FortiGate and Cisco NVAs as the primary transit hops. |
| **Evidence** | `docs/release2/evidence/O3b/`: Terraform code for the Cisco deployment, Cisco `show ip route bgp` output, and the FortiGate routing table screenshot showing the segmented AWS prefixes. |

### 2. Operational Architecture (DMZ & Zone Segmentation)
This illustrates the internal segmentation of the AWS Branch and its dynamic advertisement to the Azure Hub.

    [ AWS Branch VPC ]                   [ Azure Hub VNet ]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â             [ FortiGate NVA ]
    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ Cisco Catalyst 8000V ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡ <ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(BGP)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> (ASN: 65515)
    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"                    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(Route: 172.16.2.0/24)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Azure Spokes ]
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                                     (Learns DMZ Route)
    [ DMZ Subnet ]
    (Web/Public Services)

### 3. Route Advertisement (Cisco IOS-XE Logic)
To simulate a real-world enterprise edge, the BGP configuration avoids "redistribute connected" and uses explicit network statements for precise prefix control:
```bash
router bgp 65002
 bgp log-neighbor-changes
 neighbor 10.0.0.5 remote-as 65515
 !
 address-family ipv4
  network 172.16.1.0 mask 255.255.255.0  # Advertise Trusted Segment
  network 172.16.2.0 mask 255.255.255.0  # Advertise DMZ Segment
  neighbor 10.0.0.5 activate
 exit-address-family
 ```

### 3. Recruiter Hook
"Engineered a secure multi-cloud bridge by architecting a segmented AWS VPC with dedicated DMZ and Trusted zones. Orchestrated a Cisco Catalyst 8000V using Terraform to perform granular BGP Route Advertisement, ensuring only authorized branch segments were visible to the Azure backbone while maintaining strict inspection at each cloud edge."

---

## Phase O3c: Multi-Cloud Transitive Routing (The Global Hub)

### 1. Refined Phase Detail
| Aspect | Refined Detail |
| :--- | :--- |
| **Business Problem** | **Mesh Connectivity Complexity:** Establishing direct VPN tunnels between every branch (Full Mesh) is expensive and unmanageable. Enterprises require a "Hub-and-Spoke" transit model where cloud hubs broker all cross-site communication. |
| **Technical Solution** | **Transitive BGP Propagation:** Configuring the **FortiGate NVA** to act as a Transit Router. This involves re-advertising BGP prefixes learned from the AWS Cisco NVA (172.16.x.x) to the On-Prem HQ (192.168.1.0/24) and vice-versa, allowing remote sites to communicate through the Azure backbone. |
| **Logic Implementation** | **BGP Route Re-distribution:** Modifying BGP neighbor settings on the FortiGate to allow "AS Path" propagation. Ensuring the Azure Hub is the "Source of Truth" for all inter-site traffic by manipulating BGP attributes via the `fortios` Terraform provider. |
| **Acceptance Criteria** | 1. AWS Cisco NVA learns the HQ subnet (192.168.1.0/24) via BGP. 2. HQ Router learns the AWS DMZ/Trusted subnets. 3. End-to-end ICMP reachability between AWS and On-Prem. |
| **Validation** | The "Golden Trace": Run `traceroute 192.168.1.10` from an AWS EC2 instance. The output must show the **FortiGate NVA Internal IP** as the transit hop, proving traffic is traversing the Azure Hub. |
| **Evidence** | `docs/release2/evidence/O3c/`: Traceroute logs proving transitive flow, and BGP routing table snapshots from AWS, Azure, and HQ showing a unified global routing table. |

### 2. Operational Architecture (Global Transit Hub)
This diagram illustrates how the Azure Hub brokers traffic between independent remote sites using dynamic BGP peering.

                          [ FortiGate NVA (Hub VNet) ]
                          (Transit Hub | ASN: 65515)
                                      ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                                           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
     [ Hyper-V RRAS (Corp HQ) ]               [ Cisco Catalyst 8000V (AWS) ]
           (ASN: 65001)                                (ASN: 65002)
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ (Traffic flows via Azure) ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"

### 3. Verification Logic (The Path of a Packet)
To prove the transitive nature of the hub, the documentation tracks a packet across the multi-vendor environment:
1. **Source:** AWS EC2 Instance (172.16.2.10).
2. **Gateway 1:** Cisco Catalyst 8000V (AWS) - Routes toward Azure Hub.
3. **Gateway 2:** FortiGate NVA (Azure) - Receives AWS traffic and performs transitive lookup to HQ.
4. **Gateway 3:** Hyper-V RRAS (HQ) - Receives traffic via Azure IPSec tunnel.
5. **Destination:** On-Prem Target (192.168.1.10).

### 4. Recruiter Hook
"Architected a global transit fabric by enabling **Transitive Routing** through a centralized Azure Hub. Successfully brokered dynamic BGP communication between **AWS (Cisco)** and **On-Premises (Windows)** environments, demonstrating the ability to build a scalable 'Hub-and-Spoke' global network that eliminates the need for high-maintenance full-mesh VPN topologies."

---

## Phase O4: Unified Zero Trust Edge (Entra GSA)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **Legacy VPN Limitations:** OpenVPN P2S creates a manual "dial-in" culture, provides excessive network-level access, and incurs high costs for Azure VPN Gateways. It lacks identity-aware granular control and device compliance enforcement. |
| **Technical Solution** | **Full SSE Suite Transition:** Replacing legacy VPNs with **Microsoft Entra Global Secure Access (GSA)**. 1. **Private Access:** Clientless/Seamless ZTNA for RDP and private apps. 2. **Internet Access:** Identity-based SWG for web filtering. 3. **Remote Networks:** Hardware-level integration of **FortiGate (Azure)** and **Cisco (AWS)** via BGP/IPSec tunnels. |
| **Network Integration** | **Router-to-PoP Handshake:** The FortiGate NVA initiates a dynamic BGP peering session to the nearest Entra GSA Point of Presence (PoP). This protects the entire branch (AWS/Azure Spokes) without requiring local client installs on every server or IoT device. |
| **IaC Strategy** | **Multi-Provider Automation:** Using the `microsoft-graph` Terraform provider to automate GSA "Remote Network" containers and "Private Access" application segments. Using `fortios` and `iosxe` providers to automate the complex IPSec/BGP handshake. |
| **Acceptance Criteria** | 1. Legacy Azure VPN Gateway successfully decommissioned. 2. Remote User access to internal resources verified via GSA Client (No VPN adapter present). 3. BGP peering state between NVAs and GSA PoPs is "Established." |
| **Validation** | From a remote client: Verify RDP to Spoke VMs fails without the GSA client (Network unreachable) but succeeds once authenticated via Entra MFA/Conditional Access. |
| **Evidence** | `docs/release2/evidence/O4/`: Terraform code for the tunnel setup, Entra Traffic Logs showing User-to-App level auditing, and screenshots of the GSA Connection Diagnostics. |

### 2. Operational Architecture (The Identity-Centric Edge)
This illustrates the replacement of the legacy VPN with an identity-aware SSE fabric that supports both remote users and site-wide router integration.

       [ Remote User ] ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(GSA Client)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
       (Legacy P2S Migration)                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
                                [ Microsoft Entra GSA Edge ]
                                (Identity & Device Compliance)
                                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
        [ Private Access ]            [ Microsoft 365 ]             [ Internet Access ]
        (ZTNA / No VPN Adapter)       (Tenant Restrictions)         (SWG / Web Filtering)
                ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                             ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡               ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â´ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â
    ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼ (Remote Networks)     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                 ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼               ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼                           ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
[ FortiGate (Azure) ]  [ Cisco (AWS) ]   [ SharePoint ]    [ Public Web ]          [ SaaS Apps ]
(BGP / IPSec)          (BGP / IPSec)     (Optimized)       (Filtered)              (Secure)

### 3. FinOps & Strategic Value
*   **The "VPN Killer" Savings:** By decommissioning the **Azure VPN Gateway (VpnGw1)**, we eliminate roughly **$138/month** in passive infrastructure costs.
*   **License Consolidation:** Replaces standalone SWG (Zscaler), VPN (AnyConnect), and Proxy licenses with a single **Entra Suite** trial, reducing security TCO by up to **40%**.
*   **Infrastructure Reduction:** Removes the administrative overhead of managing OpenVPN certificates, client configuration files, and static IP pools for remote users.
*   **Credit Conservation ($200 Budget):** Automated Terraform "teardown" ensures that expensive IPSec tunnels and NVA compute resources are only active during validation windows.

### 4. Recruiter Hook
"Successfully migrated a legacy **OpenVPN Point-to-Site** environment to a modern **Security Service Edge (SSE)** fabric using **Microsoft Entra Global Secure Access**. Orchestrated the transition via **Terraform (Microsoft Graph API)**, integrating FortiGate and Cisco routers to establish a unified Zero Trust perimeter. This approach replaced network-level VPNs with identity-centric access, significantly reducing cloud infrastructure costs and improving security posture."

---

## Phase O5: Modern End-User Computing (AVD & FSLogix)

### 1. Refined Phase Detail
| Aspect | Refined Detail (Expert Version) |
| :--- | :--- |
| **Business Problem** | **EUC Inefficiency & Data Volatility:** Standard VMs suffer from "profile rot," high costs due to 24/7 run-times, and potential data loss if a specific VM is corrupted or deleted. |
| **Technical Solution** | **Stateful VDI Delivery:** Deploying an **Azure Virtual Desktop (AVD)** environment via Terraform. Implementing **FSLogix Profile Containers** on Azure Files (Premium) to decouple user "personality" from the compute resource. Integrating with the **Entra GSA** edge (Phase O4) to ensure all VDI sessions are Zero-Trust verified. |
| **Storage Strategy** | **High-Performance Roaming:** Utilizing **Azure Files (SMB)** with Active Directory integration (via the Hybrid Link in O3a) to host `.vhdx` profile disks, ensuring sub-second login times across the session host pool. |
| **IaC Implementation** | **Modular AVD Deployment:** Using Terraform to orchestrate the AVD "Golden Triangle": 1. **Host Pool** (Breadth-first load balancing). 2. **Application Group** (Desktop/RemoteApp). 3. **Workspace**. |
| **Acceptance Criteria** | 1. AVD Session Hosts successfully domain-joined to `hq.azawslab.co.uk`. 2. FSLogix mounts a new profile disk upon first user login. 3. Automated Scaling Plan successfully drains and shuts down hosts after business hours. |
| **Validation** | Verify "The Roaming Test": Log into Host-01, create a file, log out, and log into Host-02. Confirm the file persists via the FSLogix container. |
| **Evidence** | `docs/release2/evidence/O5/`: Terraform code for the Host Pool, a screenshot of the FSLogix mount in Disk Management, and an Azure Cost Management chart showing the "Scaling Plan" dip in compute spend. |

### 2. Operational Architecture (The Persistent Workspace)
This illustrates the separation of Compute (Disposable) from User Data (Persistent), secured by the Hub-Spoke fabric.

    [ Remote User ] ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(HTTPS/RDP)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Azure Virtual Desktop Service ]
                                              ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã...â€œÃƒÆ'Ã¢â'¬Å¡Ãƒâ€šÃ'Â¼
    [ AVD Session Host (Spoke VNet) ] <ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(UDR)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Hub Security Hub ]
    (Compute - Windows 11 Multi-session)                 (AzFW / FortiGate)
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡                                                     ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€¦Ã'Â¡
          ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬(SMB/Port 445)ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬> [ Azure Files Share ] <ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã...Â¡Ãƒâ€šÃ'Â¬ÃƒÆ'Ã†â€™Ãƒâ€šÃ'Â¢ÃƒÆ'Ã'Â¢ÃƒÂ¢Ã¢â'¬Å¡Ã'Â¬Ãƒâ€šÃ'ÂÃƒÆ'Ã¢â'¬Â¹Ãƒâ€¦Ã¢â'¬Å"
                                     (FSLogix Profile Disks)

### 3. FinOps & Strategic Value
*   **Compute Auto-Scaling:** Implementing **Scaling Plans** (Autoscale) to trigger "Power-On-Connect" and "Drain-on-Logoff" logic. This ensures you only pay for compute during active hours, reducing VDI run-rate by up to **70%**.
*   **Multi-session Licensing:** Utilizing **Windows 11 Multi-session** to allow 5-10 users per VM, drastically lowering the "Cost Per User" compared to 1-to-1 personal desktops.
*   **Storage Tiering:** Using **Azure Files Premium** for the FSLogix IOPS burst capability but configuring **Lifecycle Management** to move stale user data to lower-cost tiers if inactive for 90+ days.
*   **Credit Conservation ($200 Budget):** Terraform is configured to deploy **B-Series VMs** for session hosts, which are "burstable" and significantly cheaper for lab-scale testing of the VDI logic.

### 4. Recruiter Hook
"Mastered the 'Last Mile' of hybrid cloud by architecting a highly available **Azure Virtual Desktop (AVD)** environment. Implemented **FSLogix Profile Containers** to decouple user data from compute, ensuring seamless roaming and high performance. Integrated automated **Scaling Plans** and multi-session host pools to optimize cloud spend, proving a deep commitment to **FinOps** and enterprise-grade user experience."






---

## Current P5/O3a Hybrid Connectivity Design Alignment

The active P5/O3a design is now the validated Azure VPN Gateway to VyOS model.

```text
Connectivity plane:
  Azure VPN Gateway terminates IKEv2/IPSec to VyOS.

Inspection plane:
  FortiGate remains deployed as the NVA inspection and service-chaining plane.

Remote edge:
  VyOS on Hyper-V represents the HQ/on-prem lab edge.

Routing plane:
  Hub/spoke gateway transit propagates the HQ prefix to the workload spoke.
```

The original direct FortiGate-to-VyOS IPSec goal was tested but not retained as the active implementation path. FortiGate BYOL trial mode exposed only DES-class IPSec proposals, while the project security baseline requires modern encryption. The implementation therefore uses Azure VPN Gateway for AES-256 IPSec termination and reserves FortiGate for controlled inspection/service-chaining validation.

Current validated state:
- Azure VPN Gateway public IP: `20.100.50.9`
- VPN Gateway: `vpngw-dev-vyos-norwayeast-01`
- Local Network Gateway: `lngw-dev-vyos-norwayeast-01`
- VPN connection: `vcn-dev-vpngw-to-vyos`
- VyOS peer: `vyos01.hq.azawslab.co.uk`
- HQ/on-prem prefix: `192.168.1.0/24`
- Workload VM: `vm-dev-client-01` / `10.10.0.4`
- FortiGate trusted interface: `10.0.3.36`
- FortiGate untrusted/hub interface: `10.0.3.4`

Next implementation target:
- FortiGate service chaining for selected Azure workload to HQ traffic.
- Do not claim FortiGate inspection until FortiGate policy counters or logs prove traversal.
- Do not modify GatewaySubnet routes unless separately researched and justified.


---

## Current O1 Service-Chain Validation Status

O1 has validated the Azure workload to HQ service-chain path through the FortiGate NVA.

```text
[Azure Workload VM]
  vm-dev-client-01 / 10.10.0.4
        |
        | workload subnet UDR:
        | 192.168.1.0/24 -> VirtualAppliance 10.0.3.36
        v
[FortiGate trusted interface]
  port2 / 10.0.3.36
        |
        | policy ID 1:
        | source      = 10.10.0.0/16
        | destination = 192.168.1.0/24
        | service     = PING
        | NAT         = enabled
        v
[FortiGate hub interface]
  port1 / 10.0.3.4
        |
        | Azure hub / VPN Gateway path
        v
[Azure VPN Gateway]
  20.100.50.9
        |
        | IKEv2/IPSec to VyOS
        v
[VyOS / HQ Lab]
  192.168.1.254 / 192.168.1.0/24
```

Validated:
- Azure workload effective route for `192.168.1.0/24` used `VirtualAppliance 10.0.3.36`.
- FortiGate received traffic on `port2`.
- FortiGate policy ID 1 allowed the traffic.
- FortiGate applied SNAT from `10.10.0.4` to `10.0.3.4`.
- FortiGate forwarded traffic out `port1` toward the Azure VPN Gateway/VyOS path.
- VyOS observed the SNATed ICMP requests and sent replies.
- FortiGate received replies on `port1` and forwarded them back out `port2` to the Azure workload.

Lab delta:
SNAT is used for the first controlled validation to avoid asymmetric return routing. Production design should separately evaluate whether to retain SNAT, use symmetric routing without NAT, or steer VPN Gateway ingress traffic through the NVA.

Out of current O1 scope:
- HQ/VyOS-initiated inspection toward Azure workloads.
- GatewaySubnet route changes.
- Bidirectional NVA inspection design.


---

## Current O3b/O3c Architecture Alignment - Azure VPN Gateway Transit Hub

The active O3b/O3c design follows the validated P5/O1/O3a architecture.

```text
Azure VPN Gateway:
  IPSec and BGP transit hub for external site-to-site peers.

FortiGate:
  Azure-side inspection and service-chaining plane.

VyOS:
  HQ / on-prem edge.

Cisco Catalyst 8000V:
  AWS branch/customer edge router.
```

The Azure FortiGate NVA is not the active IPSec/BGP tunnel termination point for O3b. FortiGate remains the inspection plane. This follows the earlier P5/O3a design decision to decouple IPSec termination from NVA inspection after the FortiGate BYOL evaluation license exposed only DES-class IPSec proposals.

### Target O3b Topology

```text
                [Azure Hub VNet]
                       |
               [Azure VPN Gateway]
                 ASN: 65515
                       |
          +------------+-------------+
          |                          |
      IPSec/BGP                  IPSec/BGP
          |                          |
          v                          v
   [VyOS / HQ Lab]           [Cisco 8000V / AWS]
     ASN: 65001                  ASN: 65002
     192.168.1.0/24              172.16.0.0/16
```

### O3b Scope

O3b should prove the AWS branch routing foundation:

- Cisco Catalyst 8000V BYOL Marketplace subscription is active.
- Cisco 8000V is deployed in AWS through Terraform.
- AWS route tables steer selected branch subnet traffic to the Cisco ENI.
- Cisco establishes IPSec/BGP with Azure VPN Gateway.
- Azure learns AWS branch prefixes through the VPN Gateway.
- Cisco learns intended Azure/HQ prefixes through BGP.
- Cisco remains controlled by explicit enable flags and cost/teardown notes.

### O3c Scope

O3c should prove global/transitive routing after O3b is stable:

- Azure workload to AWS branch routing.
- HQ/VyOS to AWS branch routing.
- AWS branch to Azure/HQ routing.
- FortiGate inspection only where intentionally service-chained and proven with policy counters or logs.

Do not claim FortiGate inspection for AWS/HQ/Azure flows until FortiGate counters or logs prove traversal.


---

## O3b Selective BGP Validation Requirement

O3b must prove segmented BGP behavior, not just basic route propagation.

The AWS branch currently has separate trusted and DMZ subnets:

```text
AWS Branch VPC: 172.16.0.0/16

Trusted subnet:
  172.16.1.0/24
  ec2-dev-aws-trusted-01

DMZ subnet:
  172.16.2.0/24
  ec2-dev-aws-dmz-01
```

The intended O3b validation is selective route propagation:

```text
Advertised over BGP:
  172.16.1.0/24 trusted subnet

Not advertised over BGP:
  172.16.2.0/24 DMZ subnet
```

This proves that the Cisco 8000V branch edge can advertise approved private branch prefixes while withholding less-trusted segments from hybrid private routing.

Validation intent:

```text
Positive validation:
  Azure/HQ learns or can reach the trusted AWS prefix only where expected.

Negative validation:
  Azure/HQ does not learn or reach the DMZ prefix through private BGP propagation.

AWS routing validation:
  Trusted subnet route table steers selected hybrid prefixes to Cisco.
  DMZ subnet route table does not receive the same private hybrid route by default.
```

Do not advertise the full `172.16.0.0/16` summary during the first O3b segmented validation, because that would hide the intended trusted-vs-DMZ route-control proof.


---

## O5 Architecture Alignment - Secure Admin and Dev Workspace

O5 is aligned as a secure admin and development workspace using Azure Virtual Desktop and FSLogix.

The objective is not only to provide a desktop experience. O5 provides a controlled, policy-aligned management entry point for Azure, hybrid, and future AKS/container administration without relying on unmanaged local developer machines.

```text
[Admin / Engineer Device]
        |
        | HTTPS / AVD broker
        v
[Azure Virtual Desktop Service]
        |
        v
[AVD Session Host]
  AVD Spoke: 10.2.0.0/16
  Tools: Azure CLI, kubectl, Helm, Git, VS Code, Docker CLI
        |
        +-----------------------------+-----------------------------+
        |                             |                             |
        v                             v                             v
[Azure Firewall]              [FortiGate NVA]              [Azure Files PE]
Internet / SaaS / updates     HQ AD / DNS / hybrid paths   FSLogix profiles
AVD control-plane egress      where service-chained         private SMB path
```

### Design Intent

- AVD is the secure admin/dev workspace for platform operations.
- AVD resides in the `10.2.0.0/16` optional/admin workspace spoke.
- AVD egress for internet, tooling, Windows Update, Azure control plane, and AVD service dependencies should use Azure Firewall where that control is enabled.
- AVD hybrid/private traffic to HQ AD, DNS, or other private systems should use the approved hybrid route and may be inspected by FortiGate where intentionally service-chained.
- FSLogix profile containers should use Azure Files with a private endpoint rather than a public storage path.
- Docker Desktop is optional. The baseline toolchain should use Docker CLI or container tooling unless Docker Desktop licensing and resource impact are accepted.
- AKS validation is conditional. If AKS exists, validate `kubectl get nodes` from AVD. If AKS does not exist yet, validate only the admin/dev toolchain readiness.

### Terraform Responsibility

Terraform should own:
- AVD host pool
- AVD workspace
- desktop application group
- AVD spoke networking if not already present
- AVD subnet and route-table association
- Azure Files storage account for FSLogix
- private endpoint for Azure Files
- session host VM infrastructure
- Key Vault references for bootstrap values where required

### Ansible Responsibility

Ansible should own:
- AVD agent/bootstrap configuration where applicable
- FSLogix registry configuration
- baseline admin/dev tool installation
- Azure CLI
- kubectl
- Helm
- Git
- VS Code
- Docker CLI or approved container tooling

### O5 Validation Gate

O5 is complete only when:
- AVD host pool, workspace, and desktop application group are deployed.
- User assignment works.
- Session host is reachable through AVD.
- FSLogix profile container mounts through the intended Azure Files private endpoint path.
- Profile persistence is validated across logoff/logon.
- AVD internet/control-plane egress is validated through Azure Firewall where enabled.
- AVD-to-HQ AD/DNS/private paths are validated through the approved hybrid route.
- Admin/dev toolchain is validated.
- If AKS exists, `kubectl get nodes` succeeds from AVD.
- If AKS does not exist, AKS access is recorded as deferred and only toolchain readiness is validated.


---

## Current O4/O5 Execution Order

The active execution order is:

```text
O3b:
  AWS Cisco 8000V to Azure VPN Gateway IPSec/BGP.

O3c:
  Azure, HQ, and AWS transitive routing validation.

O4:
  Private AKS modern application platform using Docker/container tooling and dual-security routing.

O5:
  AVD + FSLogix secure admin/dev workspace for polished operator access after the platform exists.
```

O4 is implemented before O5 because the existing Azure-connected management host can act as the first private control point for `az`, `kubectl`, `helm`, Docker CLI, and Ansible. O5 later improves the operator experience by replacing unmanaged local/admin access with a controlled AVD workspace.

Entra Global Secure Access / ZTNA is deferred as a future access-modernization enhancement and is not the active O4 implementation scope.


---

## O4 Architecture Alignment - Modern App Platform with Private AKS and Dual-Security

O4 is re-scoped from Entra Global Secure Access to a modern private application platform based on Azure Kubernetes Service, Azure Container Registry, Docker/container tooling, and the existing dual-security network model.

### Objective

Transition the Release 2 workload pattern from traditional VM-only hosting toward a private container platform.

The O4 target is a private AKS cluster that is invisible to the public internet and uses the right security control for the destination:

```text
Internet / cloud-native egress:
  Azure Firewall

Hybrid / HQ private traffic:
  FortiGate NVA where intentionally service-chained

Kubernetes platform:
  Private AKS cluster with Azure CNI or Azure CNI Overlay, userDefinedRouting, Workload Identity, and OIDC issuer

Container supply chain:
  Azure Container Registry with anonymous pull disabled and AcrPull granted to the AKS identity
```

### Target Architecture

```text
[Management Host / Later AVD Admin Workspace]
        |
        | private admin path
        v
[Private AKS API]
        |
        v
[AKS Node Subnet]
  snet-aks-nodes-dev-norwayeast
  10.10.2.0/24
        |
        +-------------------------------+
        |                               |
        v                               v
[Azure Firewall]                 [FortiGate NVA]
Internet / MCR / ACR / updates   HQ AD / DNS / hybrid paths
Docker / package egress          192.168.1.0/24 where service-chained
```

### Networking

O4 adds a dedicated AKS node subnet to the existing Azure workload spoke:

```text
VNet:
  vnet-dev-norwayeast-spoke-workload
  10.10.0.0/16

AKS node subnet:
  snet-aks-nodes-dev-norwayeast
  10.10.2.0/24
```

The AKS cluster should use:
- private cluster mode
- Azure CNI or Azure CNI Overlay after final IP capacity check
- `outbound_type = userDefinedRouting`
- no public API endpoint
- no public node IPs
- no public LoadBalancer service for first validation

### Route Intent

A dedicated AKS route table should be used for explicit traffic steering:

```text
Route table:
  rt-aks-egress-dev-norwayeast

Routes:
  0.0.0.0/0       -> Azure Firewall private IP
  192.168.1.0/24  -> FortiGate trusted interface 10.0.3.36, only where service-chain validation is intended
```

Do not claim FortiGate inspection until FortiGate policy counters or logs prove AKS/HQ traffic traversal.

### Terraform Responsibility

Terraform should own:
- AKS cluster
- AKS node subnet and route-table association
- ACR
- AcrPull role assignment for the AKS identity
- AKS managed identity / Workload Identity / OIDC issuer settings
- Key Vault Secrets Store CSI Driver add-on where included
- Azure Firewall application/network rules for AKS egress where Azure Firewall is enabled
- optional internal load balancer service support
- enable flags and teardown-safe defaults

### Ansible Responsibility

Ansible should own management-host platform bootstrap:
- Docker CLI or approved container tooling
- kubectl
- Helm
- Azure CLI validation
- kubeconfig retrieval through managed identity where possible
- namespace bootstrap such as `prod-workload`
- Helm deployment of the sample private application
- validation commands from the management host first, and later from AVD when O5 exists

### Security and Identity

O4 should use:
- AKS managed identities
- OIDC issuer and Workload Identity
- Key Vault Secrets Store CSI Driver for controlled secret access
- ACR anonymous pull disabled
- no public Kubernetes API
- no public service LoadBalancer for first validation
- optional Azure Policy for Kubernetes to restrict public services later

### Validation Gate

O4 is complete only when:
- private AKS is deployed
- AKS API is reachable only through the approved private management path
- node subnet route table shows expected UDRs
- AKS outbound egress works through Azure Firewall where enabled
- AKS can pull images from ACR using managed identity
- sample app deploys successfully
- internal service endpoint is reachable from the management host
- FortiGate inspection is proven only if AKS-to-HQ traffic is intentionally service-chained and policy counters/logs confirm traversal
- evidence is saved under `docs/release2/evidence/O4/`

### FinOps

AKS and Azure Firewall can generate significant cost.

The validation window should be planned. After evidence is captured:
- destroy or scale down AKS/node pools if no longer needed
- disable Azure Firewall if not required for the next validation
- keep only low-cost code and evidence unless the next phase depends on active resources

### Future Access Modernization

Entra Global Secure Access / ZTNA can be revisited later as an access-modernization improvement after private AKS, AWS transit, and the AVD workspace phases are stable.

---

## A1/A2 Automation Control Plane Alignment

### Current Automation State

A1 is completed and validated.

A1 created the Release 2 Ansible network/security automation baseline under:

```text
ansible/release2/network/
```

A1 validated:

- FortiGate read-only API validation through a least-privilege API token.
- FortiGate least-privilege sanitized API snapshot backup.
- VyOS read-only validation and sanitized backup.
- Cisco RESTCONF read-only validation.
- Cisco controlled OpenSSH fallback for CLI-only BGP/routing/running-config evidence.
- Idempotency/no-device-change proof.

Evidence is stored under:

```text
docs/release2/evidence/A1-ansible-network-baseline/
```

### Secret Model

```text
FortiGate:
  Azure Key Vault:
    p5-fortigate-api-token
  Runtime variable:
    FORTIOS_ACCESS_TOKEN

VyOS:
  Azure Key Vault:
    o3b-vyos-ansible-password
  Runtime variable:
    O3B_VYOS_ANSIBLE_PASSWORD

Cisco:
  AWS SSM:
    /azawslab/release2/o3b/cisco-restconf-password
  Runtime variable:
    O3B_CISCO_RESTCONF_PASSWORD
```

### A2 Scope - AWX Automation Control Plane

A2 is the next recommended automation milestone before O4.

A2 will centralize the validated A1 Ansible model into an enterprise-style automation control plane.

Target A2 design:

```text
Azure-managed AWX VM
        |
        +-- Entra ID / Azure AD login
        +-- AWX RBAC
        +-- GitHub project sync
        +-- Azure Key Vault runtime secrets
        +-- AWS SSM runtime secrets
        +-- job templates for validated playbooks
        |
        +-- supports:
              A1 network/security validation
              O4 private AKS operations
              O5 AVD/admin workspace operations
```

### A2 Responsibility Split

Terraform should own:

- AWX management VM or approved container host infrastructure.
- Network placement in the management path.
- NSG rules limited to approved admin sources and private management paths.
- Managed identity and Key Vault access where Azure-native access is used.
- Optional DNS records and monitoring hooks.

Ansible should own:

- AWX installation/bootstrap.
- AWX organization, inventory, project, credentials, and job template bootstrap.
- GitHub project sync configuration.
- Job template creation for A1, O4 support tasks, and O5 support tasks.
- Runtime validation and evidence capture.

### A2 Validation Gate

A2 is complete only when:

- AWX is reachable only through the intended management path.
- Entra/Azure AD login or approved enterprise identity integration is validated.
- AWX RBAC separates operator/admin responsibilities.
- GitHub project sync succeeds.
- Key Vault secret retrieval works without storing plaintext secrets in Git.
- AWS SSM retrieval works through the existing Roles Anywhere/IAM model.
- A1 read-only validation can run from AWX or is explicitly staged as an AWX job template.
- Evidence is saved under `docs/release2/evidence/A2-awx-control-plane/`.

### Relationship to O4 and O5

A2 does not replace O4.

A2 is an automation control-plane enabler for O4 and O5.

O4 remains the private AKS modern application platform using Docker/container tooling and dual-security routing.

O5 remains the AVD + FSLogix secure admin/dev workspace.

---

## A2/O4/O5 Integrated Platform Design

### Domain Alignment

```text
On-prem / Hyper-V / HQ AD:
  hq.azawslab.co.uk

Azure / Entra:
  entra.azawslab.co.uk

AWS branch:
  br1.azawslab.co.uk
```

### Integrated Sequence

```text
A2:
  AWX automation control plane

O4:
  Private AKS modern application platform

O5:
  Single-user AVD secure admin/dev workspace with FSLogix
```

A2, O4, and O5 are designed together because they share the same operator, tooling, identity, secret, and validation model.

### A2 - AWX Automation Control Plane

A2 implements AWX as the enterprise automation control plane for Release 2.

Target host:

```text
vm-dev-awx-01
```

Bootstrap admin:

```text
awx-admin
```

Recommended Entra groups:

```text
azw-awx-admins
azw-awx-operators
azw-awx-change-approvers
azw-awx-emergency-admins
```

A2 must include all automation tiers in one implementation package:

```text
Tier 1 - Read-only validation
  Operator-run validation jobs.
  Expected changed=0.

Tier 2 - Sanitized backup
  Operator/senior-operator jobs.
  No device configuration changes.
  Produces sanitized evidence.

Tier 3 - Preflight / dry-run
  Senior operator/admin.
  Shows intended changes where supported.

Tier 4 - Approved write/change
  Admin or approved operator only.
  Requires backup, approval, apply, post-check, and evidence.

Tier 5 - Rollback/emergency
  Admin only.
  Requires strong evidence.
  Requires explicit rollback reason.
  Captures before/after state.
```

A2 workflow model:

```text
AWX Controlled Change Workflow

1. Precheck validation
   |
   v
2. Sanitized pre-change backup
   |
   v
3. Manual approval
   |
   v
4. Apply approved change
   |
   v
5. Post-change validation
   |
   v
6. Evidence capture
   |
   v
7. Optional rollback/emergency workflow
      |
      +--> rollback approval
      +--> rollback execution
      +--> post-rollback validation
      +--> rollback evidence
```

Secret model:

```text
Azure Key Vault:
  p5-fortigate-api-token
  p5-fortigate-api-token-config
  o3b-vyos-ansible-password
  a2-awx-admin-password
  a2-awx-secret-key
  a2-awx-postgres-password

AWS SSM:
  /azawslab/release2/o3b/cisco-restconf-password
```

FortiGate token split:

```text
Read token:
  user: ansible-o1-svc
  secret: p5-fortigate-api-token
  purpose: read-only validation and snapshot

Write token:
  user: ansible-a2-config-svc
  secret: p5-fortigate-api-token-config
  purpose: approved AWX write/change workflows only
```

### O4 - Private AKS Modern Application Platform

O4 builds the private modern application platform.

Target:

```text
Private AKS cluster
  + ACR
  + Workload Identity
  + OIDC issuer
  + Key Vault CSI Driver
  + internal/private ingress
  + sample NGINX or .NET container app
```

Recommended Entra groups:

```text
azw-aks-platform-admins
azw-aks-app-operators
azw-aks-readers
```

Routing model:

```text
Cloud-native egress:
  Azure Firewall

Hybrid/private inspection:
  FortiGate only where the route path, policy counters, or logs prove traversal
```

Ingress model:

```text
First implementation:
  internal NGINX ingress

Optional later enhancement:
  internal AGIC / Application Gateway
```

O4 must not claim public exposure. First validation remains private.

### O5 - AVD + FSLogix Secure Admin/Dev Workspace

O5 provides the secure engineering workspace for platform/admin operations.

Recommended model:

```text
Single-user admin/dev workspace
  not pooled multi-user
```

Recommended Entra groups:

```text
azw-avd-admins
azw-avd-users
azw-avd-platform-engineers
```

O5 tooling baseline:

```text
Core:
  PowerShell 7
  Azure CLI
  Git
  VS Code
  Windows Terminal

Terraform / IaC:
  Terraform
  tflint where useful
  Checkov or tfsec if included later

Containers / AKS:
  Docker CLI or approved container tooling
  kubectl
  Helm
  kubelogin

Automation:
  Python 3
  Ansible if required
  jq/yq equivalents
  curl
  OpenSSH client

AWS / hybrid support:
  AWS CLI
  Roles Anywhere helper if needed
  FortiGate/VyOS/Cisco validation helpers
```

O5 relationship to A2 and O4:

```text
[Engineer]
    |
    v
[O5 AVD single-user admin/dev workspace]
    |
    +-- Azure CLI / Terraform / kubectl / Helm / Git / VS Code / Docker CLI
    |
    v
[A2 AWX vm-dev-awx-01]
    |
    +-- GitHub project sync
    +-- Key Vault secrets
    +-- AWS SSM secrets
    +-- A1/A2/O4/O5 job workflows
    |
    v
[O4 Private AKS Platform]
```

### Implementation Rule

A2/O4/O5 implementation must not start until this integrated design is committed and reviewed.

Terraform changes must explain root/module/variable/wiring with a text diagram before code.

Ansible/AWX changes must explain inventory/group_vars/playbook/role/runtime-secret/job-template flow before code.

<!-- O5-FINAL-IMPLEMENTATION-ALIGNMENT:START -->

## O5 Finalized Implementation Alignment - AVD Secure Admin/Dev Workspace

O5 is the secure admin/development workspace phase. It is not just an AVD desktop deployment. It provides a controlled operator workspace for Azure, hybrid, AKS, AWX, container, and infrastructure operations after O4 private AKS is stable.

### Canonical O5 resource names

| Component | Canonical name |
|---|---|
| AVD host pool | `vdpool-dev-norwayeast` |
| AVD workspace | `vdws-dev-norwayeast` |
| AVD desktop application group | `vdag-dev-norwayeast` |
| AVD spoke VNet | `vnet-dev-norwayeast-spoke-avd` |
| AVD subnet | `snet-avd` |
| AVD route table | `rt-avd-to-hub-norwayeast` |
| FSLogix storage account | `stdevavdfsne01` |
| FSLogix file share | `fslogix-profiles` |
| Azure Files private endpoint | `pe-stdevavdfsne01-file` |

### O5 host pool decision

O5 first implementation uses a personal/single-user admin/dev workspace model. This avoids mixing the O5 secure operator workspace with a general pooled desktop service. The first session host is used to validate admin/dev tooling, FSLogix persistence, private routing, AWX access, and O4 AKS operations.

### Terraform state ownership

```text
terraform/platform-networking/dev
  owns:
    hub/spoke networking
    Azure Firewall and shared firewall policy
    FortiGate
    VPN Gateway
    BGP/IPSec transit
    shared route control

terraform/platform-management/dev
  owns:
    vm-dev-mgmt-01
    vm-dev-awx-01
    AWX operations plane

terraform/platform-aks/dev
  owns:
    O4 private AKS
    ACR
    AKS identity/RBAC inputs
    Workload Identity
    OIDC issuer
    Key Vault CSI Driver
    Azure Monitor / managed Prometheus
    Azure Managed Grafana
    AKS node subnet and AKS UDR

future terraform/platform-avd/dev
  owns:
    O5 AVD host pool
    O5 AVD workspace
    desktop application group
    AVD session hosts
    AVD spoke/subnet
    AVD route table
    FSLogix Azure Files storage
    Azure Files private endpoint
    O5 user/group assignments
```

AKS is not placed in `platform-networking/dev` because AKS is an application platform, not a transit/security-routing component. AKS is not placed in `workloads/dev` because O4 is not a single application VM; it is a platform service with identity, private API, ACR, monitoring, and O5 dependency.

O5 is not placed in `platform-management/dev` because AWX and the management VM are the operations plane, while AVD is a separate secure workspace plane.

### O5 first implementation identity decision

O5 first implementation uses domain-joined session hosts to `hq.azawslab.co.uk` unless preflight proves a better identity model is ready. FSLogix uses Azure Files over a private endpoint, with the final storage identity model validated before Terraform apply.

### O5 validation requirements

O5 is not complete until the following are proven:

```text
AVD:
  host pool exists
  workspace exists
  desktop app group exists
  session host available
  approved user/group can sign in

FSLogix:
  Azure Files private endpoint resolves privately
  SMB path works from the session host
  profile container is created
  profile persists after logoff/logon

Network:
  AVD required endpoints are reachable
  AVD egress follows Azure Firewall where enabled
  HQ DNS/AD path works where domain join is used
  FortiGate inspection is claimed only if counters/logs prove traversal

Toolchain:
  Azure CLI works
  kubectl and kubelogin work
  Helm works
  Git works
  VS Code is installed
  Terraform works
  AWS CLI works
  Docker CLI or approved container tooling is available
  kubectl can validate O4 private AKS
```

<!-- O5-FINAL-IMPLEMENTATION-ALIGNMENT:END -->

## O6 Current Implementation Position

O6 is included in Release 2 as a design extension and architecture integration pattern.

Current state:

- No cloud resources are currently active.
- A2 AWX is complete and evidence-backed.
- O4 private AKS was previously validated and is currently destroyed for cost control.
- O5 AVD secure admin/dev workspace was previously validated and is currently destroyed for cost control.
- O6 optional live validation is prepared but not currently deployed.
- O6 must not be described as autonomous remediation.

O6 future live validation must remain unchecked until the `ai-enclave` namespace, Workload Identity manifests, NetworkPolicies, Azure Monitor / Log Analytics dashboard or query pack, and AWX job-template proposal examples are applied or created and evidence is captured.

