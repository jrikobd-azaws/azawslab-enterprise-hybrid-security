# Monitoring and Alerting

## Overview

Release 1 monitoring was implemented as a **baseline operational visibility layer** for identity, device, endpoint security, and access-control monitoring.

This phase was intentionally scoped to establish:

- Microsoft Entra sign-in visibility
- Microsoft Entra audit visibility
- Intune and Entra device visibility
- policy/status monitoring for key endpoint and access controls
- a small example alert/event evidence set

This is **not** presented as a full SIEM, SOC, or enterprise monitoring program.  
Broader centralized cloud security monitoring, analytics, and incident-driven response are deferred to **Release 2**, where Azure Monitor, Microsoft Sentinel, Defender for Cloud, and wider security telemetry will be expanded.

---

## Release 1 Monitoring Objectives

The monitoring baseline for Release 1 was designed to answer the following questions:

- Can pilot user sign-in activity be reviewed?
- Can Conditional Access results be verified from sign-in data?
- Can administrative and configuration changes be traced through audit logs?
- Can enrolled and compliant devices be verified across Entra ID and Intune?
- Can core endpoint policies and security controls be checked for assignment and check-in status?
- Can at least one alert/event-style monitoring view be shown as evidence?

The answer to each of these questions is **yes** based on the evidence collected in this release.

---

## 1. Microsoft Entra Sign-in Monitoring

Microsoft Entra sign-in monitoring was validated using pilot account activity for Release 1 users.

### What was verified

- sign-in logs are available in Microsoft Entra admin center
- pilot-user activity can be filtered by user principal name
- interactive sign-ins are visible
- non-interactive sign-ins are visible
- sign-in detail records expose authentication requirement and status
- Conditional Access results can be reviewed from individual sign-in records

### Evidence captured

Location:

- `screenshots/release1/monitoring/sign-in-logs/`

Files:

- `01-entra-signin-filter-pilot-user.png`
- `02-entra-signin-interactive-overview.png`
- `03-entra-signin-noninteractive-overview.png`
- `04-entra-signin-detail-basic-info.png`
- `05-entra-signin-conditional-access-result.png`

### Observations

The captured sign-in evidence demonstrates that pilot user access activity can be reviewed and correlated with Conditional Access evaluation outcomes.

For the selected pilot sign-in:

- multifactor authentication was required and satisfied
- Conditional Access evaluation showed successful enforcement for relevant policies
- the Microsoft admin portal-specific policy was not applied for the selected SharePoint/Office sign-in, which is expected for that resource path

This provides a valid Release 1 monitoring baseline for identity access verification.

---

## 2. Microsoft Entra Audit Log Monitoring

Administrative and configuration change visibility was validated through Microsoft Entra audit logs.

### What was verified

- audit logs are available in Microsoft Entra admin center
- directory activity is visible and searchable
- group-management events are recorded
- membership updates are recorded
- modified property values can be inspected for individual audit events

### Evidence captured

Location:

- `screenshots/release1/monitoring/audit-logs/`

Files:

- `01-entra-audit-log-overview.png`
- `02-entra-audit-log-add-group-activity.png`
- `03-entra-audit-log-add-member-to-group-activity.png`
- `04-entra-audit-log-modified-properties.png`

### Observations

The audit evidence demonstrates that Release 1 administrative actions can be traced at baseline level, including:

- creation or update of pilot groups
- assignment-related group changes
- membership additions to pilot security groups
- modified properties associated with those changes

This is sufficient for Release 1 to show baseline tenant audit visibility.

---

## 3. Device Visibility Across Entra ID and Intune

Device visibility was validated across both Microsoft Entra ID and Microsoft Intune.

### What was verified

- device inventory is visible in Entra ID
- the Windows corporate pilot device is visible as an Entra device object
- join type, ownership, MDM relationship, and compliance state are visible from Entra device properties
- Intune shows managed-device visibility by platform
- Intune compliance state is visible for the pilot Windows device

### Evidence captured

Location:

- `screenshots/release1/monitoring/device-visibility/`

Files:

- `01-entra-device-object-properties.png`
- `02-entra-all-devices-overview.png`
- `03-intune-devices-platform-overview.png`
- `04-intune-device-compliance-status.png`

### Observations

The captured evidence demonstrates that the pilot managed device can be validated from both identity and management perspectives:

- Entra ID shows the registered/joined device object and ownership details
- Intune shows platform-level managed device inventory
- device compliance status is visible and successfully reported

This gives Release 1 a credible baseline for device-centric monitoring and validation.

---

## 4. Security-Control Status Monitoring

Release 1 also validated the monitorable state of key device and endpoint security controls already implemented elsewhere in the project.

### Controls covered

- Windows Update for Business update ring
- Microsoft Defender Antivirus baseline
- Attack Surface Reduction (ASR) policy
- Windows LAPS policy

### What was verified

- policies are visible in Intune / Endpoint Security or Windows Update management views
- policies are assigned to the intended pilot group
- device and user check-in status is visible where applicable
- policy state can be reviewed from the relevant workload pages

### Evidence captured

Location:

