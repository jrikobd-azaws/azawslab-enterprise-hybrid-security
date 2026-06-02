---
title: Security Architect View
---

# Security Architect View

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
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

This path focuses on identity, network boundaries, private access, evidence handling, and AI governance.

## Security posture at a glance

| Control family | Implementation signal |
|---|---|
| Identity | AD DS, Entra ID, Entra Connect, MFA, Conditional Access, lifecycle operations |
| Endpoint | Intune, Autopilot, compliance, BitLocker, Windows LAPS, recovery scenarios |
| Information protection | Purview DLP, sensitivity and data-protection evidence |
| Network | Hub-spoke, firewall inspection, FortiGate context, VPN/IPSec, BGP, route control |
| IaC security | GitHub Actions OIDC, root-specific workflows, state boundary discipline |
| Private platform | Private AKS, AVD/FSLogix, private endpoints, private DNS, controlled access paths |
| Operations | AWX, monitoring, backup validation, evidence capture |
| AI governance | O6 enclave, deny-by-default tool framing, validation loops, human review |

## Trust-boundary model

```text
User / Admin Access
        |
        v
Identity and device controls
        |
        v
Secure admin workspace / private access path
        |
        v
Hub-spoke network and inspection layer
        |
        +--> Private platform services
        +--> Management and automation plane
        +--> AWS branch / hybrid routing context
        +--> O6 AI operations boundary
```

## Security design decisions

| Decision | Risk addressed |
|---|---|
| OIDC for Terraform workflows | Reduces exposure from long-lived deployment credentials |
| Terraform root separation | Limits blast radius across platform domains |
| Private AKS and private access paths | Reduces public control-plane exposure |
| AVD secure workspace pattern | Separates privileged administration from everyday workstation use |
| Evidence redaction model | Proves capability without publishing secrets, state, keys, or sensitive tenant details |
| O6 human review boundary | Keeps AI as an assistant inside governed engineering workflows |

## Recommended security review path

1. [Architecture Overview](../architecture.md)
2. [Evidence Guide](../evidence-guide.md)
3. [Private AKS and AVD](../engineering/private-aks-avd.md)
4. [AI Operations Enclave](../ai-operations/index.md)
5. [O6 evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6){ target="_blank" }

## Security architect takeaway

The project treats identity, network boundaries, IaC delivery, evidence handling, and AI tool use as connected security architecture concerns.

[Back to Home](../index.md)
