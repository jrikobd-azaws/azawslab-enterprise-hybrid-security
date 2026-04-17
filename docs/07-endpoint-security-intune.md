# Endpoint Security and Intune

## Purpose

This document records the Release 1 endpoint administration, Microsoft Intune, compliance, and endpoint security implementation state for the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this phase is to establish a practical modern endpoint baseline that supports Microsoft-managed device enrollment, visibility, compliance, security control validation, and operational recovery scenarios across:

- Windows 11 corporate-managed devices
- Windows 11 personal / BYOD devices
- Ubuntu Linux visibility through Intune plus baseline automation through Ansible
- iPhone BYOD enrollment through Intune Company Portal

This document reflects implementation evidence and operational lessons learned, not just target-state planning.

* * *

## Release 1 Scope for This Document

This document covers:

- Intune tenant baseline activation
- Microsoft Intune MDM enrollment scope
- licensing path used for Intune capability
- Windows 11 corporate enrollment scenario
- Windows 11 personal / BYOD enrollment scenario
- Linux Intune enrollment scenario
- Linux baseline automation using Ansible
- iPhone BYOD enrollment scenario
- Windows compliance policy implementation
- Windows security baseline implementation
- BitLocker policy testing and recovery observations
- device visibility in Intune and Microsoft Entra ID
- stale device record cleanup after re-enrollment

It does not yet claim completion of:

- production-grade Windows update ring design
- Android enrollment / MAM
- macOS management
- advanced Linux policy enforcement through Intune
- full LAPS rollout
- full production-grade endpoint analytics and automation

* * *

## Intune Tenant Baseline

Microsoft Intune baseline has been enabled at tenant scope for Release 1.

### MDM Scope

The tenant baseline was configured with:

- MDM user scope = All
- default Microsoft MDM discovery and compliance URLs present
- WIP user scope = None

This established the tenant-side baseline required for endpoint enrollment into Intune.

### Intune Admin Center Validation

The Intune admin center was accessed successfully and the dashboard was validated.

The baseline dashboard state confirmed that:

- Intune administrative access was working
- device enrollment visibility was available
- device configuration visibility was available
- no visible enrollment failures were shown in the captured dashboard summary at the time of validation

* * *

## Licensing Path for Intune Capability

To support endpoint management capability in the lab, the Microsoft 365 licensing path was expanded through:

- existing Microsoft 365 Business Standard baseline
- Enterprise Mobility + Security E5 trial activation

### EMS E5 Trial State

The evidence shows:

- EMS E5 trial added successfully
- 25 trial licenses available
- licenses assigned to pilot/admin users
- assigned license count increased after assignment

This provided the Intune management capability used for Release 1 endpoint scenarios.

* * *

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
- ownership was recorded as Corporate
- the primary user was associated to `u.finance01@corp.azawslab.co.uk`

### Intune Device State

The corporate endpoint is documented as:

- device name: `WIN11-CORP01`
- managed by: Intune
- ownership: Corporate

### Entra ID Device Visibility

The corporate device is also visible in Microsoft Entra ID, supporting the cloud identity/device registration side of the design.

* * *

## Windows 11 Personal / BYOD Scenario

A second Windows 11 endpoint was used to validate a personal/BYOD-style management scenario.

### BYOD Flow

The user flow was differentiated from the corporate path by using the personal-use setup route before connecting the device into the tenant management context.

### Device Management Result

After enrollment and synchronization:

- the device was connected to the AZAWSLAB tenant
- the device showed successful sync status
- the device appeared in Intune
- ownership was recorded as Personal
- the primary user was associated to `u.hr01@corp.azawslab.co.uk`

### Intune Device State

The personal/BYOD endpoint is documented as:

- device name: `WIN11-BYOD01`
- managed by: Intune
- ownership: Personal

### Entra ID Device Visibility

The BYOD device is also visible in Microsoft Entra ID and shows Microsoft Intune as the MDM path in the captured device view.

* * *

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
- final managed device visibility

### Linux Device Result

The Linux endpoint became visible in management views with the following characteristics:

