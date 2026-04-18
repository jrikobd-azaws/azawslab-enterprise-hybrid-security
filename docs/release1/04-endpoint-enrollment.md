# Endpoint Platforms and Enrollment

**Navigation:** [README](../README.md) | [Release 1 Build Checklist](16-release1-build-checklist.md) | [Release 1 Final Summary](17-release1-final-summary.md)

**Endpoint docs:** [Endpoint Security and Intune Overview](07-endpoint-security-intune.md) | [Endpoint Compliance and Security Baseline](09-endpoint-compliance-and-security-baseline.md) | [Advanced Recovery Scenarios](14-advanced-recovery-scenarios.md)

---

## Purpose

This document records the **platform-specific enrollment and management paths** implemented in Release 1 for the `azawslab Enterprise Hybrid Security Platform`.

The goal of this document is to show how Release 1 endpoint work moved beyond a single Windows device into a broader pilot endpoint model covering:

- Windows 11 corporate-managed devices
- Windows 11 personal / BYOD devices
- Ubuntu Linux visibility through Intune plus operational baseline automation through Ansible
- iPhone BYOD enrollment through Intune Company Portal

This is the detailed platform companion to the overview page in `07-endpoint-security-intune.md`.

---

## Scope of This Document

This document covers:

- endpoint platform coverage in Release 1
- enrollment and management path by platform
- ownership context where relevant
- device visibility in Intune and Microsoft Entra ID
- practical differences between Windows, Linux, and iPhone management stories
- the relationship between device enrollment and later compliance / security controls

This document does **not** go deep into:

- compliance policy detail
- Windows security baseline detail
- BitLocker recovery scenario detail
- LAPS design and recovery depth

Those belong in:

- `09-endpoint-compliance-and-security-baseline.md`
- `14-advanced-recovery-scenarios.md`

---

## Release 1 Platform Coverage

Release 1 endpoint implementation now includes four distinct endpoint scenarios:

| Platform / Scenario | Ownership / Mode | Management Result |
|---|---|---|
| Windows 11 Corporate | Corporate-owned | Enrolled into Intune and used for compliance/security baseline testing |
| Windows 11 BYOD | Personal / BYOD | Enrolled into Intune and used for ownership/compliance comparison |
| Ubuntu Linux | Pilot managed visibility | Visible through Intune / Entra with baseline automation via Ansible |
| iPhone BYOD | Personal / BYOD | Enrolled through Company Portal and validated as compliant |

This mix is important because it demonstrates that Release 1 is not limited to a single Windows-only enrollment path.

---

## Windows 11 Corporate Device

### Purpose of This Scenario

The Windows corporate-managed scenario was used as the primary endpoint path for:

- full corporate enrollment
- Intune management visibility
- compliance evaluation
- security baseline assignment
- BitLocker testing
- advanced recovery and rebuild scenario work

### Device

- `WIN11-CORP01`

### Build Context

The Windows 11 corporate device was prepared in Hyper-V and configured with the expected enterprise-related prerequisites, including:

- Secure Boot enabled
- TPM enabled

This helped make the Windows 11 enrollment and later BitLocker/security baseline path more realistic.

### Enrollment Path

The corporate device followed the **work-or-school / corporate-style enrollment path**.

After enrollment:

- the device appeared in Intune
- ownership was recorded as **Corporate**
- the primary user was associated with `u.finance01@corp.azawslab.co.uk`
- device visibility was confirmed in Microsoft Entra ID

### Why This Scenario Matters

This is the most important Windows endpoint in Release 1 because it became the main platform for:

- compliance policy validation
- security baseline validation
- BitLocker recovery-key escrow validation
- rebuild and stale-device cleanup lessons

It is therefore more than just an enrollment example. It became the primary managed Windows test platform for the endpoint workstream.

---

## Windows 11 Personal / BYOD Device

### Purpose of This Scenario

The Windows BYOD scenario was used to prove that Release 1 could distinguish between:

- corporate-managed Windows
- personal / BYOD Windows

This is important because those two ownership paths are not the same operational story.

### Device

- `WIN11-BYOD01`

### Enrollment Path

