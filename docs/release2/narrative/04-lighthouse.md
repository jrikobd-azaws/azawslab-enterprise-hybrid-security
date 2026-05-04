# 04-lighthouse

## 1. Objective

Phase P4 implemented Azure Lighthouse delegated resource management for Release 2.

The objective was to demonstrate how a central platform or managed service provider tenant can receive delegated visibility into a separate customer or branch Azure subscription without creating native user accounts in the customer tenant.

This phase used:

- managing tenant: `entra.azawslab.co.uk`
- managing account: `admin-lab@entra.azawslab.co.uk`
- delegated group: `azw-Platform-Admins`
- customer tenant: `AZAWSLAB / br.azawslab.co.uk`
- customer subscription: `azawslab`
- delegated role: `Reader`

P4 was implemented with Reader delegation first. This intentionally proved cross-tenant visibility with low operational risk before introducing any delegated write access.

## 2. Business Problem

In real enterprise and MSP environments, central platform teams often need to operate across multiple customer, subsidiary, branch, or acquisition tenants.

Without delegated management, common problems include:

- creating separate admin accounts in every customer tenant
- weak identity lifecycle control
- inconsistent RBAC assignment patterns
- poor visibility across customer subscriptions
- manual context switching between tenants
- higher risk from excessive standing privileges

Azure Lighthouse addresses this by allowing a customer subscription to be projected into a managing tenant with controlled RBAC. Operators sign in to their own managing tenant, while access to the customer subscription is governed by the delegated role.

## 3. Technical Solution

P4 used Azure Lighthouse registration resources in the customer subscription.

The implementation deployed:

- a `Microsoft.ManagedServices/registrationDefinitions` resource
- a `Microsoft.ManagedServices/registrationAssignments` resource

The registration definition described the managed service offer and authorized the managing tenant group:

- managed by tenant ID: `78643a83-bcc9-4a3b-ab7e-eeede0b3384e`
- delegated principal: `azw-Platform-Admins`
- delegated principal object ID: `2b0de10d-6f29-4736-9952-f4a99e684c35`
- role definition: `Reader`
- Reader role definition ID: `acdd72a7-3385-48ef-bd42-f606fba81ae7`

The registration assignment linked the definition to the customer subscription:

- customer subscription: `azawslab`
- customer subscription ID: `bee0b8d3-954e-4ee0-a2a8-9861b3bbcacb`

The deployment was performed from the customer-side subscription context using a subscription-scope ARM template stored at:

```text
docs/release2/artifacts/P4/lighthouse/lighthouse-reader-delegation.json
```

## 4. Architecture Snapshot

```text
[Managing tenant: entra.azawslab.co.uk]
        |
        | admin-lab@entra.azawslab.co.uk
        | member of azw-Platform-Admins
        |
        v
[Delegated group: azw-Platform-Admins]
        |
        | Azure Lighthouse authorization
        | Role: Reader
        |
        v
[Customer tenant: AZAWSLAB / br.azawslab.co.uk]
        |
        v
[Customer subscription: azawslab]
        |
        +-- Microsoft.ManagedServices/registrationDefinitions
        +-- Microsoft.ManagedServices/registrationAssignments
```

P4 is separate from the later AWS multi-cloud phases.

In this design:

- `br.azawslab.co.uk` represents a customer or branch identity boundary.
- Azure Lighthouse demonstrates delegated Azure subscription visibility.
- Later AWS phases demonstrate multi-cloud networking, routing, and security integration.

This keeps the architecture realistic: one branch/customer identity boundary can have both Azure and AWS footprints, but Azure Lighthouse is specifically used for Azure delegated subscription management.

## 5. Implementation Summary

P4 started with a readiness blocker: the original customer-side tenant and domain model was not ready.

To prepare the customer side:

- the retired Release 1 `belfast.azawslab.co.uk` domain was removed after evidence collection was complete
- `br.azawslab.co.uk` was verified in the AZAWSLAB tenant
- the `azawslab` subscription was confirmed as the customer-side subscription

To prepare the managing side:

- `admin-lab@entra.azawslab.co.uk` was used as the day-to-day managing account
- `azw-Platform-Admins` was created as the delegated administration group
- `admin-lab@entra.azawslab.co.uk` was added as a member of `azw-Platform-Admins`
- the group object ID was captured for the Lighthouse authorization block

The ARM template was then created and validated locally.

A what-if deployment confirmed that Azure would create:

