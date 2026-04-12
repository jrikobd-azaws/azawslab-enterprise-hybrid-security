# 12-lessons-learned.md

## AD and DNS implementation notes

### Built-in Users container conflict
A custom OU named `Users` could not be used because Active Directory already includes the default built-in `Users` container at the domain root.

To keep the structure clean and aligned with the lab design, standard users were placed under:

- `Tier-2 > User Accounts > Standard Users`

### Domain naming standardization
The active lab domain was standardized to:

- `corp.azawslab.co.uk`

This superseded earlier planning references and required alignment across the tracker, screenshots, and GitHub documentation.

### Pilot-first security group design
Pilot-targeted security groups were created early to support later phased hybrid identity, Exchange migration, and information protection testing.

Implemented examples:
- `SG-Pilot-Hybrid-Sync`
- `SG-Pilot-Exchange-Migration`
- `SG-DLP-Pilot`

### DNS suffix devolution issue on DC1
During DNS validation on DC1, internal DNS records were confirmed to be present and functional, including forward lookup, reverse lookup, PTR registration, and successful `dcdiag /test:dns /v` results.

However, non-absolute lookups for `dc1.corp.azawslab.co.uk` intermittently devolved into malformed queries by appending the parent public suffix. This caused unresolved queries to recurse via root hints to public DNS and return external results associated with the public parent domain.

Fix applied:
- disabled **Append parent suffixes of the primary DNS suffix** in the NIC Advanced DNS settings on DC1

Validation outcome:
- absolute FQDN lookups using a trailing dot resolved correctly
- internal AD-integrated DNS was validated as functional
- DC1 was cleared for progression to DC2 build

## MEM1 and EXCH1 build notes

### Member server build pattern
MEM1 and EXCH1 were both deployed from Hyper-V differencing disks based on the Windows Server master image. This kept the server build process consistent with the planned lab deployment model.

### OU placement after domain join
After domain join, member server computer objects were moved into:

- `Tier-1 > Member Servers`

This kept the OU structure aligned with the tiered administration model already implemented in Active Directory.

### Exchange prerequisite remediation
Exchange Server Subscription Edition readiness checks on EXCH1 identified missing prerequisites.

Instead of using generic web searches, the remediation followed the exact Microsoft links presented by Exchange Setup. This reduced time spent troubleshooting and ensured the missing components were installed in a targeted way.

Resolved prerequisites included:
- Unified Communications Managed API 4.0 Core Runtime 64-bit
- Visual C++ 2013 Redistributable
- IIS URL Rewrite Module

### Exchange memory setting adjustment
Dynamic Memory was disabled on EXCH1 before Exchange installation so the VM used fixed memory allocation during the Exchange build.

### Exchange installation outcome
Exchange Server Subscription Edition installed successfully on EXCH1, and Exchange Admin Center access was validated after setup.

### Exchange post-install behavior
No Send connector existed by default after the first Exchange installation. This was treated as expected baseline behavior and intentionally left unchanged during the pilot stage.

Mailbox regional settings also did not persist correctly through the EAC page, so they were applied successfully through Exchange Management Shell instead.

## Microsoft 365 and Entra Connect lessons

### Tenant creation before hybrid sync
Creating the Microsoft 365 tenant before installing Entra Connect kept the hybrid identity work controlled and easier to troubleshoot.

The tenant was first established with the default cloud namespace:
- `AZAWSLABUK.onmicrosoft.com`

Only after that were custom domains introduced for the pilot.

### Domain verification without mail cutover
The custom domains:

- `azawslab.co.uk`
- `corp.azawslab.co.uk`

were added to the Microsoft 365 tenant, but Microsoft 365 service DNS was intentionally deferred.

This was necessary because `azawslab.co.uk` already had active Zoho-hosted mail flow. Verifying the domains without immediately enabling Microsoft 365 mail services allowed the hybrid identity pilot to proceed without disrupting the existing mail configuration.

### UPN suffix mismatch during Entra Connect setup
During Microsoft Entra Connect configuration, the on-premises UPN suffix:

- `corp.azawslab.co.uk`

initially appeared as not added in Microsoft Entra sign-in configuration.

This was resolved by adding `corp.azawslab.co.uk` as a domain in the tenant and refreshing the wizard. That allowed the pilot users to remain aligned to `userPrincipalName` without proceeding through a mismatch warning state.

### Pilot sync filtering design
The Entra Connect pilot showed that OU filtering and group-based filtering both matter.

The final successful configuration required:
- OU scope for `Tier-2 > User Accounts > Standard Users`
- OU scope for `Groups`
- group-based filtering using `SG-Pilot-Hybrid-Sync`

This ensured that both the pilot user objects and the pilot sync group object were in scope before synchronization began.

### AD connector account choice
During Entra Connect setup, the initial temptation was to use an existing administrative account directly.

The cleaner approach was to let the wizard create the required AD connector account using Enterprise Admin credentials. This kept the sync design better aligned with the intended service-account model rather than relying on a standing privileged admin account.

### Pilot sync outcome
Microsoft Entra Connect was installed successfully on MEM1 using Password Hash Synchronization.

The pilot synchronization completed successfully and the intended users appeared in:
- Microsoft 365 Active users
- Microsoft Entra ID users

The synchronized pilot identities were clearly marked as on-premises synced, which confirmed that the Release 1 hybrid identity pilot was functioning as designed.

### Cloud admin separation
Keeping the cloud-only tenant admin account separate from the synchronized on-prem pilot users made validation and troubleshooting easier.

This avoided confusion between:
- cloud administration
- synchronized user identities
- pilot mailbox validation

### Recommendations surfaced during sync installation
The Entra Connect completion page highlighted additional hardening recommendations, including:
- enabling AD Recycle Bin
- ensuring stronger platform security posture on the sync host

These did not block the pilot sync but should be treated as follow-up hardening improvements for later phases.