The BYOD device followed the **personal-use / BYOD-style path** before being connected into the Intune management context.

After enrollment:

- the device appeared in Intune
- ownership was recorded as **Personal**
- the primary user was associated with `u.hr01@corp.azawslab.co.uk`
- device visibility was confirmed in Microsoft Entra ID

### Why This Scenario Matters

This scenario proved that the project could show:

- ownership distinction inside Intune
- comparison between corporate and personal Windows devices
- policy evaluation across both Windows device types
- a more realistic pilot endpoint story for a business environment

The Windows BYOD scenario is therefore valuable as a comparison and governance example, not just as a second enrolled device.

---

## Corporate vs Personal Windows Comparison

A key Release 1 outcome is that both Windows device types are present and distinguishable.

### Windows Corporate

- device: `WIN11-CORP01`
- ownership: Corporate
- primary user: `u.finance01@corp.azawslab.co.uk`

### Windows BYOD

- device: `WIN11-BYOD01`
- ownership: Personal
- primary user: `u.hr01@corp.azawslab.co.uk`

### Practical Value

This distinction matters because later controls such as:

- compliance requirements
- access controls
- local admin recovery design
- lifecycle and rebuild handling

can differ depending on the ownership model.

That makes the endpoint story much more realistic than a single-device demonstration.

---

## Ubuntu Linux Through Intune

### Purpose of This Scenario

The Ubuntu Linux scenario was included to show that Release 1 endpoint management is not limited to Windows.

The goal was not to claim Windows-equivalent control depth on Linux. The goal was to demonstrate:

- Linux participation in the managed environment
- visibility through Intune / Entra
- practical baseline administration through Ansible

### Linux Device

- Ubuntu endpoint visible as a managed Linux device
- device evidence showed Linux / Ubuntu identity and Intune-linked presence

### Intune Path

The Linux path used the **Microsoft Intune Agent** for visibility and management registration.

The evidence showed:

- Intune Agent launch on Ubuntu
- sign-in / enrollment flow
- Linux device visibility in management views
- successful management presence in Intune and Entra

### Why This Scenario Matters

This makes the Release 1 endpoint model more credible because many real environments are mixed-platform.

However, Linux should be described carefully.

Release 1 proves:

- Linux device visibility
- Linux enrollment path
- Linux presence in the broader Microsoft-managed environment

Release 1 does **not** claim that Linux has the same Intune control depth as Windows.

---

## Linux Baseline Automation Through Ansible

### Purpose of This Scenario

The Linux story is stronger because it is not limited to “device visible in Intune.”

Release 1 also includes Ansible-based Linux baseline automation to show operational control beyond visibility alone.

### What Was Validated

The captured Ansible work shows:

- Ansible installed and version checked
- project structure prepared
- inventory and playbook layout created
- SSH connectivity validated
- `ansible ... -m ping` success
- playbook syntax check success
- successful baseline playbook execution

### Baseline Automation Content

The Linux baseline playbook included practical tasks such as:

- apt cache update
- baseline package installation
- timezone configuration
- marker file creation
- operations directory creation
- MOTD banner configuration

### Why This Matters

This creates a more realistic Linux management story:

- Intune provides visibility and managed presence
- Ansible provides configuration and baseline automation

That is a much stronger enterprise signal than simply showing that a Linux device appears in a console.

---

## iPhone BYOD Enrollment

### Purpose of This Scenario

The iPhone BYOD path was implemented to demonstrate that Release 1 endpoint scope now includes **mobile device management**, not only desktops and laptops.

### Apple Prerequisite

Before iPhone enrollment could succeed, the required **Apple MDM Push Certificate** workflow had to be completed.

That implementation included:

- downloading the CSR from Intune
- using the Apple Push Certificates Portal
- uploading the certificate back into Intune
- confirming active Apple MDM Push Certificate status

This is a meaningful part of the story because Apple device management requires that prerequisite path.

### Enrollment Path

The iPhone followed the BYOD enrollment process through **Intune Company Portal**.

The captured user journey included:

- Company Portal app acquisition
- sign-in with work account
- privacy and management review
- downloaded management profile flow
- `Settings > General > VPN & Device Management`
- profile installation
- final Company Portal completion state