- device name shown as `ubu01-Virtual-Machine`
- OS shown as Linux / Ubuntu
- device visible in Microsoft Entra ID
- device visible in Intune Linux devices
- management path shown through Intune
- primary user associated to `u.finance01@corp.azawslab.co.uk`

### Compliance Interpretation Note

Linux should be described carefully.

Two different states were captured during validation:

- device-side view showing successful device registration and healthy status progression
- Intune Linux devices view showing limited evaluation depth compared with Windows

The practical conclusion is:

- Linux enrollment and management visibility were validated successfully
- Linux device registration in Entra ID and Intune was validated
- Linux is part of the endpoint story for Release 1
- Linux policy depth and compliance interpretation remain narrower than the Windows path

* * *

## Linux Baseline Automation with Ansible

Release 1 also includes an Ansible-based Linux baseline automation path.

### Ansible Host and Project Preparation

The evidence shows:

- Ansible installed and version checked
- project structure created under `~/azawslab-ansible`
- inventory, playbooks, and role/task layout prepared
- SSH connectivity validated from the Ansible host to the Ubuntu target

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

- `ansible ... -m ping` success
- playbook syntax check success
- successful playbook execution with changed tasks shown in the recap

### Operational Value

This adds an important administration layer to the project:

- Intune provides endpoint visibility and enrollment for Linux
- Ansible provides practical baseline automation and configuration control

This is a useful real-world pattern because Linux management often requires a different operational approach from Windows Intune policy enforcement.

* * *

## iOS / iPhone BYOD Scenario

Release 1 now includes an Apple mobile BYOD enrollment scenario using Intune and Company Portal.

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
- ownership: Personal
- management path: Intune
- visibility in Microsoft Entra ID: confirmed
- visibility in Intune iOS/iPadOS devices: confirmed
- compliance state in Intune: Compliant
- primary user associated to `u.hr01@corp.azawslab.co.uk`

### Why This Matters

This extends the endpoint story beyond Windows and Linux and shows that Release 1 includes practical mobile BYOD administration as well.

* * *

## Windows Compliance Policy Baseline

A baseline Windows compliance policy was created in Intune for Release 1 and assigned by device group rather than by individual device.

### Policy

- `CP-WIN-Release1-Baseline`

### Assigned groups

- `GRP-INTUNE-WIN-CORP`
- `GRP-INTUNE-WIN-BYOD`

### Baseline requirements

The compliance policy required key Windows security controls including:

- BitLocker
- Secure Boot
- Trusted Platform Module (TPM)
- Antivirus
- Antispyware
- Microsoft Defender Antimalware

### Assignment Model

The policy was applied through device-group targeting, which is more realistic than one-off direct assignments and better matches enterprise operating practice.

### Compliance Outcome

The evidence set shows two relevant states across the implementation timeline:

#### Initial policy enforcement state
An earlier captured state showed both Windows devices as noncompliant while BitLocker-related enforcement was still being worked through.

#### Later validated device state
A later captured state showed both:

- `WIN11-CORP01`
- `WIN11-BYOD01`

as compliant against:

- `CP-WIN-Release1-Baseline`
- `Default Device Compliance Policy`

### Practical Interpretation

The correct way to describe this is:

- the Windows compliance policy was implemented successfully
- the baseline controls were evaluated in Intune
- compliance status changed over time during testing and remediation
- the final documented state for both Windows pilot devices is compliant

* * *

## Windows Security Baseline

A Windows security baseline was also implemented for Release 1.

### Security Baseline

- `SB-WIN-Release1-Baseline`

### Assigned groups

- `GRP-INTUNE-WIN-CORP`
- `GRP-INTUNE-WIN-BYOD`

### Purpose

This baseline established a first security-hardening layer for Windows endpoints beyond simple enrollment.

It should be understood as an initial Release 1 hardening control, not a fully mature production baseline.

### Practical Result

The evidence shows:

- the security baseline exists in Intune
- it was assigned to the Windows corporate and BYOD groups
- baseline-driven control evaluation is now part of the endpoint story

* * *

## BitLocker Policy and Recovery Scenario

Release 1 also produced a useful advanced operational scenario during BitLocker testing.

