# 09a-azure-monitor-alerts

## 1. Objective

Phase P9a deployed Azure Monitor alerting for Release 2.

The objective was to validate platform alerting by creating an Azure Monitor Action Group and a VM CPU metric alert targeting the private workload VM.

## 2. Implemented Resources

P9a deployed:

- Azure Monitor Action Group: `ag-p9a-platform-ops`
- Email receiver for platform operations notification
- VM CPU metric alert: `alert-p9a-vm-cpu-high`
- Target VM: `vm-dev-client-01`
- Metric namespace: `Microsoft.Compute/virtualMachines`
- Metric name: `Percentage CPU`

## 3. Validation Summary

Validation confirmed:

- Action Group exists in `rg-dev-monitoring-norwayeast`
- Action group membership email was received
- Metric alert exists and is enabled
- Metric alert targets `vm-dev-client-01`
- Controlled CPU load was generated on the target VM
- Alert fired successfully in Azure Portal
- Azure Monitor alert notification email was received
- Target VM was deallocated after validation

## 4. Evidence

Evidence is stored under:

```text
docs/release2/evidence/P9a/
```

Key evidence files:

```text
p9a-monitor-alerts-enabled-plan.txt
p9a-monitor-alerts-post-apply-validation.txt
p9a-monitor-alerts-alert-test.txt
p9a-cpu-stress-test.ps1
p9a-action-group-membership-email-validation.png
p9a-action-group-alert-email-notification.png
p9a-alert-fired-portal-validation.png
```

## 5. Current Status

P9a deployment, alert firing validation, and email notification validation are complete.
