# Modern Endpoint Management

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-identity/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Workplace</span>
  </a>
  <a class="portfolio-chip" href="/engineering/terraform-state-boundaries/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Delivery</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-multicloud-networking/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Network</span>
  </a>
  <a class="portfolio-chip" href="/engineering/private-aks-platform/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform</span>
  </a>
  <a class="portfolio-chip" href="/engineering/automation-control-plane/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Operations</span>
  </a>
</div>

!!! summary "Scope"
    Endpoint lifecycle notes for Release 1: Intune onboarding, Autopilot validation, compliance evaluation, BitLocker, Windows LAPS, and recovery readiness.

## Endpoint management model

Release 1 treats endpoint management as a lifecycle: enroll, evaluate, protect, recover, and support.

The implementation starts with enrollment and device visibility, then moves into compliance, protection, recovery readiness, and operational follow-up. A device is not trusted simply because it appears in a management portal. It has to be enrolled, evaluated, protected, recoverable, and supportable.

| Design choice | Why it matters | Evidence route |
|---|---|---|
| Intune is the endpoint management plane | Provides enrollment visibility, ownership distinction, policy assignment, compliance state, and a path into monitoring and recovery workflows. | [Endpoint enrollment documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/04-endpoint-enrollment.md) |
| Ownership-aware enrollment is represented | Corporate Windows, Windows BYOD, iPhone BYOD, and Ubuntu Linux are treated as separate onboarding paths, not one generic device flow. | [Endpoint Management Evidence Hub](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/endpoint-management) |
| Autopilot and ESP are advanced validation added after baseline | Keeps the sequence accurate: the managed-device baseline was later extended into modern Windows provisioning. | [Endpoint enrollment documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/04-endpoint-enrollment.md) |
| Compliance and hardening are separate from enrollment | Keeps device registration separate from trusted-device status. | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) |

## Enrollment and provisioning

The endpoint model brings multiple device and ownership types into one managed estate. Autopilot and Enrollment Status Page then extend that model into modern Windows provisioning.

| Capability | Validation signal | Evidence route |
|---|---|---|
| Corporate Windows enrollment | Corporate Windows device reaches a managed and compliant state in Intune. | [Corporate Windows compliant evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png) |
| Corporate and BYOD visibility | Corporate and personal Windows devices are visible in the same managed estate while preserving ownership distinction. | [Corporate and BYOD visibility evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-windows-byod/05-intune-windows-devices-corp-and-byod.png) |
| Autopilot deployment profile | Autopilot is configured through a defined deployment profile and pilot assignment path. | [Autopilot deployment profile evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/02-autopilot-deployment-profile-review-r1-autopilot-corp-belfast.png) |
| Enrollment Status Page | ESP is configured to show a controlled provisioning experience rather than stopping at device registration. | [ESP profile evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/03-enrollment-status-page-profile-review-r1-esp-corp-belfast.png) |
| Device import and assignment | Autopilot pilot device import and profile assignment are captured before the user-facing provisioning flow. | [Autopilot import and assignment evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/07-autopilot-device-imported-profile-assigned-belfast-pilot.png) |
| ESP execution | The provisioning path reaches visible ESP device preparation rather than remaining a configuration-only claim. | [ESP execution evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png) |

## Compliance and endpoint protection

Enrollment establishes management; compliance and protection establish endpoint trust.

Release 1 moves beyond device visibility with compliance policy, security baselines, Defender Antivirus, Attack Surface Reduction, BitLocker-related controls, Windows Update for Business, and Windows LAPS.

| Control area | Validation signal | Evidence route |
|---|---|---|
| Compliance evaluation | Device state is evaluated and surfaced through Intune rather than assumed from enrollment alone. | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) |
| Security baseline | Managed Windows endpoints receive security baseline hardening rather than relying on default settings. | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) |
| Defender Antivirus | Endpoint protection readiness is part of the managed Windows control model. | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) |
| Attack Surface Reduction | ASR policy coverage strengthens endpoint hardening and reduces common attack paths. | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) |
| BitLocker readiness | BitLocker-related controls and recovery-key visibility support recoverability and access continuity. | [Recovery scenarios documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/06-recovery-scenarios.md) |
| Windows LAPS | LAPS policy, retrieval validation, and post-Autopilot remediation support local administrator recovery readiness. | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) |

