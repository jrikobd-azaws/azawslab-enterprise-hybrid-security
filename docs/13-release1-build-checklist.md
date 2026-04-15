# Release 1 Build Checklist

## Purpose

This checklist is the authoritative task-state tracker for Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

Release 1 focuses on building the hybrid identity, messaging, Microsoft 365, endpoint, security, compliance, and monitoring foundations required for a realistic enterprise-style hybrid platform.

This file reflects actual implementation state, not just original planning.

---

## Release 1 Scope Summary

Release 1 includes:

- Hyper-V-based on-premises foundation
- Active Directory with DC1 and DC2
- tiered OU structure, users, and groups
- member server build
- Exchange Server Subscription Edition (Exchange SE) source platform
- Microsoft 365 tenant onboarding
- Entra Connect pilot synchronization
- pilot licensing and cloud sign-in validation
- Modern Hybrid readiness and pilot migration path
- Exchange Online, Teams, and SharePoint baseline
- Intune endpoint administration
- Windows, Android, and Linux management scenarios
- Zero Trust baseline controls
- Defender / endpoint protection controls
- information protection controls
- monitoring and alerting baseline
- compliance mapping and implementation evidence

---

## Status Key

- **Completed** = built, validated, and ready to document with evidence
- **In Progress** = actively implemented, partially working, or under documentation/evidence refinement
- **Pending** = not yet started or intentionally sequenced later in Release 1

---

## 1. Core On-Premises Foundation

| Item | Status | Notes |
|---|---|---|
| Hyper-V lab foundation prepared | Completed | Primary lab platform in use |
| Internal switch `AZAWSLAB-Internal` configured | Completed | Internal lab network in place |
| Host NAT enabled | Completed | Supports connectivity from the lab |
| Base image prepared for Windows Server deployment | Completed | Evidence captured in screenshots |
| AD DS domain created: `corp.azawslab.co.uk` | Completed | Core identity source established |
| `DC1` deployed | Completed | Primary DC / DNS |
| `DC1` promotion completed | Completed | AD DS and DNS operational |
| `DC1` health validation completed | Completed | Includes `dcdiag` / DNS validation evidence |
| `DC2` deployed | Completed | Additional DC / DNS |
| `DC2` promotion completed | Completed | Additional domain controller operational |
| DNS validation completed | Completed | Name resolution validated |
| AD replication validated | Completed | Includes `repadmin` / replication checks |
| Tiered OU structure implemented | Completed | Supports cleaner identity governance |
| Standard users created | Completed | Located under `Tier-2 > User Accounts > Standard Users` |
| Baseline groups created | Completed | Includes pilot sync group scope |
| Pilot sync group `SG-Pilot-Hybrid-Sync` configured | Completed | Used for scoped synchronization |

---

## 2. Member Server and Exchange Source Platform

| Item | Status | Notes |
|---|---|---|
| `MEM1` deployed and domain joined | Completed | Hosts Entra Connect Sync |
| `EXCH1` deployed and domain joined | Completed | Exchange source host |
| Exchange Server Subscription Edition installed on `EXCH1` | Completed | Exchange SE, not Exchange 2019 |
| Exchange prerequisites completed | Completed | Evidence captured in Exchange build screenshots |
| Exchange administration access validated | Completed | Exchange Admin Center accessible |
| On-premises pilot mailboxes prepared | Completed | Pilot mailboxes created and validated |
| Pilot mailbox candidates confirmed | Completed | `u.finance01`, `u.hr01` |
| Validation/admin account confirmed | Completed | `u.hashibur` |

---

## 3. Microsoft 365 Tenant and Namespace Onboarding

| Item | Status | Notes |
|---|---|---|
| Microsoft 365 tenant created | Completed | `AZAWSLABUK.onmicrosoft.com` |
| Cloud admin account established | Completed | `Hashib@AZAWSLABUK.onmicrosoft.com` |
| `azawslab.co.uk` added to tenant | Completed | Root business namespace |
| `corp.azawslab.co.uk` added to tenant | Completed | Dedicated hybrid pilot namespace |
| Domain verification completed | Completed | Evidence captured in M365 screenshots |
| Namespace separation decision documented | Completed | Root stays with Zoho, subdomain used for hybrid pilot |
| Root namespace mail flow preserved on Zoho | Completed | Avoids disruption during pilot hybrid work |

---

## 4. Hybrid Identity