This should be documented as a lab recovery and lifecycle-management scenario, not as a routine enrollment path.

### Scenario Summary

A Windows corporate device was encrypted through the Intune-driven BitLocker path, and the recovery key was escrowed into Microsoft Entra ID.

A later virtual hardware change / rebuild scenario caused the device to enter BitLocker recovery and broke the prior healthy management/sign-in trust state.

### Observed Effects

The evidence shows:

- BitLocker recovery prompt on boot
- recovery key retrieval through the Entra ID portal
- work-or-school account repair / sign-in failure on the affected Windows device
- duplicate `WIN11-CORP01` records visible during the recovery/re-enrollment cycle
- stale noncompliant device record present before cleanup
- new healthy re-enrolled device state after remediation

### Recovery and Remediation Actions

The recovery path included:

- retrieving the escrowed BitLocker recovery key
- unlocking the encrypted device
- rebuilding / re-enrolling the Windows device
- identifying stale duplicate cloud records
- deleting obsolete records from management views
- validating the restored compliant device state

### Why This Matters

This is one of the strongest operational lessons in the endpoint section because it demonstrates:

- BitLocker key escrow is operationally critical
- device trust can be disrupted by hardware-context changes
- stale cloud objects may remain after rebuild scenarios
- Intune / Entra lifecycle cleanup is part of real endpoint operations
- recovery planning should include local admin recovery strategy such as Windows LAPS

### Security Governance Observation

This scenario also highlighted an important governance point:

BitLocker alone is not the full answer for insider-risk or data-protection scenarios. Recovery-key governance, Conditional Access, device compliance enforcement, and later information protection controls all matter.

This should be treated as a design lesson and future hardening requirement, not as a claim that the full production control stack is already complete in Release 1.

* * *

## Corporate vs Personal Windows Comparison

Release 1 includes two distinct Windows management scenarios.

### Corporate-managed Windows device

- `WIN11-CORP01`
- ownership: Corporate
- primary user: `u.finance01@corp.azawslab.co.uk`
- managed by Intune

### Personal / BYOD Windows device

- `WIN11-BYOD01`
- ownership: Personal
- primary user: `u.hr01@corp.azawslab.co.uk`
- managed by Intune

### Why This Matters

This demonstrates:

- tenant-side Intune readiness
- a corporate-managed Windows enrollment path
- a personal/BYOD Windows management path
- ownership distinction inside Intune
- device compliance visibility
- Entra + Intune device visibility across both scenarios

## Conditional Access and Compliant Device Logic

Release 1 endpoint work was extended beyond device enrollment and compliance baselines into identity-linked access control.

This phase connected Microsoft Intune compliance posture with Microsoft Entra Conditional Access policy enforcement.

The goal was to demonstrate that device state was not only visible in Intune, but also usable as an access decision input for Microsoft 365 resources.

### Pilot Scope

Conditional Access and compliant-device logic were implemented using the pilot identity-control group:

- `SG-Pilot-MFA-SSPR-CA`

The following exclusion group was used to reduce lockout risk during pilot rollout:

- `SG-CA-Exclude-BreakGlass`

This ensured that pilot enforcement remained controlled and that emergency portal administration remained outside pilot CA enforcement.

### Policy Used for Compliant Device Logic

The primary policy for this phase was:

`CA03 Require compliant device for Microsoft 365 apps`

Policy scope:

- include: `SG-Pilot-MFA-SSPR-CA`
- exclude: `SG-CA-Exclude-BreakGlass`

Target resource:

- Office 365

Grant controls used in the pilot policy:

- Require multifactor authentication
- Require device to be marked as compliant

This means the pilot policy was not device-compliance-only. It required both:

- MFA
- compliant device state

That combined requirement should be reflected consistently in all related documentation.

### Why This Matters

This phase demonstrates an important Release 1 design principle:

identity controls and endpoint controls are not treated as separate silos.

Instead:

- device compliance is established in Intune
- identity targeting is handled in Entra ID
- Conditional Access uses both identity and device state to govern access

This is a more realistic enterprise model than documenting Intune compliance in isolation.

### Rollout Method

The policy was introduced in a staged way:

