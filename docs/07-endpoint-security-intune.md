# Endpoint Security and Intune

## Purpose

This document records the Release 1 endpoint administration and Microsoft Intune implementation state for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this phase is to establish a practical modern endpoint baseline that supports Microsoft-managed device enrollment, visibility, compliance, and comparison across corporate-managed Windows, personal/BYOD Windows, and Linux scenarios, with Ansible used to strengthen Linux baseline administration.

---

## Release 1 Scope for This Document

This document covers:

- Intune tenant baseline activation
- Microsoft Intune MDM enrollment scope
- licensing path used for Intune capability
- Windows 11 corporate enrollment scenario
- Windows 11 personal / BYOD enrollment scenario
- Linux Intune enrollment scenario
- device visibility in Intune and Microsoft Entra ID
- baseline compliance and management visibility
- Linux baseline automation using Ansible

It does not yet claim completion of deeper policy engineering such as full Windows configuration profiles, update rings, Android MAM, or advanced Linux hardening beyond the evidence captured.

---

## Intune Tenant Baseline

Microsoft Intune baseline has been enabled at tenant scope for Release 1.

### MDM Scope

The tenant was configured with:

- **MDM user scope = All**
- default Microsoft MDM discovery and compliance URLs present
- **WIP user scope = None**

This establishes the tenant-side baseline required for endpoint enrollment into Intune.

### Intune Admin Center Validation

The Intune admin center was accessed successfully and the dashboard was validated.

The baseline dashboard state confirmed that:

- Intune administrative access was working
- device enrollment visibility was available
- device configuration visibility was available
- no enrollment failures were shown in the visible dashboard summary at the time of capture

---

## Licensing Path for Intune Capability

To support endpoint management capability in the lab, the Microsoft 365 licensing path was expanded through:

- existing Microsoft 365 Business Standard baseline
- **Enterprise Mobility + Security E5 trial** activation

### EMS E5 Trial State

The evidence shows:

- EMS E5 trial added successfully
- 25 trial licenses available
- licenses assigned to pilot/admin users
- assigned license count increased after assignment

This supports the Intune management capability used for Release 1 endpoint scenarios.

---

## Windows 11 Corporate Enrollment Scenario

A Windows 11 corporate test device was prepared and enrolled as a corporate-managed endpoint.

### VM Preparation

The corporate Windows 11 VM was prepared in Hyper-V with:

- Secure Boot enabled
- TPM enabled

This supports a credible enterprise-style Windows 11 enrollment path.

### Enrollment Path

The corporate device was built through the Windows setup flow using the work-or-school path.

### Device Management Result

After enrollment:

- the device synchronized successfully
- the device appeared as managed by the AZAWSLAB tenant
- the device was visible in Intune as a Windows device
- ownership was recorded as **Corporate**
- compliance state was shown as **Compliant**
- the primary user was associated to `u.finance01@corp.azawslab.co.uk`

### Intune Device State

The corporate endpoint is documented as:

- device name: `WIN11-CORP01`
- managed by: **Intune**
- ownership: **Corporate**
- compliance: **Compliant**

### Entra ID Device Visibility

The corporate device is also visible in Microsoft Entra ID, supporting the cloud identity/device registration side of the design.

---

## Windows 11 Personal / BYOD Scenario

A second Windows 11 endpoint was used to validate a personal/BYOD-style management scenario.

### BYOD Flow

The user flow was differentiated from the corporate path by using the personal-use setup route before connecting the device into the tenant management context.

### Device Management Result

After enrollment and synchronization:

- the device was connected to the AZAWSLAB tenant
- the device showed successful sync status
- the device appeared in Intune
- ownership was recorded as **Personal**
- compliance state was shown as **Compliant**
- the primary user was associated to `u.hr01@corp.azawslab.co.uk`

### Intune Device State

The personal/BYOD endpoint is documented as:

- device name: `WIN11-BYOD01`
- managed by: **Intune**
- ownership: **Personal**
- compliance: **Compliant**