- `Microsoft.ManagedServices/registrationDefinitions`
- `Microsoft.ManagedServices/registrationAssignments`

The subscription-scope deployment completed successfully with provisioning state `Succeeded`.

## 6. Validation Summary

Validation was performed from both the customer side and the managing side.

Customer-side validation confirmed:

- the Lighthouse registration definition exists
- the Lighthouse registration assignment exists
- the service provider offer appears in the Azure portal
- the delegated subscription appears under Service providers / Delegations
- the delegated role assignment shows `azw-Platform-Admins` with Reader access

Managing-side validation confirmed:

- `admin-lab@entra.azawslab.co.uk` can see the delegated `azawslab` subscription
- the delegated subscription appears through `managedByTenants`
- the customer subscription home tenant remains `AZAWSLAB / br.azawslab.co.uk`
- the native Release 2 subscription remains the default CLI context

The key validation result was that the customer subscription was visible from the managing tenant without signing in as a native customer-tenant user.

## 7. Evidence Path

Primary evidence is stored under:

```text
docs/release2/evidence/P4/
```

Key evidence files:

```text
p4-customer-tenant-readiness.txt
p4-lighthouse-validation.txt
p4-execution-log.txt
p4-evidence.txt
```

Supporting screenshots:

```text
p4-portal-customer-service-provider-offers.png
p4-portal-customer-delegations-list.png
p4-portal-customer-delegation-details.png
p4-portal-customer-role-assignments-reader.png
p4-cli-managing-tenant-delegated-subscription-visible.png
```

Implementation artifact:

```text
docs/release2/artifacts/P4/lighthouse/lighthouse-reader-delegation.json
```

## 8. Key Commands Used

Customer-side provider readiness:

```powershell
az provider show `
  --namespace Microsoft.ManagedServices `
  --query "{namespace:namespace,registrationState:registrationState}" `
  --output table
```

ARM what-if:

```powershell
az deployment sub what-if `
  --name 'p4-lighthouse-reader-whatif' `
  --location 'norwayeast' `
  --template-file 'docs/release2/artifacts/P4/lighthouse/lighthouse-reader-delegation.json' `
  --output table
```

ARM deployment:

```powershell
az deployment sub create `
  --name 'p4-lighthouse-reader-delegation' `
  --location 'norwayeast' `
  --template-file 'docs/release2/artifacts/P4/lighthouse/lighthouse-reader-delegation.json' `
  --output jsonc
```

Customer-side resource validation:

```powershell
az resource show `
  --ids "/subscriptions/bee0b8d3-954e-4ee0-a2a8-9861b3bbcacb/providers/Microsoft.ManagedServices/registrationDefinitions/fb8f2924-6706-5603-aeaa-c2756d7f3e42" `
  --output jsonc

az resource show `
  --ids "/subscriptions/bee0b8d3-954e-4ee0-a2a8-9861b3bbcacb/providers/Microsoft.ManagedServices/registrationAssignments/ba7d65bc-258b-5276-b1f3-0a4e4fd77787" `
  --output jsonc
```

Managing-side delegated visibility validation:

```powershell
az account list --refresh --output table
az account list --refresh --output jsonc
```

## 9. Lessons Learned

The most important implementation lesson was that Azure Lighthouse authorization depends on the managing-tenant principal receiving access through the delegated group.

Initially, the Lighthouse registration and assignment existed successfully on the customer side, but the delegated subscription was not visible to `admin-lab`. The cause was not a deployment failure. The missing step was that `admin-lab@entra.azawslab.co.uk` had not yet been added to `azw-Platform-Admins`.

After adding `admin-lab` to the group and refreshing the Azure CLI account cache, the delegated customer subscription appeared correctly.

This is an important real-world operational lesson:

- creating the delegated group is not enough
- the operator must also be a member of the delegated group
- CLI and portal sessions may need refresh after group membership changes
- Reader delegation is a safe first validation stage before granting write access

## 10. Recruiter-Ready Outcome Statement

Implemented Azure Lighthouse delegated resource management between a customer tenant and a managing tenant. Deployed a subscription-scope Lighthouse registration definition and assignment that delegated Reader access from `AZAWSLAB / br.azawslab.co.uk` to the `azw-Platform-Admins` group in `entra.azawslab.co.uk`. Validated that the managing tenant account could see the customer subscription through Azure Lighthouse while preserving the native Release 2 subscription as the default operational context.
