# 06-m365-modern-workplace.md

## Objective
Establish the initial Microsoft 365 and Exchange coexistence baseline for Release 1 by:

- building an on-premises Exchange Server Subscription Edition source environment
- validating core Exchange functionality
- enabling pilot on-premises mailboxes
- creating a Microsoft 365 tenant for later hybrid and modern workplace expansion
- synchronizing pilot user identities into Microsoft 365 without disrupting existing Zoho-hosted mail flow

## On-premises Exchange source platform

### EXCH1 baseline
The on-premises Exchange source server was provisioned as:

- `exch1.corp.azawslab.co.uk`

Completed server baseline steps:
- built from a Hyper-V differencing disk
- joined to `corp.azawslab.co.uk`
- moved to `Tier-1 > Member Servers`
- Exchange Server Subscription Edition installed successfully
- Exchange Admin Center access validated
- Outlook Web App access validated

### Exchange organization baseline
Initial Exchange organization settings:

- Exchange organization name: `AZAWSLAB Exchange`
- Mailbox role selected during setup
- Dynamic Memory disabled on EXCH1 before Exchange installation

### Exchange prerequisite remediation
During Exchange readiness checks, the following missing prerequisites were identified and installed individually:

- Unified Communications Managed API 4.0 Core Runtime 64-bit
- Visual C++ 2013 Redistributable
- IIS URL Rewrite Module

The readiness process was then rerun successfully and Exchange installation completed.

## Exchange post-install validation

### Core Exchange validation completed
Post-install validation confirmed:

- Exchange server object present
- Mailbox role installed correctly
- Exchange services running
- mailbox database mounted
- accepted domain present
- Exchange Admin Center working
- Outlook Web App working

### Validated services
Core services validated on EXCH1:

- `MSExchangeIS`
- `MSExchangeTransport`
- `W3SVC`

### Mailbox database
The initial mailbox database was created and mounted successfully on EXCH1.

### Accepted domain
The accepted domain baseline was confirmed for:

- `corp.azawslab.co.uk`

### Send connector state
No Internet Send connector existed after the first Exchange install.

This was treated as expected baseline behavior and intentionally left unchanged during the pilot stage.

### Mailbox regional settings
Mailbox regional settings were successfully applied through Exchange Management Shell after the EAC regional settings page did not persist changes.

Applied settings included:
- language: `en-GB`
- time zone: `GMT Standard Time`
- date format: `dd/MM/yyyy`
- time format: `HH:mm`

## Pilot mailbox preparation

### Pilot mailbox scope
Pilot Exchange mailboxes were enabled for:

- `u.hashibur`
- `u.finance01`
- `u.hr01`

### Pilot mailbox addresses
Primary SMTP addresses assigned on-premises:

- `u.hashibur@corp.azawslab.co.uk`
- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

### Mailbox validation
Pilot mailbox enablement was validated in:
- Exchange Management Shell
- Exchange Admin Center

### Pilot OWA validation
Pilot mailbox OWA access was validated using:

- `u.finance01`

This confirmed that at least one pilot user mailbox was end-user accessible through Outlook Web App.

## Microsoft 365 tenant baseline

### Tenant creation
A Microsoft 365 tenant was created to support the Release 1 modern workplace and hybrid identity phase.

Current tenant baseline:
- default cloud domain: `AZAWSLABUK.onmicrosoft.com`
- custom domain added: `azawslab.co.uk`
- custom subdomain added: `corp.azawslab.co.uk`

### DNS / coexistence decision
To avoid disrupting the existing Zoho-hosted mail environment, Microsoft 365 service DNS was intentionally deferred after domain verification.

Current design state:
- `azawslab.co.uk` present in Microsoft 365
- `corp.azawslab.co.uk` present in Microsoft 365
- Microsoft 365 service DNS not enabled
- Zoho mail routing intentionally retained

This preserves the current external mail configuration while still allowing hybrid identity work to proceed.

## Pilot cloud identity state

### Synchronized pilot users
After Entra Connect synchronization, the following pilot users appeared in Microsoft 365:

- `u.hashibur@corp.azawslab.co.uk`
- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

### Licensing state
At the current stage, these synchronized pilot users remain:

- unlicensed

This is intentional until the next Microsoft 365 pilot step begins.

### Separation of cloud admin and synced users
The cloud-only Microsoft 365 admin account remained separate from the synchronized pilot users.

This keeps tenant administration cleaner and reduces confusion during pilot validation.

## Current modern workplace state
The Release 1 modern workplace platform is now established at an initial coexistence and identity baseline.

Completed outcomes:
- Exchange SE source server deployed on EXCH1
- Exchange post-install validation completed
- pilot on-premises mailboxes enabled
- pilot OWA access validated
- Microsoft 365 tenant created
- custom domains added to Microsoft 365
- service DNS intentionally deferred to preserve Zoho mail
- pilot users synchronized into Microsoft 365 through Entra Connect

## Current limitations
The following items remain intentionally incomplete or deferred:

- Microsoft 365 mail cutover
- Exchange hybrid deployment
- pilot user license assignment
- pilot user cloud app sign-in validation
- Teams / SharePoint / OneDrive workload rollout
- Intune / device-management rollout
- mailbox migration workflow
- Exchange and Microsoft 365 coexistence mail-routing configuration

## Next steps
The next planned steps are:

- assign licenses to synchronized pilot users
- validate pilot user sign-in to Microsoft 365 services
- begin Microsoft 365 baseline workload configuration
- continue Exchange / Microsoft 365 coexistence and migration planning
