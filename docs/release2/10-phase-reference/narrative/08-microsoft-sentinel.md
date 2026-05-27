# 08-microsoft-sentinel

## 1. Objective

Phase P8 deployed Microsoft Sentinel for Release 2 monitoring and SIEM capability.

The goal was to create a dedicated monitoring resource group, deploy a Log Analytics workspace, onboard Microsoft Sentinel, configure Azure Activity ingestion, and deploy a Sentinel scheduled analytic rule using Terraform.

## 2. Implemented Resources

P8 deployed:

- Monitoring resource group: `rg-dev-monitoring-norwayeast`
- Log Analytics workspace: `law-dev-platform-norwayeast`
- Microsoft Sentinel onboarding state: `onboardingStates/default`
- Azure Activity subscription diagnostic setting
- Sentinel scheduled analytic rule:
  - `rule-p8-azure-activity-write-delete`

## 3. Governance Issue and Resolution

During the first GitHub Actions apply, Sentinel onboarding failed because Azure Policy denied the Microsoft.SecurityInsights child resource for missing mandatory tags.

The parent Log Analytics workspace was correctly tagged with:

- `Project`
- `Environment`
- `Owner`
- `CostCenter`
- `Phase`

The failed resource was the Sentinel onboarding child resource. The Terraform resource `azurerm_sentinel_log_analytics_workspace_onboarding` does not expose a `tags` argument, so the child resource could not be tagged directly.

Resolution:
- Mandatory tag policies remained active globally.
- A narrow RG-scoped policy exemption was created for `rg-dev-monitoring-norwayeast`.
- The exemption was limited to the P8 monitoring resource group and the four mandatory tag assignments.
- After the exemption, GitHub Actions Terraform Apply completed successfully.

## 4. Validation Summary

Validation confirmed:

- Log Analytics workspace exists and is tagged
- Sentinel onboarding state exists
- Sentinel scheduled analytic rule exists
- Terraform outputs expose Sentinel onboarding and analytic rule IDs
- Terraform state contains the P8 monitoring resources
- Azure Portal Sentinel redirects to the Defender portal
- Defender portal workspace connection was completed manually after Terraform onboarding

## 5. Evidence

Evidence is stored under:

```text
docs/release2/evidence/P8/
```

Key evidence files:

```text
p8-sentinel-enabled-plan.txt
p8-sentinel-policy-exemptions-rg-scope.txt
p8-sentinel-post-apply-validation.txt
p8-evidence.txt
p8-execution-log.txt
```

## 6. Current Status

P8 deployment and post-apply validation are complete.

The remaining optional/final validation item is incident generation. If required for full closeout, generate a controlled Azure Activity event that matches the scheduled analytic rule and capture the resulting Sentinel alert or incident evidence.
