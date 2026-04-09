
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
