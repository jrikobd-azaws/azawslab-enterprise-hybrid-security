# 07-defender-for-cloud

## 1. Objective

Phase P7 validates Microsoft Defender for Cloud / CSPM visibility for the Release 2 Azure subscription and implements a low-cost security posture improvement.

The phase focuses on proving that Defender for Cloud is active, Secure Score and recommendations are visible, and a subscription security contact can be managed through Terraform.

## 2. Business Problem

Cloud environments need central posture visibility and clear security notification paths.

Without Defender for Cloud posture management and security contact configuration, the platform team may miss:

- high-severity cloud security alerts
- subscription-level posture recommendations
- insecure resource configurations
- governance evidence for security operations readiness

For this lab, cost control is also important. Paid Defender workload plans should not be enabled unless deliberately selected and validated.

## 3. Technical Solution

P7 uses Microsoft Defender for Cloud subscription data and Terraform-managed security contact configuration.

The implementation uses:

- `Microsoft.Security` provider data for plan status, Secure Score, and assessments
- `terraform/platform-shared/dev` for shared security-service ownership
- `terraform/modules/security` for the Defender security contact resource

The first implemented control is:

```text
Microsoft.Security/securityContacts/default
```

with contact email:

```text
admin-lab@entra.azawslab.co.uk
```

This targets the Defender recommendation family around security contact and high-severity alert notification configuration.

## 4. Architecture Snapshot

```text
[Azure subscription 1]
        |
        v
[Microsoft Defender for Cloud / Microsoft.Security]
        |
        +--> Secure Score
        +--> Recommendations / Assessments
        +--> Security contact: default
                 |
                 v
        admin-lab@entra.azawslab.co.uk
```

Terraform ownership:

```text
terraform/platform-shared/dev
  -> platform-shared-dev.tfstate
  -> shared security resources
  -> Defender security contact
```

## 5. Implementation Summary

Readiness captured:

- Azure subscription context
- Microsoft.Security provider registration
- Defender pricing plan status
- Secure Score baseline
- Defender assessments and recommendations

The baseline showed that Defender for Cloud data was already available and that most Defender pricing plans were set to `Free`, while `Discovery` and `FoundationalCspm` were already `Standard`.

Terraform was then updated to add:

```hcl
resource "azurerm_security_center_contact" "defender" {
  name  = var.defender_security_contact_name
  email = var.defender_security_contact_email

  alert_notifications = true
  alerts_to_admins    = true
}
```

The local Terraform plan showed:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

GitHub Actions controlled Terraform Apply succeeded and created the Defender security contact.

## 6. Validation Summary

Confirmed:

- Microsoft.Security provider is registered.
- Defender pricing plan data is available.
- Secure Score data is available.
- Defender recommendations are visible.
- Defender security contact exists in Terraform state.
- Defender security contact output email is `admin-lab@entra.azawslab.co.uk`.
- No paid Defender workload plan was enabled by this implementation.

Remaining:

- post-change Defender recommendations / Secure Score review

## 7. Evidence Path

Primary evidence is stored under:

```text
docs/release2/evidence/P7/
```

Key evidence files:

- `p7-readiness-current-state.txt`
- `defender-plan-status.txt`
- `secure-score.txt`
- `recommendations-summary.md`
- `p7-platform-shared-prechange-snapshot.txt`
- `p7-platform-shared-plan.txt`
- `p7-defender-security-contact-validation.txt`
- `p7-evidence.txt`
- `p7-execution-log.txt`

## 8. Key Commands Used

Representative commands:

```powershell
az provider show --namespace 'Microsoft.Security' --output json
az rest --method get --uri '/subscriptions/<subscription-id>/providers/Microsoft.Security/pricings?api-version=2024-01-01'
az rest --method get --uri '/subscriptions/<subscription-id>/providers/Microsoft.Security/secureScores?api-version=2020-01-01'
az rest --method get --uri '/subscriptions/<subscription-id>/providers/Microsoft.Security/assessments?api-version=2020-01-01'
az rest --method get --uri '/subscriptions/<subscription-id>/providers/Microsoft.Security/securityContacts/default?api-version=2023-12-01-preview'
terraform -chdir='terraform/platform-shared/dev' plan -no-color -input=false
terraform -chdir='terraform/platform-shared/dev' state list
terraform -chdir='terraform/platform-shared/dev' output
```

## 9. Lessons Learned

- Microsoft 365 E5 licensing is useful context, but Azure Defender for Cloud plan state must be validated through Microsoft.Security pricing data.
- Defender for Cloud can provide useful Secure Score and recommendation evidence without immediately enabling paid workload plans.
- A security contact is a low-cost, high-signal posture improvement that fits well in the shared security Terraform root.
- P7 should avoid broad Defender plan enablement until cost and validation scope are explicit.

## 10. Recruiter-Ready Outcome Statement

Validated Microsoft Defender for Cloud posture visibility for an Azure landing zone and implemented a Terraform-managed security contact for high-severity security notifications. Captured Defender pricing, Secure Score, and recommendation evidence while avoiding unnecessary paid Defender workload-plan enablement.
