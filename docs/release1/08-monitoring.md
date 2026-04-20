# Monitoring

## Purpose

This page explains how the platform was monitored across identity, endpoint state, policy visibility, and operational activity.

The focus is on practical administrative visibility rather than on claiming a full SOC or enterprise observability programme. The goal is to show that the platform could be reviewed, interpreted, and supported through real control signals.

---

## What Is Proven Here

The monitoring approach demonstrates:

- sign-in visibility linked to access and Conditional Access outcomes
- audit-log visibility for administrative and security-relevant actions
- device-state visibility across the managed endpoint estate
- policy and control status review inside the management layer
- example alerting that supports operational awareness
- a support-oriented monitoring model tied to the wider identity, endpoint, and recovery story

---

## Why It Matters

A platform that cannot be observed is difficult to trust and difficult to support.

The work here matters because it shows:
- access decisions were visible rather than assumed
- endpoint state could be reviewed through management tooling
- administrative activity left an auditable trail
- control status could be checked as part of ongoing operations
- monitoring was treated as part of platform credibility, not as a later add-on

---

## Monitoring Design Approach

The monitoring model in this phase was intentionally practical.

Rather than trying to claim a fully built SIEM or enterprise-scale detection stack, the implementation focused on the visibility that mattered most for the platform already in place:
- sign-in activity
- audit activity
- device compliance and control status
- policy and dashboard visibility
- alerts relevant to endpoint administration

This keeps the document evidence-based and aligned with the actual scope of the phase.

---

## Sign-In Visibility

Sign-in monitoring is one of the most important proof areas because it connects:
- synchronized identity
- Conditional Access review
- device trust interpretation
- practical access monitoring

This matters because identity controls are much more credible when the resulting sign-in behavior can be reviewed rather than inferred.

In this implementation, sign-in visibility helps show that access-control logic and endpoint state were part of the same operational picture.

---

## Audit Visibility

Audit logging matters because it provides administrative traceability.

This is important for a supportable platform because configuration changes, identity actions, and control adjustments should not exist only as remembered events. They should be reviewable.

Audit visibility therefore strengthens:
- change traceability
- operational confidence
- governance credibility
- support investigation capability

---

## Device and Control Visibility

Monitoring in this phase also includes the operational view of the endpoint estate.

That means looking at:
- compliance state
- device presence
- policy status
- dashboard-level control views
- whether the managed estate appears healthy, unhealthy, or inconsistent

This matters because endpoint trust is not just about policy existence. It is also about whether the administrator can see the state of the estate clearly enough to act on it.

---

## Alerting and Operational Awareness

This phase does not claim a full enterprise alerting programme, but it does include practical alert visibility that supports endpoint administration and operational review.

That is valuable because it shows the platform was not treated as static. Administrators need to know when device configuration, compliance, or control posture requires attention.

In that sense, monitoring here supports day-to-day supportability more than formal security operations.

---

## Flagship Evidence

### 1. Conditional Access result visible in sign-in logs

![Conditional Access result in sign-in logs](../../screenshots/release1/monitoring-and-operations/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)

*Sign-in-log view showing Conditional Access result visibility, linking identity, access review, and device-context interpretation into one operational signal.*

### 2. Audit-log overview

![Entra audit log overview](../../screenshots/release1/monitoring-and-operations/monitoring/audit-logs/01-entra-audit-log-overview.png)

*Audit-log visibility showing that administrative activity was reviewable and that the platform included traceable operational history rather than relying on undocumented changes.*

### 3. Device compliance status visibility

![Intune device compliance status](../../screenshots/release1/monitoring-and-operations/monitoring/device-visibility/03-intune-device-compliance-status.png)

*Device compliance-state visibility showing that the managed endpoint estate could be reviewed through operational status signals rather than through policy assumptions alone.*

### 4. Example alerting in the admin view

![Intune dashboard device configuration alert](../../screenshots/release1/monitoring-and-operations/monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png)

*Example alert visibility demonstrating that the platform supported practical administrative awareness when configuration or device-state issues required attention.*

---

## Additional Monitoring Evidence

The wider evidence set also includes:
- additional sign-in views
- more detailed audit visibility
- device-state and control dashboard screenshots
- monitoring context that supports the endpoint, identity, and recovery documents

For guided browsing:
- [Monitoring and Operations Evidence Hub](../../screenshots/release1/monitoring-and-operations/README.md)
- [Release 1 Evidence Dashboard](../../screenshots/release1/README.md)

---

## What Was Validated

The monitoring implementation validated that:
- sign-in activity could be reviewed alongside access-control outcomes
- audit trails were available for platform actions
- endpoint state and compliance visibility supported operational review
- dashboard and alert views provided practical administrative awareness
- monitoring signals connected meaningfully to the wider identity, endpoint, and recovery model

---

## Operational Insight

The strongest lesson here is that monitoring should be judged by whether it helps an administrator understand platform state and take action.

The value is not just that logs exist. The value is that the platform makes it possible to answer questions like:
- did access succeed or fail, and why?
- what changed?
- which devices are compliant or unhealthy?
- what needs attention next?

That makes monitoring part of supportability, not just reporting.

---

## Scope Boundaries

Monitoring in this phase should be read as an **implemented and evidenced administrative visibility model**, not as a claim to a full enterprise SIEM, SOC, or observability stack.

Important boundaries:
- the strongest evidence is centered on sign-ins, audit logs, device-state review, and practical alert visibility
- this phase does not claim a full Sentinel-based monitoring programme
- this phase does not claim advanced detection engineering or formal threat-hunting workflows
- the monitoring story is intentionally aligned to identity, endpoint, and support operations
- larger-scale Azure-native monitoring and security operations belong to later roadmap work

---

## Related Documents

- [Release 1 Summary](00-summary.md)
- [Hybrid Identity](01-hybrid-identity.md)
- [Endpoint Overview](03-endpoint-overview.md)
- [Endpoint Compliance and Security](05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](06-recovery-scenarios.md)
- [Purview](07-purview.md)
- [Compliance Mapping](09-compliance-mapping.md)
- [Build Checklist](11-build-checklist.md)

For cross-release context:
- [Platform Overview](../foundation/01-platform-overview.md)
- [Roadmap](../foundation/04-roadmap.md)
- [Skills and Evidence Index](../foundation/05-skills-and-evidence-index.md)

---

## Related Evidence

- [Monitoring and Operations Evidence Hub](../../screenshots/release1/monitoring-and-operations/README.md)
- [Release 1 Evidence Dashboard](../../screenshots/release1/README.md)

