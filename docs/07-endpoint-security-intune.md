# Endpoint Security and Intune

## Purpose

This document records the Release 1 endpoint administration and Microsoft Intune implementation state for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this phase is to establish a practical modern endpoint baseline that supports Microsoft-managed device enrollment, visibility, compliance, and comparison between corporate-managed and personal/BYOD Windows scenarios.

---

## Release 1 Scope for This Document

This document covers:

- Intune tenant baseline activation
- Microsoft Intune MDM enrollment scope
- licensing path used for Intune capability
- Windows 11 corporate enrollment scenario
- Windows 11 personal / BYOD enrollment scenario
- device visibility in Intune and Microsoft Entra ID
- baseline compliance validation

It does not yet claim completion of deeper policy engineering such as full configuration profiles, update rings, application packaging, Android MAM, or Linux management unless separately documented.

---

## Intune Tenant Baseline

Microsoft Intune baseline has been enabled at tenant scope for Release 1.

### MDM Scope

The tenant was configured with:

- **MDM user scope = All**
- default Microsoft MDM discovery and compliance URLs present
- **WIP user scope = None**

This establishes the tenant-side baseline required for Windows device enrollment into Intune.

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

## Current Release 1 Position for Intune

The endpoint and Intune work is no longer at planning stage.

### Completed in This Area

- Intune tenant baseline activation
- MDM user scope configuration
- EMS E5 licensing path activation for management capability
- Intune admin center validation
- Windows 11 corporate enrollment
- Windows 11 BYOD / personal enrollment validation
- compliant device visibility in Intune
- device visibility in Microsoft Entra ID
- ownership distinction between corporate and personal devices

### In Progress

- deeper endpoint policy engineering
- documentation and evidence closeout

### Not Yet Complete

- Windows configuration profile baseline
- compliance policy design detail
- update rings / patching baseline
- Android BYOD / App Protection
- Linux support path
- application deployment baseline
- advanced endpoint hardening

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

---

## Related Documents

- `docs/06-m365-modern-workplace.md`
- `docs/09-monitoring-alerting.md`
- `docs/10-security-compliance-mapping.md`
- `docs/13-release1-build-checklist.md`

---

## Summary

Release 1 endpoint work now includes an active Microsoft Intune baseline with both corporate-managed and personal/BYOD Windows scenarios validated.

The environment now has:

- tenant-side Intune activation
- MDM scope configured
- EMS E5 management licensing path enabled
- one compliant corporate Windows 11 endpoint
- one compliant personal/BYOD Windows 11 endpoint
- visibility for both devices in Intune and Microsoft Entra ID

The next major work in this area is policy depth: configuration profiles, compliance policy detail, update management, and broader endpoint security controls.

## Ubuntu 24.04 Managed Endpoint Baseline

Ubuntu 24.04 LTS was used as the Linux endpoint persona for Release 1.

### User used
- `u.finance01@corp.azawslab.co.uk`

### Device identity
- Device name: `ubu01-Virtual-Machine`
- Platform: Linux
- Management: Microsoft Intune
- Join/registration path: Microsoft Entra + Intune Linux enrollment flow

### Validated
- Ubuntu VM prepared and connected to the lab network
- Microsoft Intune Agent installed
- user sign-in and enrollment completed successfully
- Ubuntu device appeared in Microsoft Entra ID
- Ubuntu device appeared in Microsoft Intune
- Linux endpoint added to the Release 1 managed endpoint estate

### Current note
- compliance evaluation was still in progress / not yet evaluated at the time of initial evidence capture

### Outcome
This completed the Linux managed-endpoint enrollment phase and prepared the platform for the next Linux operations phase using a separate Ansible control node.

## Ansible Control Node and Linux Baseline

A separate Ubuntu VM was used as the dedicated Ansible control node for Release 1.

### Control model
- `ans1` = Ansible control node
- `ubu01-Virtual-Machine` = managed Ubuntu endpoint

### Why this design was used
This model was chosen to demonstrate centralized Linux administration rather than localhost-only automation.

### Baseline implemented
An Ansible project was created on the control node with:

- inventory file
- playbook
- role-based task structure

The playbook was executed remotely against the managed Ubuntu endpoint over SSH.

### Baseline actions implemented
The Linux baseline included:

- updating the APT package cache
- installing baseline administration packages
- setting timezone to `Europe/London`
- creating a project marker file
- creating an operations directory
- applying a project-specific MOTD banner

### Validation
Validation evidence included:

- `ansible --version`
- hostname configuration for the control node
- Ansible project structure
- inventory and playbook review
- successful SSH-based connectivity to the managed Ubuntu endpoint
- successful Ansible ping
- successful first playbook execution against the remote Ubuntu device

### Outcome
This phase demonstrated that the Linux portion of Release 1 was not only enrolled in Intune, but also managed through a repeatable configuration-as-code approach using a centralized Ansible control node.