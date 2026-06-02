# Hybrid Identity Engineering

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
    Engineering rationale, configuration decisions, and evidence paths for the hybrid identity layer that connects on-premises Active Directory to Microsoft Entra ID. The evidence maps to public-safe Release 1 documentation, screenshots, and Graph PowerShell validation artifacts.

## Identity model

Release 1 uses on-premises Active Directory as the authoritative identity source and Microsoft Entra ID as the cloud identity and access layer.

The implementation deliberately avoids a broad, uncontrolled synchronization model. Entra Connect Sync was introduced through a pilot-first scope so selected users and objects could be validated before the wider platform depended on cloud identity state.

| Design choice | Engineering rationale | Evidence path |
|---|---|---|
| Active Directory remains the source of authority | Keeps the project aligned to a realistic Microsoft hybrid enterprise environment rather than a cloud-only tenant demo. | [Hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) |
| Entra Connect Sync uses controlled pilot filtering | Reduces synchronization risk and proves that cloud identity was introduced through scoped inclusion rather than bulk replication. | [Entra Connect filtering evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/entra-sync/11-entra-connect-filtering-users-devices.png) |
| Password Hash Synchronization supports cloud authentication | Provides a supportable hybrid authentication path for Microsoft 365 and downstream Release 1 validation. | [Hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) |
| Pilot users are validated in Microsoft 365 | Confirms that synchronized identities are visible and usable for downstream Microsoft 365, Exchange Hybrid, and endpoint management work. | [Pilot users in Microsoft 365](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/entra-sync/15-m365-active-users-pilot-synced.png) |

## Access-control baseline

Hybrid identity is only useful when it is connected to policy. Release 1 ties synchronized identity state to Conditional Access, MFA, SSPR, pilot group design, and operational sign-in visibility.

| Control area | Implementation signal | Evidence path |
|---|---|---|
| Conditional Access | Access policy is visible through sign-in evaluation rather than described only as a design intent. | [Conditional Access result evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png) |
| MFA and SSPR | Identity hardening and supportability are part of the Release 1 access model. | [Hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) |
| Pilot users and groups | Pilot scope, administrator identities, and group design support controlled validation rather than unrestricted tenant-wide rollout. | [Identity and Access Evidence Hub](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1/identity-and-access) |

## Graph PowerShell lifecycle validation

Release 1 extends beyond synchronization and portal configuration. Later validation added Microsoft Graph API and PowerShell workflows for operator-led identity lifecycle actions.

This proves the identity layer can be administered through repeatable tooling, not only through manual portal changes.

The validated lifecycle scenarios are:

- Disable a pilot user account.
- Revoke active user sessions.
- Restore the user account to active state.
- Update user profile attributes for a mover scenario.
- Trigger dynamic group recalculation from a department change.
- Validate downstream application access through the user's My Apps experience.

| Lifecycle capability | Implementation signal | Evidence path |
|---|---|---|
| Graph admin consent | Required delegated permissions were explicitly captured before lifecycle operations were demonstrated. | [Graph admin consent for user enable and disable](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/03-graph-admin-consent-enable-disable-user-accounts.png) |
| Disable user | Graph PowerShell output confirms the pilot account was disabled through an operator-led workflow. | [User access disable apply result](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/02-user-access-disable-apply-pilot-win02.png) |
| Revoke sessions | Graph PowerShell output confirms active sessions were revoked to force access removal. | [User session revoke apply result](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/05-user-session-revoke-apply-pilot-win02.png) |
| Profile update | An interactive Graph PowerShell workflow updates the user's department and job title as part of the mover scenario. | [Profile update apply result](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/14-profile-update-apply-result-finance-analyst-belfast-pilot-win02.png) |
| Dynamic group recalculation | The user moves into the Operations-linked Slack group after the department change. | [Operations Slack group membership](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/22-user-groups-operations-slack-membership-pilot-win02.png) |
| Downstream access outcome | Slack becomes available in My Apps after the department-driven group membership change. | [Slack available in My Apps](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) |

## Engineering significance

This identity layer proves three engineering decisions:

1. Hybrid identity was introduced through controlled scope rather than broad synchronization.
2. Access policy was connected to real sign-in and operational visibility.
3. Identity administration was extended with Graph PowerShell lifecycle validation, including disable, session revoke, restore, mover, dynamic group, and application access outcomes.

Together, these signals show a practical identity engineering model: directory authority, synchronization control, access enforcement, operational visibility, and repeatable lifecycle actions.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Active Directory remains the source of authority while Entra ID provides cloud identity and access | [Hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) | Identity design approach and implementation story |
| Entra Connect Sync was introduced through pilot filtering | [Entra Connect filtering evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/entra-sync/11-entra-connect-filtering-users-devices.png) | Filtering and controlled synchronization scope |
| Pilot users appeared in Microsoft 365 after synchronization | [Pilot users in Microsoft 365](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/entra-sync/15-m365-active-users-pilot-synced.png) | Synchronized pilot users visible in Microsoft 365 |
| Conditional Access was visible in sign-in results | [Conditional Access result evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png) | Conditional Access evaluation in sign-in logs |
| Graph PowerShell lifecycle actions were validated | [Release 1 hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) | Access-state and mover scenario sections |
| User disable and session revoke were executed through Graph PowerShell | [Disable evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/02-user-access-disable-apply-pilot-win02.png) and [session revoke evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/05-user-session-revoke-apply-pilot-win02.png) | Script output showing access-state control |
| Department change triggered group and application access outcomes | [Operations Slack group evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/22-user-groups-operations-slack-membership-pilot-win02.png) and [My Apps Slack evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) | Dynamic group membership and downstream application availability |

## Review takeaway

Hybrid Identity Engineering demonstrates controlled synchronization, access-policy enforcement, Microsoft 365 identity readiness, and practical Graph PowerShell lifecycle administration.

This identity layer supports the rest of the portfolio: Microsoft 365 operations, endpoint management, secure AVD access, administrative workflows, and later platform operations.