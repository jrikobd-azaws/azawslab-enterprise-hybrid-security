# Release 2 Build Checklist

## Purpose

This checklist is the authoritative task-state tracker for Release 2 of the `azawslab Enterprise Hybrid Security Platform`.

Release 2 focuses on Azure secure platform engineering, delegated administration, network security, governance, cloud security posture, and security monitoring.

This file should reflect actual implementation state, not aspirational planning.

---

## Release 2 Scope Summary

Release 2 includes:

- Azure landing zone foundation
- Terraform or Bicep-based infrastructure deployment
- Azure Policy, RBAC, and Key Vault governance controls
- Azure Lighthouse delegated administration
- Global Secure Access / Entra Private Access
- VPN / routing / network security patterns
- Azure Firewall
- Defender for Cloud
- Microsoft Sentinel
- Optional advanced Azure edge, private service, and virtual desktop scenarios

---

## Status Key

- **Completed** = built, validated, and ready to document with evidence
- **In Progress** = actively implemented, partially working, or under documentation/evidence refinement
- **Pending** = not yet started or intentionally sequenced later in Release 2
- **Optional** = valuable enhancement, but not required for Release 2 core completion

---

## 1. Azure Landing Zone Foundation

| Item | Status | Notes |
|---|---|---|
| Azure tenant/subscription planning model defined | Pending | Document target subscription structure |
| Management group hierarchy designed | Pending | `Platform`, `LandingZones`, `Sandbox`, etc. |
| Core subscriptions identified | Pending | Management / Connectivity / Workload |
| Resource group naming convention defined | Pending | Consistent RG structure for platform and workloads |
| Tagging model defined | Pending | Owner, environment, workload, cost center, etc. |
| Azure landing zone structure created | Pending | Initial deployment complete |
| Subscription placement under management groups validated | Pending | Inheritance path confirmed |

---

## 2. Infrastructure as Code (Terraform or Bicep)

| Item | Status | Notes |
|---|---|---|
| IaC language selected | Pending | Terraform or Bicep |
| Repo structure for IaC created | Pending | Separate folders/modules for landing zone and platform |
| Resource group deployment via IaC | Pending | First successful deployment |
| VNet/subnet deployment via IaC | Pending | Core network scaffold |
| Log Analytics deployment via IaC | Pending | Shared monitoring workspace |
| Key Vault deployment via IaC | Pending | Platform vault |
| Policy assignment via IaC | Pending | At least one policy deployed by code |
| RBAC assignment via IaC | Pending | At least one scoped assignment |
| Reusable variables / parameter model implemented | Pending | Environment reuse ready |
| IaC deployment evidence captured | Pending | Screenshots and code snippets saved |

---

## 3. Governance: Azure Policy / RBAC / Key Vault

| Item | Status | Notes |
|---|---|---|
| Azure Policy baseline defined | Pending | Small but realistic governance baseline |
| Allowed locations policy assigned | Pending | Restrict region sprawl |
| Required tags policy assigned | Pending | Governance consistency |
| Public IP restriction policy reviewed/assigned | Pending | Optional deny pattern |
| Diagnostic settings policy reviewed/assigned | Pending | If practical in scope |
| RBAC role model documented | Pending | Reader, Contributor, Network, Security, KV access |
| RBAC assignment scope validated | Pending | MG / subscription / RG |
| Shared platform Key Vault deployed | Pending | Secrets/certs placeholder vault |
| Key Vault access model validated | Pending | RBAC or access policy model confirmed |
| Governance evidence captured | Pending | Policy assignments, compliance state, RBAC screenshots |

---

## 4. Azure Lighthouse Delegated Administration

| Item | Status | Notes |
|---|---|---|
| Provider/customer tenant model documented | Pending | MSP-style delegated ops scenario |
| Delegated scope selected | Pending | Subscription or resource group |
| Lighthouse onboarding template created | Pending | ARM/Bicep/Terraform as used |
| Delegated roles defined | Pending | Least-privilege delegated access |
| Lighthouse onboarding completed | Pending | Customer scope visible in provider tenant |
| Delegated administration validated | Pending | One management action performed successfully |
| Lighthouse evidence captured | Pending | My Customers, delegated scope, onboarding proof |