| Item | Status | Notes |
|---|---|---|
| Entra Connect installed on `MEM1` | Completed | Sync host established |
| Password Hash Synchronization configured | Completed | Selected sign-in method |
| OU filtering configured | Completed | Pilot-scoped sync design |
| Group-based filtering configured | Completed | Uses `SG-Pilot-Hybrid-Sync` |
| Optional sync features reviewed/configured | Completed | Evidence captured in Entra Connect flow |
| Pilot users synchronized to tenant | Completed | `u.hashibur`, `u.finance01`, `u.hr01` |
| Pilot users visible in Entra admin center | Completed | Sync validated |
| Pilot users visible in Microsoft 365 admin center | Completed | Sync validated |
| Pilot licenses assigned | Completed | Licensing completed |
| Pilot cloud sign-in validated | Completed | At least one pilot user validated |
| Microsoft 365 web app access validated | Completed | Includes apps such as Designer / Excel web |
| Outlook on the web pre-migration behavior reviewed | Completed | Mailbox-not-found treated as expected pre-migration state |
| Entra admin role separation fully documented | In Progress | Technical implementation partly complete, documentation still needs tightening |

---

## 5. Exchange Hybrid Readiness

| Item | Status | Notes |
|---|---|---|
| Hybrid path decision finalized | Completed | Modern Hybrid |
| HCW mode finalized | Completed | Minimal |
| HCW execution host selected | Completed | `EXCH1` |
| Hybrid Agent installation completed | Completed | Installed during HCW flow |
| Hybrid Agent registration completed | Completed | Registered successfully |
| Hybrid Agent validation succeeded | Completed | Validation passed after troubleshooting |
| EWS external URL set correctly | Completed | `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx` |
| MRS Proxy enabled | Completed | Enabled on EWS |
| Extended Protection adjustments completed | Completed | Default Web Site EWS off, Back End EWS required |
| IIS reset completed after changes | Completed | Applied during troubleshooting |
| HCW hybrid configuration phase completed | Completed | Hybrid services configured |
| HCW warning HCW8078 recorded | Completed | Automatic migration endpoint creation failed |
| Certificate trust and name coverage corrected | Completed | Final working SAN cert covered `mail` and `exch1` |
| Migration endpoint creation | Completed | Completed manually after HCW warning |
| Remote move readiness validation | Completed | `Test-MigrationServerAvailability` succeeded |

---

## 6. Pilot Mailbox Migration

| Item | Status | Notes |
|---|---|---|
| Pilot migration scope confirmed | Completed | `u.finance01`, `u.hr01` |
| Exchange Online target readiness validated | Completed | Endpoint and remote move path validated |
| Migration endpoint manually verified or created | Completed | Manual PowerShell recovery path used |
| Pilot migration batch created | Completed | Batch created successfully |
| Pilot migration batch synchronization observed | Completed | Sync state evidenced in screenshots |
| Pilot remote move for `u.finance01` | Completed | Migration completed |
| Pilot remote move for `u.hr01` | Completed | Migration completed |
| Migration completion state validated | Completed | User and batch completion screenshots captured |
| Post-migration mailbox access validation | Completed | Outlook on the web validated |
| Post-migration coexistence validation | In Progress | Pilot mailbox access proven; broader coexistence testing can be extended later |

---

## 7. Microsoft 365 Workload Baseline

| Item | Status | Notes |
|---|---|---|
| Exchange Online admin readiness | Completed | Tenant and migration path working |
| Exchange Online pilot mailbox service validation | Completed | Pilot users validated post-migration |
| Teams baseline | Pending | Not yet started |
| SharePoint baseline | Pending | Not yet started |
| Microsoft 365 admin setup documentation | In Progress | Exchange migration documented, broader service docs still pending |

---

## 8. Endpoint Administration and Intune

| Item | Status | Notes |
|---|---|---|
| Windows 11 managed corporate device scenario | Pending | Not yet started |
| Intune enrollment baseline | Pending | Not yet started |
| Compliance policy baseline | Pending | Not yet started |
| Configuration profile baseline | Pending | Not yet started |
| Windows joined vs registered comparison | Pending | Not yet started |
| Android BYOD / MAM scenario | Pending | Not yet started |
| Linux support path documentation | Pending | Not yet started |
| Ansible baseline for Linux | Pending | Not yet started |

---

## 9. Endpoint Security and Zero Trust

| Item | Status | Notes |
|---|---|---|
| MFA baseline | Pending | Not yet started |
| Conditional Access baseline | Pending | Not yet started |
| Compliant-device logic | Pending | Not yet started |
| Unmanaged-device access test | Pending | Not yet started |
| Defender / endpoint protection baseline | Pending | Not yet started |
| Antivirus / policy review | Pending | Not yet started |
| ASR rules baseline | Pending | Not yet started |
| Ransomware resilience controls | Pending | Not yet started |

