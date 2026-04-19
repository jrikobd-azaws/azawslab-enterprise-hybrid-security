# Monitoring and Alerting

**Related navigation:** [README](../../README.md) | [Release 1 Summary](00-summary.md) | [Release 1 Build Checklist](11-build-checklist.md)  
**Related docs:** [Hybrid Identity](01-hybrid-identity.md) | [Modern Workplace](02-modern-workplace.md) | [Endpoint Overview](03-endpoint-overview.md) | [Purview](07-purview.md) | [Compliance Mapping](09-compliance-mapping.md)

## Purpose

This page records the Release 1 monitoring and alerting baseline for the `azawslab Enterprise Hybrid Security Platform`.

It shows how Release 1 moved beyond simple configuration proof into operational visibility across identity, administrative activity, endpoint state, and protection-control outcomes. It should be read as a baseline monitoring and review page, not as a claim of full SIEM, SOC, or enterprise alerting maturity.

## What This Page Proves

This page proves that Release 1 includes meaningful operational visibility rather than stopping at implementation alone.

It demonstrates:

- sign-in and Conditional Access result visibility in Microsoft Entra
- audit-log visibility for administrative review and change awareness
- endpoint-state and compliance visibility in Intune
- at least one example monitoring signal visible in Microsoft endpoint administration
- a cross-domain monitoring story that now spans identity, administration, endpoint state, and content-protection outcomes

## Implementation Story

Release 1 monitoring was implemented as a visibility baseline rather than as a centralized security-operations platform.

The first layer of that baseline was identity visibility. Microsoft Entra sign-in views and Conditional Access result review provided evidence that pilot identity controls could be observed after configuration, not only assigned. This matters because a hybrid identity environment is not operationally credible if policy state exists but access outcomes cannot be reviewed.

The second layer was administrative visibility. Audit-log review established a basic ability to see change activity in Microsoft Entra. In Release 1, the correct claim is not mature investigation workflow. It is that administrative review and change visibility now exist as part of the platform baseline.

The third layer was endpoint visibility. Intune views now show managed-device state, compliance status, and operational health indicators for Release 1 pilot devices. This is especially important because it connects monitoring directly to lifecycle management rather than leaving endpoint administration as a one-time enrollment story.

The fourth layer was alert-signal awareness. Release 1 does not claim a formalized alert-routing and triage model, but it does show that monitoring signals and review surfaces already exist in the Microsoft administration plane. That creates a credible foundation for later maturity in alerting and incident handling.

Taken together, these layers show that Release 1 can now be observed across identity, administration, endpoint state, and control outcomes. That is a materially stronger position than a platform that only demonstrates successful configuration.

## Flagship Monitoring Evidence

### Sign-in visibility and Conditional Access result review

![Entra sign-in conditional access result](../../screenshots/release1/monitoring/sign-in-logs/05-entra-signin-conditional-access-result.png)

*Figure: Microsoft Entra sign-in review showing Conditional Access result visibility for the Release 1 pilot identity-control model.*

### Audit-log baseline

![Entra audit log overview](../../screenshots/release1/monitoring/audit-logs/01-entra-audit-log-overview.png)

*Figure: Microsoft Entra audit-log overview used to establish the Release 1 administrative review and change-visibility baseline.*

### Endpoint visibility and compliance state

![Intune device compliance status](../../screenshots/release1/monitoring/device-visibility/03-intune-device-compliance-status.png)

*Figure: Intune device-compliance status view showing operational visibility into managed endpoint state.*

### Example alert or monitoring signal

![Intune dashboard device configuration alert](../../screenshots/release1/monitoring/example-alert/02-intune-dashboard-device-configuration-alert.png)

*Figure: Example monitoring signal from Intune dashboard views, showing how Release 1 monitoring extends into device-configuration and operational health awareness.*

## Why This Matters

This workstream strengthens the project because it shows that Release 1 is not limited to configuration and policy assignment.

It now also demonstrates that the platform can be reviewed after deployment through:

- identity sign-in visibility
- administrative change visibility
- endpoint-state visibility
- control-outcome visibility
- early alert-signal awareness

That makes the overall repository more credible because it shows the environment can be observed and validated, not only built.

## What Release 1 Does Not Claim

To keep the monitoring story credible, Release 1 does not claim:

- full SIEM or SOC maturity
- Microsoft Sentinel integration
- formal incident-response workflows
- advanced alert severity and routing models
- deep cross-domain event correlation
- mature Defender investigation and response workflows

Release 1 should therefore be presented as a monitoring and visibility baseline, not as a finished enterprise security-operations platform.

## Related Docs

- [Release 1 Summary](00-summary.md)
- [Hybrid Identity](01-hybrid-identity.md)
- [Modern Workplace](02-modern-workplace.md)
- [Endpoint Overview](03-endpoint-overview.md)
- [Purview](07-purview.md)
- [Compliance Mapping](09-compliance-mapping.md)
- [Release 1 Build Checklist](11-build-checklist.md)