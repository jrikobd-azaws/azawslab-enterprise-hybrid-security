# 05-hybrid-identity.md

## Objective
Implement a controlled hybrid identity pilot for the `corp.azawslab.co.uk` lab by synchronizing a small set of on-premises AD users into Microsoft 365 / Microsoft Entra ID without disrupting the existing Zoho-hosted mail environment.

## Scope
This phase focuses on:

- defining a pilot synchronization scope in on-premises Active Directory
- creating a Microsoft 365 tenant for the hybrid identity phase
- adding and verifying the required custom domains
- preserving existing Zoho-hosted mail flow by deferring Microsoft 365 mail service DNS changes
- deploying Microsoft Entra Connect Sync on a dedicated member server
- validating successful pilot synchronization for selected users

## Supporting server components

The hybrid identity pilot in Release 1 was built on the following on-premises server components:

- `DC1` — primary domain controller and DNS server for `corp.azawslab.co.uk`
- `DC2` — additional domain controller and DNS server for replication and redundancy validation
- `MEM1` — dedicated member server used as the Microsoft Entra Connect Sync host
- `EXCH1` — on-premises Exchange Server Subscription Edition host used to prepare pilot mailboxes and support later coexistence planning

### On-premises identity platform state
Before hybrid identity deployment, the following baseline components were already in place:

- Active Directory domain: `corp.azawslab.co.uk`
- tiered OU model implemented
- standard user accounts created
- baseline security groups created
- pilot sync group created
- Exchange pilot mailboxes enabled for selected users

This server baseline allowed the Microsoft 365 / Microsoft Entra pilot to be introduced in a controlled way without changing the existing Zoho-hosted mail routing.

## On-premises pilot scope

### Pilot sync group
A dedicated security group was created in on-premises Active Directory to scope the initial pilot synchronization:

- `SG-Pilot-Hybrid-Sync`

### Pilot sync members
The initial pilot users are:

- `u.hashibur`
- `u.finance01`
- `u.hr01`

These users were intentionally chosen to keep the first synchronization wave small and easy to validate.

## On-premises directory layout used for pilot sync

### User location
Pilot users are located in:

- `Tier-2 > User Accounts > Standard Users`

### Group location
The pilot sync group object is located in:

- `Groups`

Both locations were kept in scope during Entra Connect configuration so that:
- the pilot user objects were visible to synchronization
- the pilot group object could be used for group-based filtering

## Microsoft 365 tenant baseline

### Tenant created
A new Microsoft 365 tenant was created for Release 1 hybrid identity work.

### Tenant domains
Current tenant domain state:

- Default cloud domain: `AZAWSLABUK.onmicrosoft.com`
- custom domain added: `azawslab.co.uk`
- custom subdomain added: `corp.azawslab.co.uk`

### DNS / mail-flow design decision
The custom domains were added to the tenant, but Microsoft 365 service DNS was intentionally **not** enabled at this stage.

Reason:
- `azawslab.co.uk` currently has active mail flow through Zoho
- changing MX / autodiscover / Microsoft 365 mail service DNS at this stage would risk disrupting the live mail configuration

Current domain state in Microsoft 365:
- `azawslab.co.uk` present in tenant
- `corp.azawslab.co.uk` present in tenant
- service connection deferred
- Zoho-hosted mail flow retained intentionally

## Entra Connect deployment

### Sync server
Microsoft Entra Connect Sync was installed on:

- `mem1.corp.azawslab.co.uk`

This server was chosen to keep roles separated:
- domain controllers remain domain controllers
- EXCH1 remains the Exchange host
- MEM1 is used as the synchronization / utility host

### Installation method
A custom Entra Connect installation was used.

### Sign-in method
Selected sign-in method:

- `Password Hash Synchronization`

### AD connector account
During setup, the wizard was allowed to create the required AD connector account using Enterprise Admin credentials.

This avoided using a long-term privileged admin account directly as the synchronization account.

### UPN alignment issue and fix
During configuration, the on-premises UPN suffix:

- `corp.azawslab.co.uk`

initially appeared as not added in Microsoft Entra sign-in configuration.

This was resolved by:
- adding `corp.azawslab.co.uk` to the Microsoft 365 / Microsoft Entra tenant
- refreshing the Entra Connect sign-in configuration page

After that fix:
- `userPrincipalName` was retained as the sign-in attribute
- the pilot users remained aligned to their on-premises UPN format

### Source anchor
The synchronization configuration completed using:

- `mS-DS-ConsistencyGuid`

as the source anchor attribute.

## Filtering model

### OU filtering
During Entra Connect setup, synchronization was limited to selected OUs.

Included OU scope:
- `Groups`
- `Tier-2 > User Accounts > Standard Users`

This ensured:
- the pilot sync group object was in scope
- the pilot user objects were in scope

### Group-based filtering
Pilot synchronization was further restricted using group-based filtering.

Selected pilot group:
- `SG-Pilot-Hybrid-Sync`

This limited synchronized users to the intended pilot membership rather than all users in the scoped OUs.

## Sync validation

### Configuration result
Entra Connect configuration completed successfully on MEM1 and the first synchronization cycle was initiated.

### Sync engine validation
Synchronization Service Manager on MEM1 showed successful:
- full import
- full synchronization
- export

for the on-premises directory and the Microsoft Entra connector.

### Cloud validation
Pilot synchronization was validated in both:
- Microsoft 365 admin center
- Microsoft Entra admin center

### Confirmed synced pilot users
The following synchronized pilot users appeared in the cloud:

- `u.hashibur@corp.azawslab.co.uk`
- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

### Cloud-only admin separation
The tenant’s cloud admin account remained separate from the synchronized pilot users.

This helped keep:
- tenant administration
- pilot identity validation
- troubleshooting

cleanly separated.

## Current hybrid identity state
The Release 1 hybrid identity foundation is now operational at pilot scope.

Completed outcomes:
- pilot sync group created in on-premises AD
- pilot users created in on-premises AD
- Microsoft 365 tenant created
- `azawslab.co.uk` added to the tenant
- `corp.azawslab.co.uk` added to the tenant
- Microsoft 365 service DNS intentionally deferred
- MEM1 prepared and used as Entra Connect host
- Entra Connect installed successfully
- Password Hash Synchronization configured
- pilot synchronization restricted through `SG-Pilot-Hybrid-Sync`
- pilot users synchronized successfully into Microsoft 365 / Microsoft Entra ID

## Current limitations
The following items remain intentionally deferred or incomplete:

- Microsoft 365 mail service cutover
- user license assignment for synchronized pilot users
- pilot user cloud sign-in validation with assigned licenses
- Exchange hybrid configuration
- mailbox migration / coexistence workflow
- broader Microsoft 365 baseline workload rollout

## Next steps
The next planned steps after pilot hybrid identity completion are:

- assign Microsoft 365 licenses to pilot synced users
- validate pilot user cloud sign-in experience
- begin Microsoft 365 baseline configuration
- continue Exchange / Microsoft 365 coexistence and migration planning