- `screenshots/release1/monitoring/control-status/`

Files:

- `01-update-ring-policy-list.png`
- `02-update-ring-policy-detail-assignment.png`
- `03-defender-av-policy-list.png`
- `04-defender-av-policy-detail-assignment.png`
- `05-asr-policy-list.png`
- `06-asr-policy-device-checkin-status.png`
- `07-laps-policy-list.png`
- `08-laps-policy-device-checkin-status.png`

### Observations

This evidence confirms that Release 1 controls are not just configured but also **monitorable**.

Specifically:

- the update ring is visible with deployment settings and group assignment
- Defender AV policy presence and assignment are visible
- ASR policy has successful device/user check-in status
- LAPS policy has successful device/user check-in status

This is important because Release 1 aims to demonstrate practical implementation plus operational visibility, not only configuration screenshots.

---

## 5. Example Alert / Event Monitoring Evidence

To complete the Release 1 monitoring baseline, one small alert/event evidence set was captured.

### What was used

The example monitoring set uses:

- Intune assignment failures monitoring
- Entra health monitoring baseline
- Intune dashboard configuration warning state

### Evidence captured

Location:

- `screenshots/release1/monitoring/example-alert/`

Files:

- `01-intune-assignment-failures-monitor.png`
- `02-entra-health-monitoring-baseline.png`
- `03-intune-dashboard-device-configuration-alert.png`

### Observations

This evidence does **not** claim that Release 1 contains a mature alerting program.

Instead, it shows that:

- monitoring surfaces exist for identifying assignment/configuration issues
- Microsoft Entra health monitoring provides identity-monitoring scenarios
- Intune dashboard and assignment-failure views expose actionable operational signals

This is the correct scope for a Release 1 baseline.

---

## Monitoring Scope Boundaries

Release 1 monitoring is intentionally limited.

### Included in Release 1

- sign-in visibility
- audit visibility
- device visibility
- endpoint policy/control-state visibility
- example alert/event views

### Deferred to Release 2

- Microsoft Sentinel
- Azure Monitor and Log Analytics expansion
- Defender for Cloud
- broader alert analytics and incident-driven workflows
- centralized cloud/platform telemetry correlation
- deeper reporting and long-term operational dashboards

This separation keeps Release 1 honest and aligned to the actual implementation state.

---

## Key Outcome

Release 1 successfully establishes a **baseline monitoring and alerting capability** across:

- identity access monitoring
- tenant audit monitoring
- device inventory and compliance monitoring
- endpoint control-state monitoring
- small example alert/event evidence

This is sufficient to support the Release 1 objective of demonstrating operational visibility across the implemented Microsoft 365, Entra ID, Intune, and endpoint-security controls.

---

## Evidence Index

### Sign-in monitoring
- `screenshots/release1/monitoring/sign-in-logs/01-entra-signin-filter-pilot-user.png`
- `screenshots/release1/monitoring/sign-in-logs/02-entra-signin-interactive-overview.png`
- `screenshots/release1/monitoring/sign-in-logs/03-entra-signin-noninteractive-overview.png`
- `screenshots/release1/monitoring/sign-in-logs/04-entra-signin-detail-basic-info.png`
- `screenshots/release1/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png`

### Audit monitoring
- `screenshots/release1/monitoring/audit-logs/01-entra-audit-log-overview.png`
- `screenshots/release1/monitoring/audit-logs/02-entra-audit-log-add-group-activity.png`
- `screenshots/release1/monitoring/audit-logs/03-entra-audit-log-add-member-to-group-activity.png`
- `screenshots/release1/monitoring/audit-logs/04-entra-audit-log-modified-properties.png`

### Device visibility
- `screenshots/release1/monitoring/device-visibility/01-entra-device-object-properties.png`
- `screenshots/release1/monitoring/device-visibility/02-entra-all-devices-overview.png`
- `screenshots/release1/monitoring/device-visibility/03-intune-devices-platform-overview.png`
- `screenshots/release1/monitoring/device-visibility/04-intune-device-compliance-status.png`

### Control-state monitoring
- `screenshots/release1/monitoring/control-status/01-update-ring-policy-list.png`
- `screenshots/release1/monitoring/control-status/02-update-ring-policy-detail-assignment.png`
- `screenshots/release1/monitoring/control-status/03-defender-av-policy-list.png`
- `screenshots/release1/monitoring/control-status/04-defender-av-policy-detail-assignment.png`
- `screenshots/release1/monitoring/control-status/05-asr-policy-list.png`
- `screenshots/release1/monitoring/control-status/06-asr-policy-device-checkin-status.png`
- `screenshots/release1/monitoring/control-status/07-laps-policy-list.png`
- `screenshots/release1/monitoring/control-status/08-laps-policy-device-checkin-status.png`

### Example monitoring signals
- `screenshots/release1/monitoring/example-alert/01-intune-assignment-failures-monitor.png`
- `screenshots/release1/monitoring/example-alert/02-entra-health-monitoring-baseline.png`
- `screenshots/release1/monitoring/example-alert/03-intune-dashboard-device-configuration-alert.png`