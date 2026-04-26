---

## Advanced Validation Added After Baseline

The following capabilities were implemented after the core Release 1 baseline was completed. They extend the endpoint enrollment story with modern cloud‑led provisioning (Windows Autopilot and Enrollment Status Page) and Graph‑assisted operational support for device state visibility and management. Evidence was captured in a compatible environment that preserved the existing platform naming and domain context for consistency.

---

### Advanced Validation: Windows Autopilot and ESP

**What was validated**

Windows Autopilot and Enrollment Status Page (ESP) were introduced as an advanced validation layer to demonstrate cloud‑led Windows onboarding alongside the existing manual enrollment paths. The validation covers:

- Autopilot deployment profile assignment to a dynamic device group
- ESP profile configuration (device preparation and account setup stages)
- Company branding visible during the sign‑in experience
- Device import with group tag assignment
- Zero‑touch, user‑driven provisioning through Out‑of‑Box Experience (OOBE)
- Post‑enrollment managed state in Intune

**Why this matters**

Autopilot and ESP are market‑relevant capabilities for modern endpoint management. Adding them after the baseline shows that the platform can evolve from traditional manual enrollment into a more automated, user‑friendly provisioning model without breaking the existing control story.

**Implementation context**

During implementation, the original Azure VM path was not suitable for producing clean, end‑to‑end Autopilot OOBE and ESP validation because of limitations in the Azure nested virtualisation and network experience. To maintain technical credibility, the validation was moved to a local Hyper‑V workflow where the provisioning sequence, ESP stages, and post‑enrollment state could be captured properly.

**Key steps and evidence**

- An Autopilot deployment profile (`R1-Autopilot-Corp-Belfast`) was created and assigned to the dynamic device group `SG-Autopilot-Win-Belfast`.
- An ESP profile (`R1-ESP-Corp-Belfast`) was configured with both device preparation and account setup stages, then assigned to the same group.
- Company branding assets were configured, appearing during the OOBE sign‑in flow.
- A test device was imported into Autopilot using a group tag (`Belfast-Pilot`) to control profile assignment.
- The device was reset, and the user‑driven OOBE flow started with the customised sign‑in screens.
- ESP progressed through the device preparation stage (screenshot captured).
- After completion, the device appeared in Intune as a managed corporate asset.

**Flagship evidence**

![Autopilot device imported with profile assigned](../../screenshots/release1/endpoint-management/intune/intune-autopilot-esp/07-autopilot-device-imported-profile-assigned-belfast-pilot.png)

*Autopilot device import showing group tag `Belfast-Pilot` and successful profile assignment, demonstrating that the device was correctly associated with the intended deployment profile.*

![ESP device preparation stage working](../../screenshots/release1/endpoint-management/intune/intune-autopilot-esp/11-esp-device-preparation-stage-working.png)

*ESP device preparation stage during provisioning. The account setup stage was also configured and validated operationally, but its screenshot was not captured separately; the end‑to‑end workflow completed successfully.*

**Outcome**

Windows Autopilot and ESP are now validated as an additional provisioning path alongside existing manual enrollment methods. The platform can support both traditional IT‑led onboarding and modern user‑driven, zero‑touch provisioning.

---

### Advanced Validation: Graph‑Assisted Autopilot Operational Support

**What was validated**

A separate operational validation was added to show how Graph/PowerShell can support Autopilot and broader device management activities. This is not a diagnostics console (Shift+F10) scenario, but rather administrative scripting that provides visibility and control over device state.

The validation includes:

- Querying Autopilot device state using `Get-BelfastAutopilotDeviceState.ps1`
- Retrieving managed device state details via `Get-BelfastManagedDeviceState.ps1`
- Performing a managed device rename using `Rename-BelfastManagedDevice.ps1` (dry‑run and apply)

**Why this matters**

Operational tooling is a key differentiator between a “configured platform” and a “supportable platform”. These scripts demonstrate that an administrator can programmatically check provisioning status, validate device objects, and correct naming issues without relying solely on portal UI. This is especially relevant for supporting Autopilot at scale.

**Implementation and evidence**

- The Graph PowerShell SDK was connected with appropriate delegated permissions (consent scoped to user read/write, device read/write, and organisation read).
- `Get-BelfastAutopilotDeviceState.ps1` was executed to confirm the presence and status of Autopilot‑enrolled devices.
- `Get-BelfastManagedDeviceState.ps1` returned detailed compliance and management state for a specific device.
- `Rename-BelfastManagedDevice.ps1` was run first in dry‑run mode to preview the change, then in apply mode to rename `desktop-cdniaqb` to `win11-bel-02`.

**Flagship evidence**

![Managed device state script result](../../screenshots/release1/identity-and-access/identity-operations/graph-powershell/08-managed-device-state-script-result-desktop-cdniaqb.png)

*Output of `Get-BelfastManagedDeviceState.ps1` showing detailed device properties, compliance state, and management status. This proves that administrative visibility can be scripted rather than only accessed through the portal.*

![Rename managed device apply](../../screenshots/release1/identity-and-access/identity-operations/graph-powershell/09-rename-managed-device-apply-desktop-cdniaqb-to-win11-bel-02.png)

*Successful apply of the device rename operation via `Rename-BelfastManagedDevice.ps1`, demonstrating script‑controlled device management alongside the Autopilot provisioning workflow.*

**Outcome**

Graph‑assisted operational support for Autopilot and device management is validated. The platform now includes reusable scripts that provide state visibility and control actions, strengthening its supportability story.

---

## Updated Scope Boundaries

The Autopilot and Graph‑assisted advanced validation sections above **do not** claim:

- enterprise‑wide Autopilot deployment maturity
- full Graph orchestration of ESP behaviour (ESP remains policy‑driven, not script‑controlled)
- Shift+F10 or diagnostics console evidence (the validation uses script outputs, not interactive troubleshooting screenshots)
- coverage for non‑Windows platforms in the Autopilot path

The evidence is limited to the pilot Windows corporate device set and the specific operational scripts shown. Broader Autopilot rollouts, additional diagnostics workflows, and Graph automation for full lifecycle management remain future enhancement areas.