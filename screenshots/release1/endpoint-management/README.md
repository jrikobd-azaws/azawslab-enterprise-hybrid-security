# Endpoint Management Evidence Hub

## Purpose

This page is the guided evidence index for the endpoint-management portion of the implemented platform.

It demonstrates that the platform treats endpoints as a managed **lifecycle**, not a collection of isolated enrollment events. The evidence covers:

- ownership‑aware onboarding across corporate and personal Windows devices
- modern, zero‑touch provisioning (Windows Autopilot + ESP)
- platform diversity (Windows, Ubuntu Linux, iPhone BYOD)
- endpoint compliance, security baselines, Windows LAPS (retrieval and post‑Autopilot remediation)
- Win32 application lifecycle management (packaging, deployment, install status)
- BitLocker recovery, stale‑record cleanup, and restored compliant state
- Intune as the central management layer for policy, update governance, and recovery

This is one of the most valuable evidence areas in the repository because it connects identity, trust, compliance, supportability, and recovery into a single, coherent story.

---

## How to Use This Hub

Use this page in three ways:

1.  **Start with flagship proof** – the shortest route to the strongest endpoint screenshots.
2.  **Browse by scenario** – evidence grouped by ownership, provisioning method, or lifecycle stage.
3.  **Follow the related docs** – narrative explanation and architecture behind the evidence.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Corporate compliant state** | Managed Windows endpoint enrolled, compliant, and policy‑aware | [Corporate Windows compliant in Intune](intune/intune-windows-corp/08-intune-windows-device-compliant.png) |
| **Windows Autopilot + ESP** | Zero‑touch provisioning with custom branding and ESP device preparation | [ESP device preparation stage](intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png) |
| **Autopilot profile assignment** | Device imported and correctly assigned to the intended deployment profile | [Device imported with profile assigned](intune/intune-autopilot-esp/07-autopilot-device-imported-profile-assigned-belfast-pilot.png) |
| **LAPS remediation after Autopilot** | Local admin password recovery after post‑provisioning fix (script + device targeting) | [LAPS password retrieval after remediation](intune/intune-autopilot-laps/07-laps-password-retrieval-success-after-remediation-desktop-cdniaqb.png) |
| **Win32 app deployment** | Application packaging, assignment, and successful install status | [App overview – installed summary](intune/intune-app-deployment/05-win32-app-overview-installed-summary-two-devices-notepadplusplus.png) |
| **Compliance enforcement** | Device trust is evaluated, not assumed | [Compliance policy non‑compliant result](intune/intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png) |
| **BitLocker recovery & restored compliance** | Recovery‑key visibility and fully restored managed state after disruption | [Compliance restored after re‑enrollment](intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png) |
| **Graph‑assisted device rename** | Script‑based device management (dry‑run + apply) for helpdesk and L3 support | [Rename device apply success](../../identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png) |

---

## Evidence by Scenario

### 1. Windows Corporate

This area contains the strongest managed‑endpoint evidence in the whole endpoint story. It supports:
- organisation‑managed onboarding
- compliant‑state visibility (Intune compliance policies)
- stronger policy expectations

**Start here:**
- [Windows Corporate Folder](intune/intune-windows-corp/)

**Best evidence:**
- [Corporate Windows compliant in Intune](intune/intune-windows-corp/08-intune-windows-device-compliant.png)

**Related docs:**
- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

### 2. Windows BYOD

This area shows that personal Windows devices were represented differently from corporate‑managed devices.
- enrollment of personally owned Windows devices
- clear ownership distinction inside the managed estate

**Start here:**
- [Windows BYOD Folder](intune/intune-windows-byod/)

**Best evidence:**
- [Corporate and BYOD visibility](intune/intune-windows-byod/05-intune-windows-devices-corp-and-byod.png)

**Related docs:**
- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)

---

### 3. Windows Autopilot + ESP (Advanced Validation)

This area demonstrates modern, cloud‑led Windows provisioning, added after the baseline.
- Autopilot deployment profile assigned to a dynamic device group
- ESP device preparation stage (zero‑touch, custom branding)
- device import with group tag assignment

**Start here:**
- [Autopilot Folder](intune/intune-autopilot-esp/)

**Best evidence:**
- [ESP device preparation stage](intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png)
- [Device imported with profile assigned](intune/intune-autopilot-esp/07-autopilot-device-imported-profile-assigned-belfast-pilot.png)

**Related docs:**
- [Endpoint Enrollment (Autopilot section)](../../../docs/release1/04-endpoint-enrollment.md)

---

### 4. Windows LAPS (Advanced Validation)

This area shows full Windows LAPS retrieval and a realistic post‑Autopilot remediation scenario.
- password retrieval from Intune admin centre
- missing account fix via `EnableLapsAccount.ps1` script and device‑targeted security group

**Start here:**
- [LAPS Remediation Folder](intune/intune-autopilot-laps/)

**Best evidence:**
- [LAPS password retrieval after remediation](intune/intune-autopilot-laps/07-laps-password-retrieval-success-after-remediation-desktop-cdniaqb.png)