### Entra ID Device Visibility

The BYOD device is also visible in Microsoft Entra ID and shows Microsoft Intune as the MDM path in the captured device view.

---

## Linux Intune Scenario

A Linux endpoint scenario was also validated for Release 1 using Ubuntu and the Microsoft Intune Agent.

### Linux VM Preparation

The Ubuntu VM was prepared in Hyper-V with:

- Secure Boot enabled
- Ubuntu installed as the guest operating system

### Linux Enrollment Path

The Linux scenario used the Microsoft Intune Agent for device registration and management visibility.

The captured evidence shows:

- Intune Agent launch on Ubuntu
- sign-in / enrollment path
- Linux device status progression
- final compliant state shown in the device view

### Linux Device Result

The Linux endpoint became visible in management views with the following characteristics:

- device name shown as `ubu01-Virtual-Machine`
- OS shown as Linux / Ubuntu
- device visible in Microsoft Entra ID
- device visible in Intune Linux devices
- management path shown through **Intune**

### Compliance / Evaluation Note

Two relevant states were captured during validation:

- device-side view showing a **Compliant** result
- Intune Linux devices view showing **Not evaluated**

This should be documented precisely.

The practical conclusion is:

- Linux enrollment and management visibility were validated successfully
- Linux device registration in Entra ID and Intune was validated
- compliance interpretation for Linux should be described carefully and not overstated beyond the captured screens

### Why This Matters

This strengthens the Release 1 endpoint story because it demonstrates that the environment is not limited to Windows-only endpoint thinking. It shows awareness of mixed-platform endpoint administration and the practical differences in management experience across Windows and Linux.

---

## Corporate vs Personal Windows Comparison

Release 1 now includes two distinct Windows management scenarios:

### Corporate-managed Windows device

- `WIN11-CORP01`
- ownership: **Corporate**
- primary user: `u.finance01@corp.azawslab.co.uk`
- managed by Intune
- compliant

### Personal / BYOD Windows device

- `WIN11-BYOD01`
- ownership: **Personal**
- primary user: `u.hr01@corp.azawslab.co.uk`
- managed by Intune
- compliant

### Why This Matters

This strengthens the Release 1 endpoint story because it demonstrates:

- tenant-side Intune readiness
- a corporate-managed Windows enrollment path
- a personal/BYOD-style Windows management path
- ownership distinction inside Intune
- device compliance visibility
- Entra + Intune device visibility across both scenarios

---

## Linux Baseline Automation with Ansible

Release 1 now also includes an Ansible-based Linux baseline automation path.

### Ansible Host and Project Preparation

The evidence shows:

- Ansible installed and version checked
- project structure created under `~/azawslab-ansible`
- inventory, playbooks, and role/task layout prepared

### Playbook Content

The Linux baseline playbook and role tasks include actions such as:

- apt cache update
- baseline package installation
- timezone configuration to `Europe/London`
- creation of an `azawslab` marker file
- creation of an operations directory
- MOTD banner configuration

### Validation Steps

The captured validation steps include:

- SSH connectivity to the Ubuntu target
- `ansible ... -m ping` success
- playbook syntax check success
- successful playbook execution with changed tasks shown in the recap

### Operational Value

This adds an important administration layer to the project:

- Intune provides endpoint visibility and enrollment for Linux
- Ansible provides practical baseline automation and configuration control

This is a useful real-world pattern because Linux management often requires a different operational approach from Windows Intune policy enforcement.

---

## iOS / iPhone BYOD Scenario

Release 1 now also includes an Apple mobile BYOD enrollment scenario using Intune and Company Portal.

### Apple MDM Push Certificate Prerequisite

Before iOS/iPadOS enrollment could work, the Apple MDM Push Certificate prerequisite was completed.

The implementation flow was:

- download the Intune CSR from the Intune admin center
- sign in to the Apple Push Certificates Portal
- upload the CSR to Apple
- download the generated Apple MDM push certificate
- upload the `.pem` certificate back into Intune
- confirm active Apple MDM Push Certificate status in Intune