1. pilot groups prepared
2. Conditional Access policy created
3. policy deployed in **Report-only**
4. pilot impact reviewed
5. policy later switched to **On**

This allowed the compliant-device access path to be checked before full enforcement.

### Relationship to Intune

This Conditional Access policy depends on a valid Intune compliance foundation.

The policy therefore acts as a bridge between:

- endpoint administration
- compliance policy
- modern access control
- Zero Trust enforcement

In practical terms, this means:

- compliant managed devices can satisfy the access requirement
- devices that do not satisfy compliance expectations should not satisfy the same access path

### Release 1 Value

This part of Release 1 now demonstrates:

- pilot Intune compliance tied to access control
- Microsoft 365 access protected by both MFA and compliant-device requirements
- controlled pilot Conditional Access targeting
- explicit break-glass exclusion
- staged rollout from report-only to enforced state

### Documentation Note

Some screenshots were captured while the policy was still in **Report-only** mode because that was the main configuration and pilot-review phase.

The final enforced state was applied later and validated through live access behavior rather than exhaustive recapture of every final policy page.

### Current Status

Compliant-device access logic is implemented at pilot scope.

Completed elements in this area include:

- pilot Conditional Access scoping
- break-glass exclusion design
- Office 365 target-resource selection
- Require multifactor authentication grant control
- Require device to be marked as compliant grant control
- staged rollout from report-only to enforced policy state

### Remaining Actions

Remaining work for this area is now focused on:

1. organizing final evidence under the screenshot structure
2. extending validation depth where useful
3. aligning monitoring and compliance-mapping documents with the implemented control state

--

* * *

## Current Release 1 Position for Endpoint and Intune

The endpoint and Intune work is no longer at planning stage.

### Completed in This Area

- Intune tenant baseline activation
- MDM user scope configuration
- EMS E5 licensing path activation for management capability
- Intune admin center validation
- Windows 11 corporate enrollment validation
- Windows 11 BYOD / personal enrollment validation
- Linux Intune enrollment and management visibility validation
- Linux baseline automation with Ansible
- Apple MDM Push Certificate prerequisite completion
- iPhone BYOD enrollment validation
- Windows compliance policy implementation
- Windows security baseline implementation
- Windows device visibility in Intune and Microsoft Entra ID
- ownership distinction between corporate and personal Windows devices
- advanced BitLocker recovery / re-enrollment scenario documentation
- stale device cleanup after rebuild/re-enrollment event

### In Progress / Still Maturing

- deeper endpoint policy engineering
- Windows LAPS rollout
- richer device configuration profile set
- endpoint lifecycle automation
- Linux policy depth
- additional mobile-platform depth beyond the current iPhone BYOD path

### Not Yet Complete

- production-grade update ring design
- Android BYOD / App Protection
- macOS endpoint management
- advanced Linux hardening beyond the current automation baseline
- mature enterprise-wide endpoint analytics and remediation workflows

* * *

## Evidence Areas Referenced by This Document

The following evidence areas support this document:

- `screenshots/release1-intune/`
- Windows corporate and BYOD enrollment evidence
- Linux Intune enrollment evidence
- Linux Ansible evidence
- iPhone BYOD / Apple MDM evidence
- Windows compliance policy evidence
- Windows security baseline evidence
- BitLocker recovery and stale-device cleanup evidence

* * *

## Related Documents

- `README.md`
- `docs/06-m365-modern-workplace.md`
- `docs/10-security-compliance-mapping.md`
- `docs/12-lessons-learned.md`
- `docs/13-release1-build-checklist.md`

* * *

## Summary

Release 1 endpoint work now includes an active Microsoft Intune baseline with:

- Windows corporate-managed enrollment
- Windows personal/BYOD enrollment
- Linux device visibility through Intune
- Linux baseline automation through Ansible
- iPhone BYOD enrollment through Company Portal
- Windows compliance policy implementation
- Windows security baseline implementation
- BitLocker recovery-key escrow and recovery-path validation
- duplicate/stale device cleanup after re-enrollment

The endpoint story is now strong because it shows not only successful enrollment, but also policy enforcement, platform variation, and operational recovery lessons.