---

## 5. Global Secure Access / Entra Private Access

| Item | Status | Notes |
|---|---|---|
| Global Secure Access scope reviewed | Pending | Confirm suitability and limitations |
| Private Network Connector deployed | Pending | Connector operational |
| Internal app/resource selected | Pending | One service for private access validation |
| Entra Private Access app configured | Pending | Published resource |
| Access policy defined | Pending | User/group scoped access |
| Private access validation completed | Pending | Pilot user access works |
| Known limitations documented | Pending | Current service caveats recorded |
| Evidence captured | Pending | Connector, app, access flow screenshots |

---

## 6. VPN / Routing / Network Security

| Item | Status | Notes |
|---|---|---|
| Hub-and-spoke network design documented | Pending | Core Azure network pattern |
| Hub VNet created | Pending | Connectivity foundation |
| Spoke VNet created | Pending | Workload/network separation |
| VNet peering configured | Pending | Hub-spoke connectivity |
| Route table strategy defined | Pending | Forced routing / spoke path decisions |
| NSG baseline defined | Pending | Inbound/outbound control model |
| VPN pattern selected | Pending | Site-to-site or documented design |
| VPN deployment or design validation completed | Pending | Build or strong design proof |
| Private DNS / name resolution model documented | Pending | If applicable |
| Network evidence captured | Pending | VNets, peering, UDRs, NSGs, gateway screenshots |

---

## 7. Azure Firewall

| Item | Status | Notes |
|---|---|---|
| Azure Firewall subnet prepared | Pending | Correct subnet model |
| Azure Firewall deployed | Pending | Hub security control |
| Firewall policy created | Pending | Policy-based management preferred |
| Network rule collection configured | Pending | Core traffic rules |
| Application rule collection configured | Pending | FQDN-based control where needed |
| Route tables updated to use firewall path | Pending | Traffic steering validated |
| Firewall logging to Log Analytics enabled | Pending | Diagnostics visible |
| Firewall traffic validation completed | Pending | Allowed/denied path demonstrated |
| Azure Firewall evidence captured | Pending | Policy, rules, routing, logs |

---

## 8. Defender for Cloud

| Item | Status | Notes |
|---|---|---|
| Defender for Cloud onboarded | Pending | Subscription connected |
| Secure Score reviewed | Pending | Baseline posture recorded |
| At least one Defender plan enabled | Pending | Example: Defender for Servers |
| CSPM recommendations reviewed | Pending | Actionable recommendations noted |
| One posture improvement implemented | Pending | Improve secure score or recommendation state |
| Regulatory/compliance view reviewed | Pending | Compliance dashboard visibility |
| Defender for Cloud evidence captured | Pending | Secure Score, plans, recommendations screenshots |

---

## 9. Microsoft Sentinel

| Item | Status | Notes |
|---|---|---|
| Sentinel workspace selected/deployed | Pending | Log Analytics workspace ready |
| Microsoft Sentinel enabled | Pending | Service onboarded |
| Azure Activity connector enabled | Pending | Basic control-plane visibility |
| Entra sign-in / identity source connected | Pending | If available in scope |
| Defender for Cloud connector reviewed/enabled | Pending | Security posture/alert linkage |
| Workbook deployed | Pending | One starter workbook |
| Analytic rule deployed | Pending | One meaningful detection |
| Test incident or signal observed | Pending | Basic investigation proof |
| Sentinel evidence captured | Pending | Data connectors, incidents, workbook screenshots |

---

## 10. Expanded Monitoring and Governance

