# Graph and PowerShell Operations

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
    Engineering rationale, implementation signals, and evidence paths for Microsoft Graph PowerShell operations in Release 1. This page focuses on operator-led identity lifecycle actions, managed-device state review, controlled endpoint administration, and the certificate-backed hybrid operations context used elsewhere in the Microsoft 365 environment.

## Operations model

Release 1 uses Microsoft Graph PowerShell to show that the Microsoft hybrid workplace environment can be operated through repeatable tooling, not only through admin portal clicks.

The implemented scope is practical and operator-led:

- Connect to Microsoft Graph with consent and an authenticated operator session.
- Query pilot user state.
- Query managed device state.
- Disable and re-enable a pilot user.
- Revoke active user sessions.
- Update user profile attributes for a mover scenario.
- Validate dynamic group membership and downstream app access.
- Perform controlled managed-device rename with dry-run and apply behavior.
- Maintain certificate-backed Exchange Hybrid operations as part of the wider Microsoft 365 hybrid environment.

This is not presented as a fully automated HR-to-Entra workflow. It is an operator-led engineering toolkit that shows how support actions can be repeatable, reviewable, and evidenced.

## Design decisions

| Design choice | Engineering rationale | Evidence path |
|---|---|---|
| Use Microsoft Graph PowerShell for identity and device operations | Microsoft Graph is the operational interface for Entra ID, Intune, and Microsoft 365 state. PowerShell makes those operations repeatable for support and engineering workflows. | [Release 1 monitoring documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/08-monitoring.md) |
| Capture consent and connection evidence before demonstrating actions | Shows that permissions and operator context were part of the implementation rather than hidden behind a script. | [Graph admin consent evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/03-graph-admin-consent-enable-disable-user-accounts.png) |
| Use dry-run and apply patterns where actions mutate state | Reduces risk during administrative operations and makes the evidence easier to review. | [Device rename dry-run evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/01-rename-managed-device-dry-run-desktop-cdniaqb-to-win11-bel-02.png) |
| Keep lifecycle validation operator-led | Preserves technical accuracy: the evidence shows controlled support tooling, not a complete HR-driven joiner-mover-leaver platform. | [Hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) |
| Treat certificates as part of the wider hybrid operations boundary | The Microsoft 365 hybrid environment includes certificate-backed Exchange Hybrid operations using a Let's Encrypt certificate, while Microsoft Graph PowerShell evidence remains tied to the documented consent and connection flow. | [Release 1 documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release1) and [Release 1 screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1) |

## Graph connection and permission boundary

The Microsoft Graph operational layer begins with connection and consent. Release 1 evidence captures delegated permission awareness and successful Microsoft Graph connection before later state queries and changes are demonstrated.

| Capability | Implementation signal | Evidence path |
|---|---|---|
| Admin consent | Required delegated permissions are visible before lifecycle and device operations are demonstrated. | [Graph admin consent evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/03-graph-admin-consent-enable-disable-user-accounts.png) |
| Graph connection | `Connect-BelfastMgGraph.ps1` establishes an authenticated Microsoft Graph session for later operations. | [Connect-MgGraph success evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/06-connect-mggraph-success-admin-mw01.png) |

## Operational visibility scripts

The first operational pattern is state review. These scripts make identity and device state visible from PowerShell so the administrator is not dependent on portal navigation alone.

| Script | Purpose | Evidence path |
|---|---|---|
| `Get-BelfastPilotUserState.ps1` | Queries pilot user properties such as account state, department, job title, and license-related context. | [Pilot user state evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/07-pilot-user-state-script-result-pilot-win01.png) |
| `Get-BelfastManagedDeviceState.ps1` | Queries managed device state, including compliance, management status, operating system version, and last check-in context. | [Managed device state evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png) |

These scripts support the same operational model used in the rest of the Release 1 evidence: review current state, act deliberately, and capture output.

## Controlled endpoint action: managed-device rename

The managed-device rename workflow is the clearest endpoint operation in this page. It was used after Autopilot validation surfaced a naming inconsistency.

The workflow demonstrates:

1. The device is already enrolled and visible.
2. The proposed rename is previewed first.
3. The rename is applied through Microsoft Graph PowerShell.
4. The result is captured as evidence.

| Operation | Implementation signal | Evidence path |
|---|---|---|
| Dry run | Rename operation is previewed before mutation. | [Device rename dry-run evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/01-rename-managed-device-dry-run-desktop-cdniaqb-to-win11-bel-02.png) |
| Apply | Rename operation is applied after review. | [Device rename apply evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png) |

This is a practical engineering signal: endpoint operations do not end when Autopilot or Intune enrollment completes. It includes post-enrollment administrative refinement.

## Identity lifecycle operations

Microsoft Graph PowerShell also supports user lifecycle validation. These scenarios connect identity engineering and operations through controlled access-state changes and business-facing mover behavior.