## Operational follow-up

The endpoint management model includes operational follow-up after provisioning. This is important because endpoint management rarely ends with a clean first-pass enrollment.

Release 1 documents two practical follow-up patterns:

- Managed-device rename support after provisioning.
- LAPS remediation after Autopilot validation exposed targeting behavior that needed correction.

Microsoft Graph PowerShell is part of this operational layer. It supports device-state visibility and administrative refinement after enrollment, tying endpoint management back to the identity operations model.

## Integration with identity and access

Endpoint management is connected to the Release 1 identity layer. Device state, compliance posture, BitLocker readiness, and LAPS supportability all influence whether the environment can treat a device as trusted.

Release 1 does not present endpoint management as a standalone Intune configuration exercise. It connects:

- User identity.
- Device enrollment.
- Ownership model.
- Compliance evaluation.
- Endpoint hardening.
- Recovery readiness.
- Operational remediation.

That is the control loop for reviewers to inspect.

## Engineering significance

Modern Endpoint Management shows four engineering decisions:

1. Endpoint onboarding was implemented as a managed lifecycle, not a registration screenshot.
2. Autopilot and ESP were added as advanced validation without rewriting the earlier implementation history.
3. Compliance, Defender, ASR, BitLocker, Windows Update, and Windows LAPS were used to move from enrolled device to trusted device.
4. Operational follow-up through Microsoft Graph PowerShell, rename handling, and Windows LAPS remediation was documented rather than hidden.

Together, these signals show a practical endpoint engineering model: enrollment, provisioning, evaluation, hardening, recovery readiness, and operational support.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Release 1 includes endpoint onboarding across device and ownership types | [Endpoint enrollment documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/04-endpoint-enrollment.md) | Corporate Windows, Windows BYOD, iPhone BYOD, Ubuntu Linux, and Intune visibility |
| Corporate Windows endpoint reached compliant state | [Corporate Windows compliant evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-windows-corp/08-intune-windows-device-compliant.png) | Intune managed state and compliance result |
| Corporate and BYOD devices are visible in the managed estate | [Corporate and BYOD visibility evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-windows-byod/05-intune-windows-devices-corp-and-byod.png) | Ownership-aware device visibility |
| Autopilot deployment profile was configured | [Autopilot deployment profile evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/02-autopilot-deployment-profile-review-r1-autopilot-corp-belfast.png) | Deployment profile and pilot provisioning path |
| ESP was configured and reached visible provisioning progress | [ESP profile evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/03-enrollment-status-page-profile-review-r1-esp-corp-belfast.png) and [ESP execution evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/endpoint-management/intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png) | ESP configuration and device preparation state |
| Compliance, baseline hardening, Defender, ASR, BitLocker, Windows Update, and LAPS are part of the endpoint control model | [Endpoint compliance and security documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/05-endpoint-compliance-and-security.md) | Control model and implemented policy areas |
| Recovery scenarios connect endpoint controls to operational support | [Recovery scenarios documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/06-recovery-scenarios.md) | BitLocker recovery, trust-break handling, stale-record cleanup, and restored compliance |
| Endpoint evidence is browsable from the public screenshot tree | [Endpoint Management Evidence Hub](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/endpoint-management) | Intune evidence structure and supporting screenshots |

## Review takeaway

Modern Endpoint Management shows that Release 1 managed endpoints as operational assets: enrolled, evaluated, protected, recoverable, and supportable.

This endpoint layer supports the rest of the portfolio: Conditional Access decisions, Microsoft 365 access, BitLocker recovery, Windows LAPS administration, AVD access patterns, and later platform operations.
