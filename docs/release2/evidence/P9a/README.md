# P9a - Azure Monitor Alert Firing Validation

## What This Evidence Proves
Azure Monitor alert rules fire correctly under real load. Synthetic CPU stress triggers metric alerts, and action groups deliver notifications.

## Evidence Inventory
- CPU stress test script (p9a-cpu-stress-test.ps1)
- Alert fired portal validation (p9a-alert-fired-portal-validation.png)
- Email notification receipt (p9a-action-group-alert-email-notification.png)

## How to Interpret
Run the stress script (or view its output) and verify that the corresponding alert appears in the portal and that an email was received.

## Redaction Notes
Email addresses and subscription details are redacted; alert names and timestamps are kept.

## Related Capability Document
- [03. Automation, SecOps & Resilience](../../03-automation-secops-resilience.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Monitoring is validated with synthetic load - not just hoped to work.**