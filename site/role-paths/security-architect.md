# Security Architect Pathway

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value portfolio-chip-value-ready">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/proof-gallery/">
    <span class="portfolio-chip-label">Proof</span>
    <span class="portfolio-chip-value">Gallery</span>
  </a>
  <a class="portfolio-chip" href="/skills-matrix/">
    <span class="portfolio-chip-label">Skills</span>
    <span class="portfolio-chip-value">Matrix</span>
  </a>
</div>

!!! summary "Purpose of this page"
    A technical review guide for security architects. It organises the platform's security controls by lifecycle domain and highlights where to validate identity governance, endpoint protection, network inspection, private access, operational resilience, and AI safety.

## Security review framework

AzAWSLab embeds security controls across identity, endpoint, delivery, network, platform services, operations, and AI governance. This pathway maps each security domain to engineering notes and public-safe evidence routes without treating security as a separate bolt-on layer.

---

## 1. Hybrid Identity and Access Governance

**What to validate:** Identity synchronisation, Conditional Access enforcement, Microsoft 365 service access, and hybrid credential protection.

| Control area | Engineering note | Evidence route |
|---|---|---|
| Entra Connect, pilot identity scope, Conditional Access, MFA, and identity operations | [Hybrid Identity Engineering](/engineering/hybrid-identity/) | Release 1 identity and access evidence |
| Exchange Hybrid and Microsoft 365 security posture | [Exchange Hybrid and M365 Services](/engineering/exchange-hybrid-m365-services/) | Release 1 modern workplace and Exchange evidence |
| Operational sign-in and audit visibility | [Monitoring and Operational Visibility](/engineering/release1-monitoring-operational-visibility/) | Release 1 monitoring and operations evidence |

### Security validation checklist

- Validate that identity synchronisation scope and access controls are evidenced.
- Inspect Conditional Access, sign-in visibility, and device compliance context.
- Review Microsoft 365 service access as part of the identity and workplace boundary.
- Confirm that identity operations are repeatable through documented evidence routes.

---

## 2. Endpoint Security and Information Protection

**What to validate:** Device provisioning, compliance enforcement, local privilege management, encryption, and data protection.

| Control area | Engineering note | Evidence route |
|---|---|---|
| Intune, Autopilot, compliance, Defender, BitLocker, and Windows LAPS | [Modern Endpoint Management](/engineering/modern-endpoint-management/) | Release 1 endpoint-management evidence |
| Microsoft Purview, sensitivity labels, DLP, and retention context | [Modern Endpoint Management](/engineering/modern-endpoint-management/) | Release 1 information-protection evidence |
| Graph and PowerShell state review | [Graph and PowerShell Operations](/engineering/graph-powershell-operations/) | Release 1 scripts and Graph evidence |

### Security validation checklist

- Validate that device compliance is connected to access decisions.
- Inspect encryption, local administrator management, and recovery evidence.
- Review information protection controls as part of the Microsoft 365 operating model.
- Confirm that script-based operations support repeatable security review.

---

## 3. CI/CD and Infrastructure Delivery Security

**What to validate:** Secret-less delivery, infrastructure change control, traceability, and Terraform state isolation.

| Control area | Engineering note | Evidence route |
|---|---|---|
| GitHub Actions OIDC and workflow-controlled delivery | [GitHub Actions OIDC](/engineering/github-actions-oidc/) | Release 2 OIDC and workflow evidence |
| Source, workflow, documentation, and proof traceability | [Code Traceability](/engineering/code-traceability/) | Traceability evidence and proof routes |
| Terraform root boundaries and state isolation | [Terraform State Boundaries](/engineering/terraform-state-boundaries/) | Terraform source, state-boundary documentation, and evidence index |

### Security validation checklist

- Validate that delivery reduces reliance on long-lived credentials.
- Inspect how infrastructure changes are linked to source and workflow evidence.
- Review Terraform state boundaries as a blast-radius control.
- Confirm that delivery governance is visible to reviewers.

---

## 4. Network Security and Inspection

**What to validate:** Hub-spoke enforcement, forced routing, NVA inspection, IPSec/BGP security, AWS branch integration, and private access patterns.