---

## 10. Information Protection

| Item | Status | Notes |
|---|---|---|
| Sensitivity labels | Pending | Not yet started |
| DLP baseline | Pending | Not yet started |
| Sensitive Information Types usage | Pending | Not yet started |
| Document fingerprinting example | Pending | Not yet started |
| Purview evidence capture | Pending | Not yet started |

---

## 11. Monitoring and Alerting

| Item | Status | Notes |
|---|---|---|
| Entra sign-in log visibility baseline | Pending | Not yet started |
| Audit log baseline | Pending | Not yet started |
| Device visibility baseline | Pending | Depends partly on Intune phase |
| Example alert configuration | Pending | Not yet started |
| Monitoring documentation | Pending | Not yet started |

---

## 12. Security and Compliance Mapping

| Item | Status | Notes |
|---|---|---|
| Release 1 control mapping structure created | Completed | Mapping document exists |
| Hybrid identity controls reflected in mapping | In Progress | Needs refresh based on actual implemented state |
| Messaging / hybrid readiness controls reflected in mapping | In Progress | Needs refresh based on completed migration path |
| Endpoint / Zero Trust / Purview controls reflected | Pending | Wait until implementation exists |
| Final evidence-linked mapping pass | Pending | End-of-release task |

---

## 13. Evidence and Documentation Closeout

| Item | Status | Notes |
|---|---|---|
| Hyper-V base image evidence captured | Completed | Evidence exists in screenshot tree |
| Core AD/DNS evidence captured | Completed | DC1 / DC2 build and validation screenshots present |
| OU / identity evidence captured | Completed | OU, groups, and pilot sync group evidenced |
| M365 tenant evidence captured | Completed | Domain verification and onboarding screenshots present |
| Entra Connect and sync evidence captured | Completed | Sync configuration and pilot user evidence present |
| Exchange source evidence captured | Completed | EXCH1 build and EAC screenshots present |
| Pilot licensing and sign-in evidence captured | In Progress | Some evidence exists; final organization may still improve |
| HCW warning evidence captured | Completed | HCW8078 screenshots captured |
| Migration endpoint evidence captured | Completed | Manual endpoint creation captured |
| Migration validation evidence captured | Completed | `Test-MigrationServerAvailability` success captured |
| Pilot batch and migration completion evidence captured | Completed | Batch, user, and completion state captured |
| Post-migration Outlook validation evidence captured | Completed | OWA evidence captured |
| `README.md` status updated | Pending | Update with final implementation state |
| `docs/03-current-state-architecture.md` updated | Pending | Needs built-state refresh |
| `docs/05-hybrid-identity.md` updated | Pending | Needs final hybrid state refresh |
| `docs/06-m365-modern-workplace.md` updated | Pending | Needs final migration outcome refresh |
| `docs/12-lessons-learned.md` updated | Pending | Add troubleshooting and recovery history |
| This checklist updated | In Progress | Use this file as authoritative status page |
| Excel tracker aligned with GitHub | In Progress | Realignment work underway |

---

## Immediate Next Actions

The next correct execution sequence is:

1. update GitHub pages and tracker sheets to reflect the completed pilot migration state
2. organize screenshots and scripts under clear Release 1 evidence paths
3. continue broader Release 1 implementation for:
   - Teams
   - SharePoint
   - Intune
   - MFA / Conditional Access
   - Defender / endpoint hardening
   - Purview / information protection
   - monitoring and alerting
4. refresh compliance mapping based on implemented evidence

---

## Current Release 1 Summary

### Completed

- Hyper-V foundation
- core AD / DNS
- member server build
- Exchange Server Subscription Edition source build
- pilot mailbox preparation
- Microsoft 365 tenant setup
- Entra Connect pilot sync
- pilot licensing and sign-in validation
- Modern Hybrid configuration
- certificate correction and migration endpoint recovery
- migration path validation
- pilot mailbox migration for selected users
- post-migration Outlook on the web validation

### Current Active Phase

- GitHub / tracker evidence closeout
- continuation into the remaining modern workplace, endpoint, security, and compliance layers of Release 1

### Next Milestone

- broader Release 1 Microsoft 365, endpoint, Zero Trust, monitoring, and information protection implementation

---

## Notes

This checklist should remain aligned to actual implementation state.

Do not downgrade completed work back to planning language, and do not mark later security or modern workplace controls as implemented until evidence exists.