| Item | Status | Notes |
|---|---|---|
| Log Analytics workspace baseline documented | Pending | Central logging role explained |
| Azure Monitor overview documented | Pending | Metrics/log/alert role explained |
| One alert rule created | Pending | Platform or security alert example |
| Monitoring coverage across Firewall / Defender / Sentinel reviewed | Pending | Unified visibility concept |
| Governance and monitoring alignment documented | Pending | Policy + logging + security posture |
| Evidence captured | Pending | Alert, workspace, monitoring screenshots |

---

## 11. Optional Advanced Azure Edge / Private Service Layer

| Item | Status | Notes |
|---|---|---|
| Azure Front Door Standard/Premium reviewed | Optional | Global edge entry pattern |
| Front Door deployed | Optional | Only if app edge scenario exists |
| Application Gateway deployed | Optional | Regional ingress/WAF scenario |
| WAF policy configured | Optional | App protection baseline |
| Sticky session / affinity behavior tested | Optional | App Gateway cookie affinity if used |
| Azure Load Balancer deployed | Optional | Internal/L4 service balancing |
| HA ports pattern implemented | Optional | Only if scenario requires it |
| Floating IP pattern implemented | Optional | Only if scenario requires it |
| Private Link Service provider model built | Optional | Service behind Standard LB |
| Consumer subscription/private endpoint connected | Optional | Cross-subscription private access |
| Advanced edge/private service evidence captured | Optional | Screenshots and design notes |

---

## 12. Optional Cloud AVD Workstream

| Item | Status | Notes |
|---|---|---|
| AVD architecture documented | Optional | Keep separate from core Release 2 |
| Host pool deployed | Optional | Pilot AVD environment |
| Session hosts deployed | Optional | Compute layer |
| Application group configured | Optional | User app access |
| User assignment validated | Optional | Pilot access success |
| FSLogix profile design implemented | Optional | Profile persistence |
| Defender for Endpoint on session hosts enabled | Optional | Endpoint protection on AVD |
| AVD evidence captured | Optional | Host pool, session host, FSLogix, access screenshots |

---

## 13. Documentation and Evidence Closeout

| Item | Status | Notes |
|---|---|---|
| Landing zone diagrams created | Pending | Azure architecture visuals |
| IaC snippets/screenshots organized | Pending | Clear evidence paths |
| Governance evidence organized | Pending | Policy/RBAC/KV screenshots |
| Network security evidence organized | Pending | VPN, UDR, NSG, Firewall |
| Defender for Cloud evidence organized | Pending | Secure score/recommendations |
| Sentinel evidence organized | Pending | Data sources, analytics, incidents |
| `README.md` updated with Release 2 status | Pending | Repo front page refresh |
| Release 2 docs updated | Pending | Dedicated Azure platform docs |
| Lessons learned updated | Pending | Capture Azure platform/security findings |
| Release 2 checklist updated | Pending | Keep this file authoritative |

---

## Core Release 2 Completion Criteria

Release 2 core should be treated as complete when these are all true:

- Azure landing zone foundation exists
- Terraform or Bicep deploys core Azure platform resources
- Azure Policy / RBAC / Key Vault governance baseline is implemented
- Azure Lighthouse delegated administration is demonstrated
- VPN/routing/network security design is implemented or strongly validated
- Azure Firewall is deployed and validated
- Defender for Cloud is enabled and reviewed
- Microsoft Sentinel is enabled with at least one useful data source and analytic rule
- Monitoring and governance evidence is captured and documented

Optional edge, private service, and AVD items should strengthen Release 2, but are not mandatory for core completion.

---

## Immediate Release 2 Execution Order

The best execution order is:

1. Azure landing zone foundation
2. Terraform or Bicep deployment
3. Azure Policy / RBAC / Key Vault
4. Azure Lighthouse
5. VPN / routing / network security
6. Azure Firewall
7. Defender for Cloud
8. Sentinel
9. Expanded monitoring and governance
10. Optional advanced edge/private service and AVD scenarios

---

## Notes

Release 2 should remain Azure secure platform focused.

Do not overload it with workload-modernization items that belong to Release 3, such as Docker, AKS, or full application modernization.