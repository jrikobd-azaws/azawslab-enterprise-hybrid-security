### Phase 1: Azure Landing Zone & Governance

# Phase 1: Azure Landing Zone & Governance Foundation

| Aspect | Refined Detail (Expert Version) |
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