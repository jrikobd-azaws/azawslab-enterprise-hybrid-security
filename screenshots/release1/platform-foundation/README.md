# Platform Foundation Evidence Hub

## Purpose

This page is the guided evidence index for the platform-foundation portion of the implemented environment.

It exists to make the infrastructure and lab-foundation screenshots easier to review by grouping evidence around the base delivery layer that supported the wider platform:
- Hyper-V foundation
- host networking and NAT
- reusable image and differencing-disk workflows
- core domain controller build steps
- Exchange server build steps
- Microsoft 365 tenant setup context
- supporting member-server build steps

This page should be read as an evidence hub, not as a narrative implementation document.

---

## What This Evidence Set Proves

The platform-foundation evidence demonstrates that the implemented environment was built on a deliberate local infrastructure base rather than on disconnected cloud screenshots.

It shows:
- Hyper-V as the local virtualization platform
- internal virtual switch configuration and host NAT for controlled hybrid testing
- reusable image and differencing-disk workflows
- domain controller build and promotion steps
- Exchange server build preparation
- Microsoft 365 tenant setup context
- supporting member-server build steps tied to the wider estate

This evidence matters because it proves that the higher-level Microsoft 365, Intune, and hybrid identity work was grounded in a coherent platform rather than assembled as separate demos.

---

## How to Use This Hub

Use this page in one of three ways:

- **Start with flagship proof** if you want the shortest route to the strongest infrastructure screenshots
- **Browse by foundation area** if you want to inspect Hyper-V, server build, or tenant setup evidence
- **Follow the related docs** if you want the architecture explanation behind the screenshots

This hub is designed to reduce click fatigue while still preserving access to the full underlying screenshot set.

---

## Start Here: Flagship Proof

| Proof Area | What it demonstrates | Best evidence |
| :--- | :--- | :--- |
| **Hyper-V virtual switch foundation** | Local virtualization and network foundation for the lab estate | [Hyper-V Virtual Switch Manager](hyper-v-foundation/01.%20Hyper-V%20Virtual%20Switch%20Manager.png) |
| **Host NAT configuration** | Controlled outbound connectivity for isolated hybrid testing | [Enable NAT at host](hyper-v-foundation/02.%20Enable%20Nat%20at%20host.png) |
| **Reusable master image** | Base-image reuse rather than one-off manual VM creation | [Master image read-only](hyper-v-foundation/05.%20Master%20Image%20readonly.png) |
| **DC1 VM creation** | Primary domain controller built as part of the on-premises identity foundation | [New VM for DC1 summary](dc1-build/02.%20New%20VM%20for%20DC1_Summary.png) |
| **DC2 differencing-disk build** | Additional domain controller created using reusable disk workflow | [Create DC2 VM using differencing disk](dc2-build/02-create-dc2-vm-using-diff-disk.png) |
| **Member server differencing disk** | Reuse pattern extended to supporting server builds | [MEM1 differencing disk](mem1-build/01-mem1-differencing-disk.png) |

---

## Evidence by Foundation Area

### 1. Hyper-V Foundation

This area provides the clearest proof that the environment was built on a real local virtualization base.

It supports:
- Hyper-V host configuration
- internal switch setup
- host NAT
- master-image preparation
- reusable VM delivery patterns

Start here:
- [Hyper-V Foundation Folder](hyper-v-foundation/)

Best evidence:
- [Hyper-V Virtual Switch Manager](hyper-v-foundation/01.%20Hyper-V%20Virtual%20Switch%20Manager.png)
- [Enable NAT at host](hyper-v-foundation/02.%20Enable%20Nat%20at%20host.png)
- [Master image read-only](hyper-v-foundation/05.%20Master%20Image%20readonly.png)

Related docs:
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)
- [Target-State Architecture](../../../docs/foundation/03-target-state-architecture.md)
- [Release 1 README](../../../docs/release1/README.md)

---

### 2. AD Identity Foundation

This area shows that the identity base was structured deliberately before hybrid work began.

It supports:
- OU structure
- security-group creation
- pilot hybrid-sync group membership

Start here:
- [AD Identity Foundation Folder](ad-identity-foundation/)

Best evidence:
- [OU structure and standard users](ad-identity-foundation/01-ou-structure-and-standard-users.png)
- [Security groups created](ad-identity-foundation/02-security-groups-created.png)
- [Pilot hybrid-sync group membership](ad-identity-foundation/03-sg-pilot-hybrid-sync-membership.png)

Related docs:
- [Hybrid Identity](../../../docs/release1/01-hybrid-identity.md)
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)

---

### 3. DC1 Build

This area shows the initial domain controller build path.

It supports:
- first DC VM creation
- basic network setup
- AD DS and DNS installation
- domain promotion
- post-promotion validation

Start here:
- [DC1 Build Folder](dc1-build/)

Best evidence:
- [New VM for DC1 summary](dc1-build/02.%20New%20VM%20for%20DC1_Summary.png)
- [Install AD and DNS on DC1](dc1-build/04.%20Install%20AD%20and%20DNS%20on%20DC1.png)
- [Successfully promoted DC1](dc1-build/06.%20Successfully%20promoted%20dc1.png)