| Lifecycle scenario | Implementation signal | Evidence path |
|---|---|---|
| Disable user | Pilot user account is disabled through an operator-led Graph PowerShell workflow. | [Disable user evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/02-user-access-disable-apply-pilot-win02.png) |
| Revoke sessions | Active sessions are revoked to force access removal. | [Session revoke evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/05-user-session-revoke-apply-pilot-win02.png) |
| Profile update | User department and job-title attributes are updated through an interactive Graph PowerShell workflow. | [Profile update evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/14-profile-update-apply-result-finance-analyst-belfast-pilot-win02.png) |
| Dynamic group outcome | Department change results in membership of the Operations-linked Slack group. | [Operations Slack group evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/22-user-groups-operations-slack-membership-pilot-win02.png) |
| Downstream app access | Slack becomes available in the user's My Apps portal after the group membership change. | [My Apps Slack evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) |

## Certificate-backed hybrid operations context

The Microsoft 365 hybrid environment also includes certificate-backed Exchange Hybrid operations using a Let's Encrypt certificate.

That certificate work is part of the wider Release 1 hybrid operations story, but it should not be confused with the Microsoft Graph PowerShell connection pattern shown above. Microsoft Graph operations are documented through consent, connection, and script-output evidence. Exchange Hybrid certificate handling is a separate Microsoft 365 hybrid operations control that supports secure hybrid service communication.

This separation matters to reviewers:

- Microsoft Graph PowerShell proves repeatable identity and endpoint administration.
- Exchange Hybrid certificate handling proves operational management of secure Microsoft 365 hybrid connectivity.
- Both belong to Release 1, but they represent different control boundaries.

## Structured-input operating pattern

The evidenced scripts are operator-led and scoped to pilot scenarios. The same engineering pattern can be extended when bulk input is required.

A mature bulk-operation pattern would use:

- A CSV or approved input file as the declaration of intent.
- A preview or dry-run stage before mutation.
- Row-level validation before calling Microsoft Graph.
- Per-object success and failure logging.
- Captured output that can be reviewed after execution.
- Human approval before production changes.

This section is a design pattern, not a claim that a complete bulk HR or device-lifecycle system has been implemented. It documents how the evidenced Microsoft Graph PowerShell approach can scale without losing reviewability.

## Engineering significance

Graph and PowerShell Operations shows four practical engineering decisions:

1. The environment can be queried and operated programmatically, not only through portals.
2. Mutating actions use controlled operator-led patterns such as consent, preview, apply, and verification.
3. Identity and endpoint operations are connected: user state, device state, and access outcomes are visible through the same operational discipline.
4. Certificate-backed Exchange Hybrid operations are treated as part of the Microsoft 365 hybrid operating model without conflating them with Graph authentication.

This makes the Release 1 workplace environment stronger because it is not static. It can be reviewed, interpreted, adjusted, and maintained through repeatable operational tooling.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Microsoft Graph PowerShell is part of Release 1 monitoring and operations | [Monitoring documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/08-monitoring.md) | Microsoft Graph PowerShell operational tooling section |
| Graph connection and admin consent were captured | [Graph admin consent evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/03-graph-admin-consent-enable-disable-user-accounts.png) and [Connect-MgGraph evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/06-connect-mggraph-success-admin-mw01.png) | Delegated permissions and successful Graph connection |
| Pilot user state can be queried with Microsoft Graph PowerShell | [Pilot user state evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/07-pilot-user-state-script-result-pilot-win01.png) | User state output from script |
| Managed device state can be queried with Microsoft Graph PowerShell | [Managed device state evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png) | Device state output from script |
| Managed-device rename uses dry-run and apply behavior | [Rename dry-run evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/01-rename-managed-device-dry-run-desktop-cdniaqb-to-win11-bel-02.png) and [rename apply evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png) | Preview-before-mutation and successful apply |
| Identity lifecycle operations were validated through Microsoft Graph PowerShell | [Hybrid identity documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release1/01-hybrid-identity.md) | Access-state and mover scenario sections |
| User lifecycle outcomes produced downstream access results | [Operations Slack group evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/22-user-groups-operations-slack-membership-pilot-win02.png) and [My Apps Slack evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/screenshots/release1/identity-and-access/identity-operations/lifecycle/23-myapps-slack-available-pilot-win02-operations-state.png) | Dynamic group and downstream application access outcome |
| Exchange Hybrid certificate handling is part of the Release 1 Microsoft 365 hybrid operations story | [Release 1 documentation](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release1) and [Release 1 screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1) | Exchange Hybrid and certificate-backed secure hybrid operations evidence |

## Review takeaway

Graph and PowerShell Operations shows that Release 1 was not only configured; it was operated.

The page shows the working pattern expected from an experienced Microsoft cloud engineer: connect with appropriate permissions, inspect state, preview change, apply deliberately, verify outcome, preserve evidence, and maintain the certificate-backed Microsoft 365 hybrid operations boundary.
