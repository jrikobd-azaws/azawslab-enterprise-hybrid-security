
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