### Management Result

After enrollment:

- the iPhone was visible in Intune
- the device was visible in Entra
- ownership remained personal / BYOD
- the device showed compliant state in Intune

### Why This Scenario Matters

This extends the endpoint story beyond Windows and Linux and proves that Release 1 now includes a real mobile BYOD scenario.

That makes the platform more representative of an actual modern workplace environment.

---

## How These Platforms Fit the Release 1 Endpoint Story

Taken together, these four scenarios show that Release 1 endpoint work is built around **platform diversity plus control layering**.

### The story is:

- Windows corporate provides the primary managed test platform
- Windows BYOD proves ownership distinction
- Linux proves mixed-platform visibility and automation
- iPhone proves mobile BYOD enrollment and compliance visibility

This is much stronger than presenting Intune as if it were only a Windows device-enrollment lab.

---

## Relationship to Other Endpoint Docs

This document explains **how the devices entered the managed environment**.

The next endpoint document explains **how those devices were governed and protected**:

- `09-endpoint-compliance-and-security-baseline.md`

The advanced operational incident detail is kept separate in:

- `14-advanced-recovery-scenarios.md`

This separation is intentional so the endpoint story stays easier to follow.

---

## Evidence Areas

The following screenshot areas support this document:

- `screenshots/release1/release1-intune/intune-windows-corp/`
- `screenshots/release1/release1-intune/intune-windows-byod/`
- `screenshots/release1/release1-intune/intune-linux/`
- `screenshots/release1/release1-intune/intune-ios/`
- `screenshots/release1/release1-ansible/`

The detailed control and recovery evidence is referenced in the later endpoint documents.

---

## Diagram Placement Recommendation

This document is a good place to embed the endpoint-related architecture or control-flow diagram.

Best fit:
- `../diagrams/02-identity-messaging-endpoint-control-flow.png`

Alternative:
- use one selected Intune device inventory screenshot instead, and keep diagrams in the overview page

---

## Suggested Embedded Screenshot Strategy

This file can support more screenshots than the overview page, but it should still stay selective.

Recommended maximum:
- one Windows corporate screenshot
- one Windows BYOD screenshot
- one Linux Intune or Ansible screenshot
- one iPhone BYOD screenshot

That is enough to prove platform coverage without overwhelming the reader.

---

## Flagship Platform Evidence

### Windows corporate-managed endpoint

![Windows corporate device compliant in Intune](../screenshots/release1/intune/intune-windows-corp/08-intune-windows-device-compliant.png)

*Figure: Windows corporate-managed pilot device shown as compliant in Intune after modern cloud-managed onboarding and policy evaluation.*

### Windows BYOD / personal endpoint

![Windows corp and BYOD devices in Intune](../screenshots/release1/intune/intune-windows-byod/05-intune-windows-devices-corp-and-byod.png)

*Figure: Intune device view showing both corporate and personal Windows pilot devices, proving ownership-aware endpoint management.*

### Linux baseline automation

![Ansible baseline playbook applied](../screenshots/release1/ansible/05-ansible-playbook-run-baseline-applied.png)

*Figure: Ansible baseline playbook execution against the Ubuntu endpoint, showing that Linux governance in Release 1 included operational automation as well as Intune visibility.*

### iPhone BYOD enrollment completion

![iPhone Company Portal enrollment complete](../screenshots/release1/intune/intune-ios/iphone13-byod-enrollment/14-company-portal-enrollment-complete.png)

*Figure: iPhone BYOD enrollment completed through Intune Company Portal, proving the mobile endpoint path was validated end to end.*

---
## Summary

Release 1 endpoint platform coverage now includes:

- Windows 11 corporate enrollment
- Windows 11 BYOD enrollment
- Ubuntu Linux visibility through Intune plus Ansible baseline automation
- iPhone BYOD enrollment through Company Portal

Together, these scenarios demonstrate a broader and more realistic endpoint scope than a simple single-platform Intune lab.

The next endpoint document should explain the **compliance, security baseline, BitLocker, and LAPS direction** built on top of these enrolled platforms.