This step is mandatory for Apple device management in Intune and is now part of the documented Release 1 tenant baseline.

### iPhone BYOD Enrollment Flow

The iPhone BYOD path was completed through the Intune Company Portal enrollment workflow.

The captured flow includes:

- Company Portal app acquisition from the App Store
- Company Portal sign-in with the work account
- privacy / device management information review
- management profile download guidance
- navigation to `Settings > General > VPN & Device Management`
- downloaded profile visibility
- management profile installation
- profile installed confirmation
- final Company Portal completion state

### iPhone Device Result

The enrolled iPhone is now visible in management views with the following characteristics:

- device type: iPhone / iOS
- ownership: **Personal**
- management path: **Intune**
- visibility in Microsoft Entra ID: confirmed
- visibility in Intune iOS/iPadOS devices: confirmed
- compliance state in Intune: **Compliant**

### Why This Matters

This extends the endpoint story beyond Windows and Linux and shows that Release 1 now includes practical mobile BYOD administration as well.

The endpoint scope now demonstrates:

- Windows corporate-managed endpoint
- Windows personal/BYOD endpoint
- Linux Intune visibility plus Ansible baseline automation
- iPhone BYOD enrollment and compliance visibility

---

## Current Release 1 Position for Endpoint and Intune

The endpoint and Intune work is no longer at planning stage.

### Completed in This Area

- Intune tenant baseline activation
- MDM user scope configuration
- EMS E5 licensing path activation for management capability
- Intune admin center validation
- Windows 11 corporate enrollment
- Windows 11 BYOD / personal enrollment validation
- Linux Intune enrollment and management visibility
- compliant Windows device visibility in Intune
- device visibility in Microsoft Entra ID
- ownership distinction between corporate and personal Windows devices
- Linux baseline automation with Ansible
- Ansible connectivity, syntax-check, and playbook execution validation

### In Progress

- deeper endpoint policy engineering
- Linux compliance interpretation and policy depth
- documentation and evidence closeout

### Not Yet Complete

- Windows configuration profile baseline
- compliance policy design detail
- update rings / patching baseline
- Android BYOD / App Protection
- advanced Linux hardening beyond the current baseline automation
- advanced endpoint hardening across all platforms

---

## Evidence to Capture

The following evidence should be retained in the repository:

- Intune MDM user scope configuration
- EMS E5 trial activation and assignment evidence
- Intune admin center dashboard
- Windows 11 corporate device preparation evidence
- corporate device sync / enrollment evidence
- corporate device visible as compliant in Intune
- corporate device visible in Entra ID
- BYOD/personal device enrollment evidence
- BYOD device sync / management evidence
- BYOD device visible as personal and compliant in Intune
- BYOD device visible in Entra ID
- Linux Intune Agent sign-in / enrollment evidence
- Linux device-side status evidence
- Linux visibility in Entra ID
- Linux visibility in Intune Linux devices
- Ansible version and project structure evidence
- Ansible playbook / task content evidence
- Ansible ping, syntax check, and execution evidence

---

## Related Documents

- `docs/06-m365-modern-workplace.md`
- `docs/09-monitoring-alerting.md`
- `docs/10-security-compliance-mapping.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 endpoint work now includes an active Microsoft Intune baseline with corporate-managed Windows, personal/BYOD Windows, Linux, and iPhone BYOD scenarios validated at practical implementation level.

The environment now has:

- tenant-side Intune activation
- MDM scope configured
- EMS E5 management licensing path enabled
- one compliant corporate Windows 11 endpoint
- one compliant personal/BYOD Windows 11 endpoint
- one enrolled Linux endpoint with Intune visibility
- one enrolled iPhone BYOD endpoint with compliant status
- visibility for devices in Intune and Microsoft Entra ID
- Linux baseline automation through Ansible

The next major work in this area is policy depth: configuration profiles, compliance policy detail, update management, endpoint hardening, and further refinement of Linux and mobile management coverage.