| Control area | Engineering note | Evidence route |
|---|---|---|
| Hub-spoke routing, Azure Firewall, route control, and network boundaries | [Hybrid Multi-Cloud Networking](/engineering/hybrid-multicloud-networking/) | Release 2 network evidence |
| FortiGate NVA inspection and inspected traffic path | [Secure Transmission and Inspection](/engineering/secure-transmission-inspection/) | Inspection-path and firewall-validation evidence |
| IPSec, BGP, AWS branch routing, and route validation | [Hybrid BGP Multi-Cloud Transit](/engineering/hybrid-bgp-multicloud-transit/) | VPN, BGP, and AWS branch evidence |

### Security validation checklist

- Validate that traffic paths are controlled through routing and inspection.
- Inspect evidence for IPSec, BGP, and AWS branch routing.
- Review how network security controls are embedded into the routing design.
- Confirm that private access patterns reduce public exposure.

---

## 5. Private Compute and Secure Administration

**What to validate:** Private AKS, secure AVD workspace, and their inspected integration.

| Control area | Engineering note | Evidence route |
|---|---|---|
| Private AKS, controlled access, Kubernetes manifests, and policy context | [Private AKS Platform](/engineering/private-aks-platform/) | O4 evidence and Kubernetes source |
| AVD secure workspace, FSLogix, private access, and compliance context | [AVD Secure Workspace](/engineering/avd-secure-workspace/) | O5 evidence and private platform documentation |
| AKS and AVD private platform integration | [Private AKS and AVD Architecture](/engineering/private-aks-avd/) | Integration evidence and inspected path validation |

### Security validation checklist

- Validate that AKS and AVD are designed as private platform services.
- Inspect how platform administration avoids unnecessary public exposure.
- Review private endpoint and access-path evidence where implemented.
- Confirm that AKS and AVD integration preserves inspection and control boundaries.

---

## 6. Operational Resilience and Monitoring

**What to validate:** Monitoring, alert validation, Defender for Cloud, Sentinel, backup controls, soft-delete handling, and BCDR.

| Control area | Engineering note | Evidence route |
|---|---|---|
| Azure Monitor, Sentinel, Defender for Cloud, and alert validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Release 2 monitoring and alert evidence |
| Recovery Services Vault controls, backup policies, soft-delete handling, and recovery validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Backup, BCDR, and resilience evidence |
| Automation runbooks and operational execution | [Automation Control Plane](/engineering/automation-control-plane/) | Ansible, AWX, and job execution evidence |

### Security validation checklist

- Validate that monitoring controls are evidenced through operation, not only configuration.
- Inspect backup controls and recovery evidence as part of resilience.
- Review soft-delete handling and BCDR documentation.
- Confirm that automation execution is governed and reviewable.

---

## 7. AI Operations Governance

**What to validate:** Policy-mediated tool use, human approval boundaries, decision traces, and safe local development patterns.

| Control area | Engineering note | Evidence route |
|---|---|---|
| AI operations enclave, policy boundary, evidence capture, and human approval | [AI Operations Enclave](/ai-operations/) | O6 evidence and AI operations documentation |
| Companion local AI lab for reproducible agent workflows | [Companion Project](/companion-project/) | `local-ai-lab-infra` repository and companion project page |

### Security validation checklist

- Validate that AI-assisted operations are bounded by policy and approval.
- Inspect O6 evidence for policy boundaries and decision traces.
- Review the companion local AI lab as a controlled development pattern.
- Confirm that AI is framed as governed assistance, not autonomous infrastructure automation.

---

## Suggested review path

1. Start with the [Proof Gallery](/proof-gallery/) to understand evidence scope.
2. Review the [Skills Matrix](/skills-matrix/) using the security-control lens.
3. Drill into individual engineering pages for design rationale and evidence maps.
4. Cross-check network controls in [Hybrid BGP Multi-Cloud Transit](/engineering/hybrid-bgp-multicloud-transit/) and [Secure Transmission and Inspection](/engineering/secure-transmission-inspection/).
5. Validate AI safety claims in the [AI Operations Enclave](/ai-operations/).
