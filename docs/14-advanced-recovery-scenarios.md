# Advanced Recovery Scenarios

**Navigation:** [README](../README.md) | [Release 1 Build Checklist](16-release1-build-checklist.md) | [Release 1 Final Summary](17-release1-final-summary.md)

**Endpoint docs:** [Endpoint Security and Intune Overview](07-endpoint-security-intune.md) | [Endpoint Platforms and Enrollment](08-endpoint-platforms-and-enrollment.md) | [Endpoint Compliance and Security Baseline](09-endpoint-compliance-and-security-baseline.md)

---

## Purpose

This document records the **advanced operational recovery scenarios** encountered during Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

The purpose of this document is to capture what happened when endpoint controls moved beyond happy-path enrollment and into real operational complexity.

The most important scenario in this phase involved:

- BitLocker-protected Windows device recovery
- virtual hardware change / rebuild conditions
- trust break and re-enrollment
- duplicate and stale cloud-managed device records
- cleanup and restoration of healthy device state

This document is intentionally separate from the normal enrollment and compliance pages, because these scenarios are not standard onboarding steps. They are **operational recovery and lifecycle-management lessons**.

---

## Scope of This Document

This document covers:

- BitLocker recovery prompt and escrowed key usage
- device rebuild / re-enrollment sequence
- broken or unhealthy work/school trust after hardware-context change
- stale device record cleanup in Intune / Entra
- governance lessons from recovery-key access
- practical recovery priorities such as Windows LAPS

This document does **not** focus on:

- basic device enrollment
- general compliance policy detail
- security baseline assignment detail
- Linux and iPhone platform onboarding

Those are covered in:

- `08-endpoint-platforms-and-enrollment.md`
- `09-endpoint-compliance-and-security-baseline.md`

---

## Why Recovery Scenarios Matter in Release 1

A lot of lab projects stop at:

- device enrolled
- policy applied
- compliant badge shown

Release 1 goes further than that.

This project also includes evidence for what happened when:

- endpoint encryption mattered operationally
- hardware context changed
- cloud trust became unhealthy
- the original device-management relationship no longer behaved normally
- stale cloud records had to be cleaned up manually

This is one of the strongest technical sections in the repo because it shows operational realism, not just control activation.

---

## Main Advanced Scenario in Release 1

The primary advanced recovery scenario in Release 1 is:

### BitLocker Recovery, Device Rebuild, and Stale Record Cleanup

This scenario was centered on the Windows corporate pilot device:

- `WIN11-CORP01`

It began as a normal managed Windows device under the endpoint security baseline and later became a recovery and lifecycle-management case.

---

## Scenario Starting State

Before the recovery issue occurred, the Windows corporate device had already been through the managed endpoint path.

The device had:

- enrolled into Intune
- appeared in Microsoft Entra ID
- been used in the Windows compliance policy path
- been used in the Windows security baseline path
- participated in BitLocker-related control testing

This means the scenario did not start from a broken device. It started from a managed and policy-relevant corporate endpoint.

---

## What Triggered the Scenario

The recovery scenario was tied to a **virtual hardware / rebuild context** in the Hyper-V-based lab environment.

The practical sequence was:

- the Windows corporate VM had BitLocker in scope
- the virtual machine shell was later removed / recreated
- the existing disk / operating-system state was reused
- the hardware-context relationship was no longer the same as before

In practical terms, this created a situation similar to a hardware replacement / platform rebuild style event for the managed device.

---

## Observed BitLocker Recovery Behavior

After the virtual hardware context changed, the device entered a BitLocker recovery path.

### What was observed

The evidence showed:

- a BitLocker recovery prompt
- the need for the recovery key to continue
- successful recovery-key retrieval from Microsoft Entra ID

### Why this mattered

This proved a very important operational point:

**recovery-key escrow was not theoretical. It was required in practice.**

Without that escrowed key, the encrypted device state would not have been recoverable in the same way.

---

## Recovery-Key Escrow Value

One of the strongest lessons from this scenario is that BitLocker key escrow must be treated as an operational requirement, not only a security checkbox.

### What this scenario proved

It proved that:

- the key had been escrowed
- the key was retrievable
- the key could be used when recovery became necessary

### Why that is important

This turns BitLocker from:
- “a policy item in a portal”

into:
- “a real control that can either preserve or destroy recoverability depending on whether escrow is managed correctly”

That is a valuable enterprise lesson.

---

## Trust and Sign-In State After Recovery

Recovering the encrypted disk was **not the same thing** as restoring a healthy device-management state.

After the recovery event, the prior work/school trust state on the device was no longer healthy enough to treat the system as fully recovered.

### What was observed

The evidence showed:

- work/school account repair or sign-in problems
- the original healthy trust state was no longer behaving normally
- the device needed a more complete rebuild / re-enrollment approach

### Correct interpretation

The safest and most accurate way to describe this is:

- storage recovery succeeded
- device trust recovery did not fully succeed through that step alone

This is important because it demonstrates that:

**BitLocker recovery and cloud-managed trust recovery are different problems.**

---

## Rebuild and Re-Enrollment Path

Because the device trust state was no longer healthy, the recovery path moved beyond simple unlock/restart behavior.

### Practical recovery actions

The recovery path included:

- using the recovery key to regain access
- moving into rebuild / reset style recovery
- re-enrolling the Windows device
- restoring a new healthy managed-device state

### Why this matters

This is where the project becomes much more realistic than a standard lab walkthrough.