**Related docs:**
- [Endpoint Compliance and Security (LAPS section)](../../../docs/release1/05-endpoint-compliance-and-security.md)

---

### 5. Win32 Application Deployment (Advanced Validation)

This area validates the full application lifecycle management workflow in Intune.
- packaging a Win32 app (Notepad++) with `IntuneWinAppUtil`
- creation, install/uninstall commands, assignment
- successful install status (device and user views)

**Start here:**
- [App Deployment Folder](intune/intune-app-deployment/)

**Best evidence:**
- [App overview – installed summary](intune/intune-app-deployment/05-win32-app-overview-installed-summary-two-devices-notepadplusplus.png)
- [Device install status](intune/intune-app-deployment/06-win32-app-device-install-status-notepadplusplus-win11-bel-02-win11-bel-157.png)

**Related docs:**
- [Endpoint Overview (app deployment section)](../../../docs/release1/03-endpoint-overview.md)

---

### 6. iPhone BYOD

This area shows that the endpoint model extends to mobile devices, not only traditional Windows machines.
- Company Portal enrollment
- identity‑linked access on a personal iPhone

**Start here:**
- [iPhone BYOD Folder](intune/intune-ios/iphone13-byod-enrollment/)

**Best evidence:**
- [iPhone BYOD enrollment complete](intune/intune-ios/iphone13-byod-enrollment/14-company-portal-enrollment-complete.png)

**Related docs:**
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)

---

### 7. Ubuntu Linux Visibility

This area demonstrates platform diversity, showing that Linux visibility is part of the endpoint estate.
- Intune agent‑based onboarding
- visible managed device record

**Start here:**
- [Linux Folder](intune/intune-linux/)

**Best evidence:**
- [Ubuntu Linux device visible in Intune](intune/intune-linux/08-intune-linux-device-visible.png)

**Related docs:**
- [Endpoint Enrollment (Linux section)](../../../docs/release1/04-endpoint-enrollment.md)

---

### 8. Compliance, Protection & Recovery

This area collects the compliance and security control evidence.
- compliance policies, security baselines, WUfB update rings
- BitLocker recovery, stale‑record cleanup, restored compliant state

**Start here:**
- [Compliance Policy Folder](intune/intune-compliance-policy/)
- [Security Baseline Folder](intune/intune-security-baseline/)
- [Windows Update Folder](intune/intune-windows-update/)
- [BitLocker Recovery Folder](intune/intune-bitlocker-recovery-scenario/)

**Best evidence:**
- [Compliance policy non‑compliant result](intune/intune-compliance-policy/04-compliance-policy-results-overview-noncompliant.png)
- [Compliance restored after re‑enrollment](intune/intune-bitlocker-recovery-scenario/07-win11-corp01-compliance-restored-after-reenrollment.png)

**Related docs:**
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](../../../docs/release1/06-recovery-scenarios.md)

---

### 9. Graph‑Assisted Support (Advanced Validation)

This area contains scripts and screenshots that help support teams (helpdesk, L3) operate without portal dependency.
- `Get-BelfastManagedDeviceState.ps1` for device compliance and management status
- `Rename-BelfastManagedDevice.ps1` with dry‑run safety

> The script outputs are stored under `../../identity-and-access/identity-operations/graph-powershell/`, linked from this hub across domains.

**Start here:**
- [Graph PowerShell Scripts Folder](../../identity-and-access/identity-operations/graph-powershell/)
- [Autopilot Support Scripts](../../../scripts/release1/autopilot/graph-support/)

**Best evidence:**
- [Managed device state script output](../../identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png)
- [Rename device apply success](../../identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png)

**Related docs:**
- [Monitoring (Graph/PowerShell section)](../../../docs/release1/08-monitoring.md)

---

## Relationship to the Documentation

This evidence hub works alongside the written documentation. Use the **documentation** for architecture, rationale, and lessons. Use the **screenshots** for visible proof of state, outcome, and recovery.

- [Endpoint Overview](../../../docs/release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../../../docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../../../docs/release1/05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](../../../docs/release1/06-recovery-scenarios.md)

## Scope Boundaries

The endpoint management evidence set is strong for the implemented scope, but it does **not** claim coverage of every possible endpoint scenario.

Examples of intentionally deferred or partial areas include:
- Android BYOD / MAM (not yet evidenced)
- macOS management (not in scope)
- full enterprise PKI / AD CS (Let’s Encrypt / `win-acme` used for hybrid validation)
- full Microsoft Defender for Endpoint stack (EDR, advanced hunting)

These items are tracked in:
- [Build Checklist](../../../docs/release1/11-build-checklist.md)
- [Extensions and Future Enhancements](../../../docs/release1/12-extensions-and-future-enhancements.md)

---

## Related Pages

- [Release 1 Evidence Dashboard](../README.md)
- [Skills and Evidence Index](../../../docs/foundation/05-skills-and-evidence-index.md)
- [Root README](../../../README.md)