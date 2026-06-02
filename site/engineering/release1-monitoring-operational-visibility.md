# Monitoring and Operational Visibility

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
    The operational visibility model built into Release 1: sign-in review, audit-log analysis, device-state visibility, policy and control review, practical alerting, and Graph-connected PowerShell validation. The evidence is mapped to the public Release 1 monitoring documentation and Release 1 screenshot folders.

Release 1 monitoring is intentionally practical. It does not claim a full enterprise SOC or large-scale observability program. It proves that the environment could be reviewed, interpreted, and operated through Microsoft-native visibility, evidence capture, and script-assisted state review.

## Design decisions

- **Start with native Microsoft visibility** - Release 1 uses Entra ID, Intune, Microsoft 365, Defender, and portal-level operational views before introducing larger monitoring platforms.
- **Review access behavior, not only policy existence** - Conditional Access is more credible when sign-in behavior and grant-control outcomes can be inspected.
- **Track device and control state** - Compliance, device presence, policy status, dashboard views, and endpoint health are treated as operational signals.
- **Capture evidence as part of operations** - Screenshots and script outputs turn review activity into an auditable trail.
- **Use Graph and PowerShell where portals are not enough** - Graph-connected scripts provide repeatable visibility into pilot users, managed devices, and controlled administrative actions.
- **Keep scope honest** - Release 1 proves practical operational visibility. Release 2 expands the model with Sentinel, Azure Monitor, backup evidence, and automation control planes.

## Sign-in visibility

Sign-in monitoring links identity, access policy, and device context into one operational signal.

The Release 1 monitoring evidence includes sign-in-log views showing Conditional Access result visibility. This allows the operator to verify whether access decisions were visible rather than assumed.

| Review question | Evidence signal |
|---|---|
| Are access attempts visible? | Entra sign-in log screenshots. |
| Are Conditional Access outcomes visible? | Sign-in detail views showing Conditional Access result. |
| Are device and access controls connected? | Sign-in records interpreted alongside endpoint and compliance context. |

## Conditional Access result visibility

Conditional Access policies protect the tenant, but this engineering note focuses on verification rather than description.

The monitoring model validates that policy results appear in sign-in records and that access behavior can be reviewed after a user or administrator attempts to access cloud resources.

| Claim | Evidence path | What to verify |
|---|---|---|
| Conditional Access result is visible in sign-in logs. | screenshots/release1/monitoring-and-operations/monitoring/sign-in-logs/ | Sign-in-log screenshot with Conditional Access result. |
| Identity and endpoint context can be interpreted together. | docs/release1/08-monitoring.md and Release 1 screenshots. | Monitoring narrative connects identity, access review, and device-context interpretation. |

## Audit-log visibility

Audit logging provides administrative traceability. It helps confirm that configuration changes, identity actions, and control adjustments are reviewable instead of existing only as remembered activity.

The Release 1 monitoring evidence includes Entra audit-log visibility, showing that operational history can be inspected during support or governance review.

| Claim | Evidence path | What to verify |
|---|---|---|
| Administrative activity is reviewable. | screenshots/release1/monitoring-and-operations/monitoring/audit-logs/ | Entra audit-log overview evidence. |
| Release 1 includes audit visibility as an operational control. | docs/release1/08-monitoring.md | Audit visibility section and related flagship evidence. |

## Device and control visibility

Endpoint trust depends on visibility into the managed estate. Release 1 monitors device presence, compliance state, policy status, dashboard-level control views, and whether the managed estate appears healthy or inconsistent.

This matters because policy existence is not enough. An administrator must be able to see whether devices are present, managed, compliant, and aligned with the expected control state.

| Claim | Evidence path | What to verify |
|---|---|---|
| Device compliance can be reviewed operationally. | screenshots/release1/monitoring-and-operations/monitoring/device-visibility/ | Intune device compliance status evidence. |
| Device and policy state are part of the monitoring model. | docs/release1/08-monitoring.md | Device and control visibility section. |

## Practical alerting

