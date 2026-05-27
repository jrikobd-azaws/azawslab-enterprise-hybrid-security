# O5 Europe AVD Region Decision

## Decision

O5 will be implemented as a Europe-region Azure Virtual Desktop secure admin/developer workspace.

```text
O5 primary AVD region:
  northeurope

O5 alternate / DR region:
  westeurope

O1-O4 primary platform region:
  norwayeast

O1-O4 paired backup / DR region:
  norwaywest
```

This replaces the earlier Norway East O5 attempt. The Norway East O5 foundation was not retained because Microsoft.DesktopVirtualization host pool, workspace, and application group metadata resources are not available in Norway East.

## Design Rationale

O5 is a distinct secure admin/developer workspace phase. It is acceptable and cleaner to deploy the O5 AVD workspace in a Microsoft-supported European AVD region rather than using a mixed-location model where only AVD metadata is in Europe and the rest of the O5 workspace remains in Norway East.

The resulting portfolio design is:

```text
O1-O4:
  Norway East hybrid security platform
  - hub/spoke
  - Azure Firewall
  - FortiGate / VPN / BGP
  - AWX / management VM
  - private AKS

O5:
  North Europe AVD secure admin/dev workspace
  - AVD host pool
  - AVD workspace
  - desktop application group
  - AVD spoke VNet
  - FSLogix Azure Files
  - private endpoint
  - later session host and toolchain
```

## Region Model

```text
northeurope:
  O5 AVD primary deployment region
  rg-dev-avd-northeurope
  vnet-dev-northeurope-spoke-avd
  vdpool-dev-northeurope
  vdws-dev-northeurope
  vdag-dev-northeurope
  stdevavdfsneu01

westeurope:
  approved alternate / DR / resiliency region for future O5 design

norwayeast:
  existing O1-O4 active platform region

norwaywest:
  paired region for Norway East backup, DR, and geo-redundant service requirements
```

## State-Boundary Rule

```text
platform-avd/dev:
  owns O5 AVD workspace resources in North Europe
  owns O5 AVD spoke network
  owns O5 FSLogix storage/private endpoint/private DNS for O5 scope

platform-networking/dev:
  owns hub networking
  owns Azure Firewall
  owns shared route control
  owns future global VNet peering between Norway East hub and North Europe AVD spoke
```

## Stop Conditions

Stop O5 implementation if Terraform proposes:

```text
- creating O5 AVD resources in norwayeast
- creating AVD metadata in unsupported regions
- creating hub/AVD peering from platform-avd
- creating Azure RBAC role assignments from sp-terraform-gh
- creating session host VM before Patch 3
- destroying O1-O4 resources
- changing platform-aks, platform-management, aws-branch, or platform-networking unexpectedly
```

## Reader Diagram

```text
Existing O1-O4 platform
  location: norwayeast
        |
        +-- hub VNet
        +-- Azure Firewall
        +-- management / AWX
        +-- private AKS
        +-- hybrid VPN/BGP path

Future platform-networking peering
        |
        v

O5 secure admin/dev workspace
  location: northeurope
        |
        +-- rg-dev-avd-northeurope
        +-- vnet-dev-northeurope-spoke-avd
        +-- snet-avd
        +-- snet-avd-private-endpoints
        +-- rt-avd-to-hub-northeurope
        +-- vdpool-dev-northeurope
        +-- vdws-dev-northeurope
        +-- vdag-dev-northeurope
        +-- stdevavdfsneu01 / fslogix-profiles
        +-- pe-stdevavdfsneu01-file
```

## Implementation Status

```text
Completed:
  - Norway East partial O5 foundation removed through root-specific platform-avd workflow
  - platform-avd state is empty
  - governance allowed-location policy updated for:
      norwayeast
      norwaywest
      northeurope
      westeurope

Next:
  - retarget platform-avd Terraform defaults to North Europe
  - deploy O5 foundation from clean empty state
```