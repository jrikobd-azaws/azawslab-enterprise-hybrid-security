
# Hybrid Identity

## Scope
Release 1 implements hybrid identity between on-premises AD and Microsoft Entra ID.

## Components
- DC1
- DC2
- OUs
- Pilot users
- Entra ID Connect

## Objectives
- Synchronize pilot users first
- Validate sign-in flows
- Separate admin roles
- Prepare for broader rollout

## Evidence to Capture
- AD structure screenshots
- Entra sync screenshots
- Test user sign-in results

## Base Server Image Dependency

The on-prem identity layer begins with a standardized Windows Server 2022 parent image. This parent image is used for differencing-disk deployment of core Phase 1 servers, including DC1, DC2, and MEM1.

This establishes a consistent baseline before Active Directory domain services, DNS, hybrid identity synchronization, and Exchange source infrastructure are introduced.

## Initial Active Directory Foundation Established

The internal Active Directory namespace for the lab has been implemented as:

- **Internal AD domain:** `corp.azawslab.co.uk`
- **Initial domain controller:** `DC1`
- **DC1 IP address:** `10.10.10.10`

`DC1` was deployed from a standardized Windows Server 2022 parent image using a differencing-disk model to reduce host storage usage while maintaining consistency across the Phase 1 server estate.

### Roles implemented on DC1
- Active Directory Domain Services
- DNS Server

### Why this matters
This is the core identity anchor for the hybrid platform. It provides the foundation for:
- organizational unit design
- administrative account separation
- user and group creation
- DNS-backed name resolution
- later Entra ID Connect and pilot hybrid identity synchronization
- Exchange Server Subscription Edition source-environment preparation

### Current state
The forest and domain have been created successfully, and `DC1` is now the first domain controller for `corp.azawslab.co.uk`.

## Current Active Directory implementation state

### Domain naming
The Active Directory domain used for the lab build is:

- `corp.azawslab.co.uk`

### OU and account model implemented
The Active Directory OU structure has been implemented to support tiered administration, pilot scoping, and future hybrid identity integration.

Key implemented areas:
- Tiered OU structure for administrative separation
- Standard user OU for normal business identities
- Dedicated Groups OU for security group management
- Pilot OU structure for phased rollout support

### Standard user baseline
The following initial standard users have been created to support pilot and business-role scenarios:
- `u.hashibur`
- `u.finance01`
- `u.hr01`
- `u.sales01`
- `u.ops01`
- `u.helpdesk01`

### Security groups implemented
The following on-prem AD security groups have been created:
- `SG-T0-Domain-Admins`
- `SG-T1-Server-Admins`
- `SG-Pilot-Hybrid-Sync`
- `SG-Pilot-Exchange-Migration`
- `SG-DLP-Pilot`

### Pilot sync scope
The initial pilot sync scope is intentionally small to reduce risk before Entra Connect is introduced.

Current `SG-Pilot-Hybrid-Sync` members:
- `u.hashibur`
- `u.finance01`
- `u.hr01`

This group will be used later as the initial scoped cohort for hybrid identity validation.

### Current status
At this stage:
- DC1 is built
- OU structure is implemented
- baseline users are created
- baseline AD security groups are created
- pilot hybrid sync scope is defined

### Next step
The next implementation step is to build `dc2.corp.azawslab.co.uk` as an additional domain controller before starting Entra Connect.