It shows that a serious managed-device story must account for:

- rebuild scenarios
- device re-enrollment
- post-recovery management state
- cloud object lifecycle cleanup

---

## Duplicate and Stale Device Records

After the rebuild / re-enrollment path, the environment showed duplicate or stale device-record behavior for the Windows corporate device.

### What was observed

The evidence showed:

- duplicate or stale records associated with `WIN11-CORP01`
- older noncompliant / unhealthy records still visible
- newer healthy record(s) after re-enrollment

### Why this matters

This is an important operational lesson because cloud-managed device inventories do not always clean themselves up automatically in a neat way after disruptive recovery events.

A reader or engineer should understand that:

- the old record can remain behind
- the new re-enrolled record can appear as a fresh device-management relationship
- inventory hygiene then becomes part of endpoint administration

---

## Stale Record Cleanup

The stale records were not left in place as noise.

### What was done

The older, obsolete device records were identified and cleaned up manually so that:

- the active device state was clearer
- reporting was cleaner
- the inventory better reflected the live managed endpoint

### Why this matters

This is a real lifecycle-management activity, not just cosmetic cleanup.

If stale noncompliant objects remain in place, they can distort:

- compliance reporting
- device inventory accuracy
- recovery understanding
- operational clarity during future troubleshooting

---

## Why Windows LAPS Became More Important

This scenario also clarified why Windows LAPS matters.

### The lesson

When:

- a managed endpoint loses healthy cloud trust
- the user is not an admin
- the device is in a broken or semi-recovered state

then local administrative recovery becomes much more important.

### Release 1 implication

This scenario did not prove that Windows LAPS was fully operationally validated yet.

What it did prove is:

- Windows LAPS is not just a nice-to-have hardening feature
- it is also a recovery and supportability control

This is why Windows LAPS belongs in the next hardening layer for Release 1.

---

## Governance Observation: Recovery-Key Access

This scenario also raised a useful governance point around BitLocker recovery-key access.

### What should be said carefully

This project should **not** overclaim that a full insider-threat exploit was demonstrated.

The more accurate and defensible statement is:

- the scenario highlighted a **potential governance risk** around how recovery-key access should be controlled in a production environment

### Why this is important

Recovery convenience and recovery security are not always the same thing.

This suggests that future enterprise hardening should consider:

- who can access recovery keys
- whether access should be self-service or tightly controlled
- how BitLocker fits with broader defense-in-depth measures

This is a design lesson, not a claim of fully tested production abuse simulation.

---

## What This Scenario Proves

This scenario proves several strong points about the Release 1 endpoint design:

- BitLocker key escrow was real and usable
- endpoint controls affect recoverability, not just compliance
- device rebuild can be separate from device trust recovery
- stale cloud records are an operational reality after disruptive recovery events
- manual cleanup can be required to restore inventory accuracy
- Windows LAPS is a meaningful next-step recovery control
- governance around recovery-key access deserves attention

These are all high-value lessons for a recruiter or engineer reviewing the repo.

---

## How This Fits the Broader Endpoint Story

This recovery scenario sits on top of the platform and control layers described elsewhere.

### `08-endpoint-platforms-and-enrollment.md`
Shows how devices were onboarded into the managed environment.

### `09-endpoint-compliance-and-security-baseline.md`
Shows how endpoint controls were applied and how BitLocker mattered as part of that control layer.

### `14-advanced-recovery-scenarios.md`
Shows what happened when those controls met real recovery and lifecycle-management complexity.

This separation is intentional. It keeps the normal endpoint path distinct from the advanced operational scenario.

---

## Evidence Areas

The strongest evidence for this document comes from:

- `screenshots/release1/release1-intune/intune-bitlocker-recovery-scenario/`
- `screenshots/release1/release1-intune/intune-security-baseline/`
- `screenshots/release1/release1-identity-protection/laps/`

These areas support:
- recovery prompt
- key retrieval
- unhealthy trust state
- duplicate/stale object view
- cleanup and restored state
- LAPS direction

---

## Diagram Placement Recommendation

This document is the best place to embed the recovery-scenario diagram.

Recommended diagram:
- `../diagrams/03-bitlocker-recovery-and-stale-device-cleanup-scenario.png`

This should become the main visual for this page.

---

## Suggested Embedded Screenshot Strategy

This page can support a few strong screenshots because the scenario is operational and sequence-based.

Recommended maximum:
- one BitLocker recovery prompt screenshot
- one recovery-key retrieval screenshot
- one stale / duplicate device-record screenshot
- one restored healthy-state screenshot

That is enough to tell the full story clearly.

---

## Why This Matters Professionally

This scenario is one of the strongest technical differentiators in the project.

It shows that Release 1 is not limited to:
- turning controls on
- collecting compliant-state screenshots

It also demonstrates:
- recovery planning
- lifecycle cleanup
- trust-state understanding
- escalation of endpoint management maturity based on what was learned in practice

That is exactly the kind of operational realism that improves recruiter and engineer trust in the project.

---

## Summary

Release 1 includes a genuine advanced endpoint recovery scenario centered on:

- BitLocker recovery
- rebuild / re-enrollment
- stale device cleanup
- Windows LAPS recovery lessons
- governance observations around recovery-key access

This document should remain the dedicated home for **recovery and lifecycle-management complexity** within the endpoint workstream.

It complements the normal enrollment and compliance docs by showing what happened when protection controls were tested under operational stress.