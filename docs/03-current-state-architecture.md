## Windows Server 2022 Base Image Prepared

A standardized Windows Server 2022 Desktop Experience parent image was created for the Phase 1 on-prem foundation.

### Purpose
This parent image will be used with differencing disks for:
- DC1
- DC2
- MEM1

This approach reduces storage use on the lab host and keeps core server builds consistent.

### Actions completed
- Installed Windows Server 2022 Desktop Experience
- Renamed server to `WS2022-MASTER`
- Applied Windows updates
- Cleaned temporary files and recycle bin
- Cleared event logs to keep the image generic
- Ran Sysprep with `/generalize /oobe /shutdown`
- Preserved the VHDX as a read-only parent image

## Windows Server 2022 Master Image & Differencing Disk Strategy

To ensure consistency, rapid deployment, and storage efficiency across the hybrid lab environment, a **Master Image (Gold Image)** strategy utilizing Hyper-V Differencing Disks was implemented. 

Rather than building full isolated virtual machines for every node (DC1, DC2, Member Servers), a single Windows Server 2022 base image was engineered, updated, and generalized. Child VMs are then spawned from this image, consuming only a fraction of the storage while guaranteeing a clean, identical starting state.

### Base Image Preparation, Cleanup and generalization commands used
A standard Generation 2 Hyper-V VM was created using the Windows Server 2022 ISO. Before sealing the image, the following baseline configurations were applied:
1. **Windows Updates:** Fully patched to ensure all child nodes start secure.
2. **Security:** Windows Defender baseline enabled.
3. **System Cleanup:** Ran `cleanmgr` to strip temporary installation files and previous update cache to keep the baseline `.vhdx` as small as possible.
4. **Log Clearing:** Executed PowerShell commands to clear all Event Logs, preventing baseline build errors from bleeding into production child VMs.

```powershell
# Clear all Windows Event Logs before sysprep
Get-EventLog -LogName * | ForEach-Object {Clear-EventLog -LogName $_.Log}
### DC1 Implemented as Initial Domain Controller
```

The first domain controller for the on-prem foundation has been implemented in Hyper-V as part of Release 1.

### DC1 build summary
- Created a differencing disk from the standardized `WS2022-MASTER.vhdx` parent image
- Provisioned the `DC1` virtual machine in Hyper-V
- Attached `DC1` to the `AZAWSLAB-Internal` virtual switch
- Assigned static IPv4 configuration:
  - IP address: `10.10.10.10`
  - Subnet mask: `255.255.255.0`
  - Default gateway: `10.10.10.1`
- Installed the **Active Directory Domain Services** and **DNS Server** roles
- Promoted `DC1` as the first domain controller for the new forest:
  - `corp.azawslab.co.uk`

### Current state
`DC1` is now operating as the initial domain controller and DNS server for the internal Active Directory environment. This establishes the identity and name-resolution foundation for the next Release 1 steps, including OU design, administrative account separation, additional domain services, Exchange source infrastructure, and hybrid identity preparation.

### Validation completed
- Domain promotion completed successfully
- Domain shown in Server Manager as `corp.azawslab.co.uk`
- `SYSVOL` share present
- `NETLOGON` share present
- `dcdiag` executed successfully with initial tests passing

### Evidence
Supporting screenshots are stored in:
- `screenshots/release1-dc1-build/`

Evidence files currently captured:
- `01. New Virtual Disk for DC1 Summary.png`
- `02. New VM for DC1_Summary.png`
- `03. dc1 system ip info.png`
- `04. Install AD and DNS on DC1.png`
- `05. promote dc1.png`
- `06. Successfully promoted dc1.png`
- `07. netshare and dcdiag for dc1.png`

## Implemented Active Directory baseline

The current on-premises identity baseline has been implemented on Hyper-V using the internal switch `AZAWSLAB-Internal`.

### Domain and domain controller
- Domain: `corp.azawslab.co.uk`
- Primary domain controller: `dc1.corp.azawslab.co.uk`
- DC1 IP address: `10.10.10.10`

### Organisational Unit structure implemented
The following OU model has been created in Active Directory:

- `Tier-0`
  - `Admin Accounts`
  - `Service Accounts`
- `Tier-1`
  - `Member Servers`
- `Tier-2`
  - `Workstations`
  - `User Accounts`
    - `Standard Users`
- `Groups`
- `Pilot`
  - `Exchange Pilot`
  - `Intune Pilot`
  - `Conditional Access Pilot`
- `Disabled Objects`

### Standard users created
Initial standard users have been created under `Tier-2 > User Accounts > Standard Users` to support pilot testing and future hybrid scenarios.

### Security groups created
The following baseline AD security groups have been created:
- `SG-T0-Domain-Admins`
- `SG-T1-Server-Admins`
- `SG-Pilot-Hybrid-Sync`
- `SG-Pilot-Exchange-Migration`
- `SG-DLP-Pilot`