Release 1 does not claim a full enterprise alerting program. It includes practical alert visibility that supports endpoint administration and operational review.

The evidence includes example alerting in the administrative view, showing that the platform was not treated as a static build. Administrators need visibility when device configuration, compliance, or control posture requires attention.

| Claim | Evidence path | What to verify |
|---|---|---|
| Release 1 includes practical alert visibility. | screenshots/release1/monitoring-and-operations/monitoring/example-alert/ | Intune dashboard device configuration alert evidence. |
| Alerting is positioned as supportability, not full SOC maturity. | docs/release1/08-monitoring.md | Alerting and operational awareness section. |

## Graph and PowerShell operational visibility

Release 1 extends portal-based monitoring with Graph-connected PowerShell tooling. This provides repeatable, operator-driven visibility into pilot user state, managed device state, and controlled administrative action.

The validated tooling includes:

- Connect-BelfastMgGraph.ps1 for Graph connection and consent validation.
- Get-BelfastPilotUserState.ps1 for pilot user state review.
- Get-BelfastManagedDeviceState.ps1 for managed device state review.
- Rename-BelfastManagedDevice.ps1 for controlled device rename with dry-run and apply modes.

This matters because modern Microsoft workplace operations increasingly require Graph-aware administration alongside portal review.

| Claim | Evidence path | What to verify |
|---|---|---|
| Graph connection and consent were validated. | screenshots/release1/identity-and-access/identity-operations/graph-powershell/ | Admin consent and successful Connect-MgGraph output. |
| Pilot user state can be queried. | Same folder. | Get-BelfastPilotUserState.ps1 evidence output. |
| Managed device state can be queried. | Same folder. | Get-BelfastManagedDeviceState.ps1 evidence output. |
| Device rename was controlled with dry-run and apply. | Same folder. | Dry-run and apply evidence for Rename-BelfastManagedDevice.ps1. |

See [Graph and PowerShell Operations](graph-powershell-operations.md) for the dedicated operator-tooling note.

## Operational review model

The monitoring discipline is a process, not only a tool choice.

A practical Release 1 review cycle examines:

1. Sign-in logs and Conditional Access outcomes.
2. Audit-log visibility for administrative activity.
3. Device compliance and managed-device state.
4. Policy and control status.
5. Practical alerts that require administrator attention.
6. Graph and PowerShell output where portal visibility is not enough.
7. Evidence captured for future review.

This model is supportable by a single administrator and can mature into the Release 2 monitoring, Sentinel, backup, and automation model.

## Architectural significance

- Proves that operational visibility existed before Release 2 automation and Sentinel maturity.
- Demonstrates a review cadence grounded in real Microsoft 365 and Entra administration.
- Connects dashboard-based review with Graph-connected state queries and controlled administrative action.
- Builds a path from Release 1 manual visibility to Release 2 monitoring, backup, and automation evidence.
- Keeps the scope honest by separating practical monitoring from unsupported claims of a full enterprise SOC.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Sign-in logs were reviewed for access and Conditional Access outcomes. | screenshots/release1/monitoring-and-operations/monitoring/sign-in-logs/ | Conditional Access result visible in sign-in logs. |
| Administrative activity is visible through audit logs. | screenshots/release1/monitoring-and-operations/monitoring/audit-logs/ | Entra audit-log overview evidence. |
| Device compliance and control status are reviewable. | screenshots/release1/monitoring-and-operations/monitoring/device-visibility/ | Intune device compliance status evidence. |
| Practical alert visibility exists for endpoint administration. | screenshots/release1/monitoring-and-operations/monitoring/example-alert/ | Intune dashboard device configuration alert evidence. |
| Graph-connected PowerShell tooling was validated. | screenshots/release1/identity-and-access/identity-operations/graph-powershell/ | Graph consent, connection, pilot user state, managed device state, dry-run rename, and apply rename evidence. |
| Monitoring scope and boundaries are documented. | [Release 1 monitoring documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/08-monitoring.md) | Practical monitoring scope, advanced Graph validation, evidence boundaries, and related documents. |