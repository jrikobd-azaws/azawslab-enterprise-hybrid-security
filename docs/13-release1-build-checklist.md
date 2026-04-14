# Release 1 Build Checklist

## Purpose

This checklist is the authoritative task-state tracker for Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

Release 1 focuses on building the hybrid identity, messaging, Microsoft 365, endpoint, security, compliance, and monitoring foundations required for a realistic enterprise-style hybrid platform.

This file should reflect actual implementation state, not just original planning.

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
- **In Progress** = actively implemented, partially working, or under validation
- **Blocked** = implementation halted by a known technical issue
- **Pending** = not yet started or intentionally sequenced later in Release 1

---

## 1. Core On-Premises Foundation

| Item | Status | Notes |
|---|---|---|
| Hyper-V lab foundation prepared | Completed | Primary lab platform in use |
| Internal switch `AZAWSLAB-Internal` configured | Completed | Internal lab network in place |
| Host NAT enabled | Completed | Supports connectivity from the lab |
| AD DS domain created: `corp.azawslab.co.uk` | Completed | Core identity source established |
| `DC1` deployed | Completed | Primary DC / DNS |
| `DC2` deployed | Completed | Additional DC / DNS |
| DNS validation completed | Completed | Name resolution validated |
| AD replication validated | Completed | DC health and replication checked |
| Tiered OU structure implemented | Completed | Supports cleaner identity governance |
| Standard users created | Completed | Located under `Tier-2 > User Accounts > Standard Users` |
| Baseline groups created | Completed | Includes pilot sync group scope |

---

## 2. Member Server and Exchange Source Platform

| Item | Status | Notes |
|---|---|---|
| `MEM1` deployed and domain joined | Completed | Hosts Entra Connect Sync |
| `EXCH1` deployed and domain joined | Completed | Exchange source host |
| Exchange Server Subscription Edition installed on `EXCH1` | Completed | Exchange SE, not Exchange 2019 |
| Exchange administration access validated | Completed | Exchange management available |
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
| Hybrid Agent validation succeeded | Completed | Validation passed |
| EWS external URL set correctly | Completed | `https://mail.corp.azawslab.co.uk/EWS/Exchange.asmx` |
| MRS Proxy enabled | Completed | Enabled on EWS |
| Extended Protection adjustments completed | Completed | Default Web Site EWS off, Back End EWS required |
| IIS reset completed after changes | Completed | Applied during troubleshooting |
| HCW hybrid configuration phase completed | Completed | Hybrid services configured |
| Migration endpoint creation | Blocked | `HCW8078 - Migration Endpoint could not be created` |
| Hybrid validation closeout | In Progress | Blocked specifically at migration endpoint step |
| Remote move readiness validation | Pending | Depends on migration endpoint completion |

---

## 6. Pilot Mailbox Migration

| Item | Status | Notes |
|---|---|---|
| Pilot migration scope confirmed | Completed | `u.finance01`, `u.hr01` |
| Exchange Online target readiness validated | In Progress | Depends on migration endpoint validation |
| Migration endpoint manually verified or created | Pending | Next technical task if HCW does not complete it |
| Pilot remote move for `u.finance01` | Pending | Not yet started |
| Pilot remote move for `u.hr01` | Pending | Not yet started |
| Post-migration mailbox access validation | Pending | OWA / Outlook / mail flow checks needed |
| Post-migration coexistence validation | Pending | Required after first successful moves |

---

## 7. Microsoft 365 Workload Baseline

| Item | Status | Notes |
|---|---|---|
| Exchange Online admin readiness | In Progress | Tenant ready, migration not yet complete |
| Exchange Online pilot mailbox service validation | Pending | Requires mailbox moves |
| Teams baseline | Pending | Not yet started |
| SharePoint baseline | Pending | Not yet started |
| Microsoft 365 admin setup documentation | In Progress | Tenant and domain state known, broader service docs still pending |

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
| Messaging / hybrid readiness controls reflected in mapping | In Progress | Needs refresh based on HCW progress |
| Endpoint / Zero Trust / Purview controls reflected | Pending | Wait until implementation exists |
| Final evidence-linked mapping pass | Pending | End-of-release task |

---

## 13. Evidence and Documentation Closeout

| Item | Status | Notes |
|---|---|---|
| Core AD/DNS evidence captured | In Progress | Some evidence exists, likely needs final organization |
| Exchange source evidence captured | In Progress | Exchange state should be consolidated |
| Entra Connect and sync evidence captured | In Progress | Needs final repository placement |
| Pilot licensing and sign-in evidence captured | In Progress | Must be added consistently |
| HCW progress evidence captured | In Progress | Include partial-success state |
| HCW8078 blocker evidence captured | In Progress | Important troubleshooting artifact |
| `README.md` status updated | Pending | Needs current status refresh |
| `docs/03-current-state-architecture.md` updated | Pending | Needs built-state refresh |
| `docs/05-hybrid-identity.md` updated | Pending | Needs current hybrid state refresh |
| `docs/06-m365-modern-workplace.md` updated | Pending | Needs current M365 / HCW state refresh |
| `docs/12-lessons-learned.md` updated | Pending | Add design decisions and troubleshooting history |
| This checklist updated | In Progress | Use this file as authoritative status page |
| Excel tracker aligned with GitHub | In Progress | Realignment work underway |

---

## Immediate Next Actions

The next correct execution sequence is:

1. complete migration endpoint validation
2. manually verify or create the migration endpoint if required
3. confirm remote-move readiness
4. perform pilot mailbox migration for `u.finance01`
5. perform pilot mailbox migration for `u.hr01`
6. validate post-migration access and behavior
7. update GitHub pages and tracker sheets to reflect actual completed state

---

## Current Release 1 Summary

### Completed
- core AD / DNS
- member server build
- Exchange Server Subscription Edition source build
- pilot mailbox preparation
- Microsoft 365 tenant setup
- Entra Connect pilot sync
- pilot licensing and sign-in validation
- most Modern Hybrid readiness work

### Current Blocker
- `HCW8078 - Migration Endpoint could not be created`

### Current Active Phase
- hybrid validation / migration endpoint completion

### Next Milestone
- mailbox-move readiness and pilot migration execution

---

## Notes

This checklist should remain aligned to actual implementation state.

Do not downgrade completed work back to planning language, and do not mark later security or modern workplace controls as implemented until evidence exists.