Related docs:
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)
- [Hybrid Identity](../../../docs/release1/01-hybrid-identity.md)

---

### 4. DC2 Build

This area shows that the environment moved beyond a single-domain-controller setup and used reusable VM delivery patterns.

It supports:
- differencing-disk reuse
- additional domain-controller build
- replication and post-promotion validation

Start here:
- [DC2 Build Folder](dc2-build/)

Best evidence:
- [Create new differencing virtual disk](dc2-build/01-create-new-differencing-virtual-disk.png)
- [Create DC2 VM using differencing disk](dc2-build/02-create-dc2-vm-using-diff-disk.png)
- [DC2 successfully synced user group OU](dc2-build/08.dc2-successfully-synced-user-group-ou.png)

Related docs:
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)
- [Hybrid Identity](../../../docs/release1/01-hybrid-identity.md)

---

### 5. Exchange Server Build

This area provides the on-premises Exchange build context behind the hybrid messaging work.

It supports:
- Exchange server preparation
- domain join
- prerequisite handling
- setup completion
- EAC access

Start here:
- [Exchange Server Build Folder](exch1-build/)

Best evidence:
- [Exchange server prerequisite preparation](exch1-build/05-exch1-prerequisite-exchangesrv.png)
- [Exchange setup completed](exch1-build/07-exch1-setup-completed.png)
- [Exchange EAC opened](exch1-build/09-exch1-eac-opened.png)

Related docs:
- [Modern Workplace](../../../docs/release1/02-modern-workplace.md)
- [Release 1 README](../../../docs/release1/README.md)

---

### 6. Microsoft 365 Tenant Setup

This area provides the tenant-side setup context behind the hybrid and service-validation work.

It supports:
- Microsoft 365 admin-center readiness
- domain-verification steps
- tenant setup progression

Start here:
- [M365 Tenant Setup Folder](m365-tenant-setup/)

Best evidence:
- [M365 admin center home](m365-tenant-setup/01-m365-admin-center-home.png)
- [M365 domain TXT verification instructions](m365-tenant-setup/02-m365-domain-txt-verification-instructions.png)
- [M365 domains page verified](m365-tenant-setup/05-m365-domains-page-verified.png)

Related docs:
- [Modern Workplace](../../../docs/release1/02-modern-workplace.md)
- [Release 1 README](../../../docs/release1/README.md)

---

### 7. Member Server Build

This area shows that reusable VM-delivery patterns extended beyond domain controllers into supporting server roles.

It supports:
- differencing-disk reuse
- new VM creation
- domain join
- server placement inside the intended OU structure

Start here:
- [MEM1 Build Folder](mem1-build/)

Best evidence:
- [MEM1 differencing disk](mem1-build/01-mem1-differencing-disk.png)
- [MEM1 new VM](mem1-build/02-mem1-newVM.png)
- [MEM1 domain join verify](mem1-build/03-mem1-domain-join-verify.png)

Related docs:
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)
- [Lessons Learned](../../../docs/release1/10-lessons-learned.md)

---

## Recommended Review Path

If you want the shortest route through the platform-foundation evidence, use this order:

1. [Hyper-V Virtual Switch Manager](hyper-v-foundation/01.%20Hyper-V%20Virtual%20Switch%20Manager.png)
2. [Enable NAT at host](hyper-v-foundation/02.%20Enable%20Nat%20at%20host.png)
3. [Master image read-only](hyper-v-foundation/05.%20Master%20Image%20readonly.png)
4. [New VM for DC1 summary](dc1-build/02.%20New%20VM%20for%20DC1_Summary.png)
5. [Create DC2 VM using differencing disk](dc2-build/02-create-dc2-vm-using-diff-disk.png)
6. [Exchange setup completed](exch1-build/07-exch1-setup-completed.png)
7. [M365 domains page verified](m365-tenant-setup/05-m365-domains-page-verified.png)

This sequence gives the fastest understanding of:
- Hyper-V host foundation
- network and isolation context
- reusable image strategy
- core server delivery
- messaging-service preparation
- tenant setup context

---

## Relationship to the Documentation

Use the documentation when you want:
- architecture
- environment rationale
- release context
- business value
- explanation of how the platform supports later workloads

Use this evidence hub when you want:
- visible proof that the platform was built on a real infrastructure base
- quick verification that Hyper-V and host-backed lab delivery were part of the implementation story
- concrete proof of reusable VM build patterns and supporting server setup

Best related reading path:
- [Root README](../../../README.md)
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)
- [Target-State Architecture](../../../docs/foundation/03-target-state-architecture.md)
- [Release 1 README](../../../docs/release1/README.md)

---

## Scope Boundaries

This evidence set supports the platform foundation, but it should be read carefully.

It does **not** imply:
- a production datacenter deployment
- VMware / vSphere delivery in this phase
- full enterprise virtualization governance beyond the implemented lab foundation

Those areas may become relevant in later extensions, but they are not part of the implemented scope here.

---

## Related Pages

- [Release 1 Evidence Dashboard](../README.md)
- [Platform Overview](../../../docs/foundation/01-platform-overview.md)
- [Release 1 README](../../../docs/release1/README.md)
- [Root README](../../../README.md)