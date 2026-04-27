# Monitoring and Operations Evidence Hub

## Purpose

This page is the guided evidence index for the monitoring and operations portion of the implemented platform. It exists to make the screenshot archive easier to review by grouping evidence into the main visibility areas:

- **sign‑in logs** – access and Conditional Access outcomes
- **audit logs** – administrative traceability
- **device visibility** – compliance and control status
- **alert visibility** – example operational alerts
- **Graph PowerShell operational scripts** – programmatic user and device state visibility (advanced validation)

This page should be read as an evidence hub, not as a narrative implementation document.

---

## What This Evidence Set Proves

The monitoring and operations evidence demonstrates that the platform was designed to be observed and supported, not just configured and left alone.

The baseline evidence validates:
- sign‑in visibility linked to access decisions
- audit trails for administrative actions
- device‑state visibility for compliance and troubleshooting
- practical alert visibility for day‑to‑day support

**Advanced validation (added after baseline) adds:**
- Graph/PowerShell scripts that provide programmatic user and device state visibility
- safe, operator‑led device rename via Graph API (dry‑run + apply)

This combination of portal visibility and scriptable, automation‑ready tooling directly supports helpdesk and L3 engineering workflows.

---

## How to Use This Hub

Use this page in one of three ways:
- **Start with flagship proof** – the shortest route to the strongest screenshots
- **Browse by monitoring area** – evidence grouped by logs, visibility, alerts, or scripts
- **Follow the related docs** – the implementation story behind the evidence

This hub is designed to reduce click fatigue while still giving access to the wider screenshot archive underneath each folder.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Conditional Access result visibility** | Access‑control outcome visible in sign‑in logs | [Conditional Access result in sign‑in logs](monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png) |
| **Audit log overview** | Administrative activity is reviewable and traceable | [Entra audit log overview](monitoring/audit-logs/01-entra-audit-log-overview.png) |
| **Device compliance status** | Managed endpoint health visible at a glance | [Intune device compliance status](monitoring/device-visibility/03-intune-device-compliance-status.png) |
| **Example alert** | Platform supports proactive configuration awareness | [Intune dashboard device configuration alert](monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png) |
| **Graph PowerShell managed device state** | Script‑driven device compliance and management status | [Managed device state script result](../identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png) |
| **Graph PowerShell rename device** | Safe, script‑based device rename via Graph API | [Rename device apply success](../identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png) |

---

## Evidence by Monitoring Area

### 1. Sign‑In Visibility

This area contains one of the strongest identity‑access proofs. It supports:
- Conditional Access outcome review
- device‑context interpretation
- operational investigation

**Start here:** [Sign‑In Logs Folder](monitoring/sign-in-logs/)

**Best evidence:** [Conditional Access result in sign‑in logs](monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)

**Related docs:** [Monitoring – Sign‑In Review](../../../docs/release1/08-monitoring.md)

### 2. Audit Visibility

This area shows that administrative actions leave a traceable history. It supports:
- change traceability
- governance credibility
- support investigation

**Start here:** [Audit Logs Folder](monitoring/audit-logs/)

**Best evidence:** [Entra audit log overview](monitoring/audit-logs/01-entra-audit-log-overview.png)

**Related docs:** [Monitoring – Audit Visibility](../../../docs/release1/08-monitoring.md)

### 3. Device and Control Visibility

This area proves that the endpoint estate can be reviewed for health and compliance. It supports:
- compliance‑state evaluation
- policy visibility
- operational dashboards

**Start here:** [Device Visibility Folder](monitoring/device-visibility/)

**Best evidence:** [Intune device compliance status](monitoring/device-visibility/03-intune-device-compliance-status.png)

**Related docs:** [Monitoring – Device Visibility](../../../docs/release1/08-monitoring.md)

### 4. Alert Visibility

This area shows that the platform supports practical administrative awareness. It supports:
- day‑to‑day supportability
- detection of configuration drift
- proactive endpoint administration

**Start here:** [Example Alert Folder](monitoring/example-alert/)

**Best evidence:** [Intune dashboard device configuration alert](monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png)

**Related docs:** [Monitoring – Alerting](../../../docs/release1/08-monitoring.md)

### 5. Graph PowerShell Operational Scripts (Advanced Validation)

This area demonstrates programmatic, script‑driven visibility and control over user and device state – critical for helpdesk and L3 support scenarios where portal access is not the primary workflow. It supports:
- Graph API permission scoping (admin consent screens)
- user state queries (`Get-BelfastPilotUserState.ps1`)
- managed device state queries (`Get-BelfastManagedDeviceState.ps1`)
- device rename, executed via Graph API with a safety‑conscious dry‑run → apply pattern (`Rename-BelfastManagedDevice.ps1`)

**Start here:** [`../identity-and-access/identity-operations/graph-powershell/`](../identity-and-access/identity-operations/graph-powershell/)

**Best evidence:**
- [Connect-MgGraph success](../identity-and-access/identity-operations/graph-powershell/06-connect-mggraph-success-admin-mw01.png)
- [Managed device state script result](../identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png)
- [Rename device apply success](../identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png)

**Related docs:**
- [Monitoring (Graph/PowerShell section)](../../../docs/release1/08-monitoring.md)
- [Skills and Evidence Index (Graph API row)](../../../docs/foundation/05-skills-and-evidence-index.md)

---

## Recommended Review Path

For the fastest high‑value path through the monitoring and operations evidence (including Graph PowerShell advanced validation), use this order:

1. [Conditional Access result in sign‑in logs](monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)
2. [Entra audit log overview](monitoring/audit-logs/01-entra-audit-log-overview.png)
3. [Intune device compliance status](monitoring/device-visibility/03-intune-device-compliance-status.png)
4. [Intune dashboard device configuration alert](monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png)
5. [Managed device state script result](../identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png)
6. [Rename device apply success](../identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png)

This sequence gives the fastest view of:
- access‑control visibility
- administrative traceability
- endpoint health at a glance
- proactive alerting
- programmatic device state awareness
- safe, script‑based device management

---

## Relationship to the Documentation

Use the **documentation** when you want:
- monitoring architecture
- design rationale for visibility controls
- relationship to identity and endpoint trust
- how monitoring supports recovery

Use this **evidence hub** when you want:
- direct proof of sign‑in and Conditional Access visibility
- direct proof of audit logs
- direct proof of device‑state visibility
- direct proof of alert examples
- direct proof of Graph PowerShell operational scripts

**Best related reading path:** [Monitoring](../../../docs/release1/08-monitoring.md)

---

## Scope Boundaries

The monitoring evidence set is strong for the implemented scope, but it does **not** claim a full enterprise‑grade SIEM, SOC, or real‑time detection and response stack.

Examples of intentionally limited or deferred areas include:
- full Microsoft Sentinel integration (deferred to Release 2)
- real‑time incident response playbooks (deferred)
- advanced threat hunting workflows (deferred)

> **Note:** Graph/PowerShell operational scripts are now **fully implemented and evidenced** as advanced validation within Release 1. They are no longer deferred.

These boundaries are documented in:
- [Build Checklist](../../../docs/release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../../../docs/release1/12-extensions-and-future-enhancements.md)

---

## Related Pages

- [Release 1 Evidence Dashboard](../README.md)
- [Release 1 README](../../../docs/release1/README.md)
- [Monitoring](../../../docs/release1/08-monitoring.md)
- [Skills and Evidence Index](../../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../../README.md)