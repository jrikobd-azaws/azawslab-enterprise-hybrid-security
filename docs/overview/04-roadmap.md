# Roadmap

**Related navigation:** [README](../../README.md) | [Release 1 Summary](../release1/00-summary.md) | [Release 1 Build Checklist](../release1/11-build-checklist.md)

**Related docs:** [Platform Overview](01-platform-overview.md) | [Target State Architecture](03-target-state-architecture.md) | [Security and Compliance Mapping](../release1/09-compliance-mapping.md)

---

## Purpose

This document defines the phased roadmap for the `azawslab Enterprise Hybrid Security Platform`.

The roadmap explains how the project is intended to evolve from:

- hybrid identity and Microsoft 365 foundations
- into Azure platform governance and MSP-style operations
- and later into workload modernization, resilience, and secure application delivery

The goal of the roadmap is to show that the project is not a disconnected lab exercise. It is a structured platform journey with clear sequencing and increasing maturity over time.

---

## Why the Project Uses a Phased Roadmap

This repository is intentionally organized as a **flagship phased project** rather than many unrelated small labs.

That approach is useful because it shows:

- architectural continuity
- practical implementation sequencing
- technology decisions that build on one another
- operational maturity over time
- a credible learning and engineering progression

The roadmap helps readers understand both:

- what has already been built
- what is intentionally planned next

---

## Roadmap Summary

| Release | Theme | Status |
|---|---|---|
| Release 1 | Secure Hybrid Identity and Modern Workplace | Implemented / maturing |
| Release 2 | Azure Secure Platform and MSP Operations | Planned |
| Release 3 | Secure Workload Modernization and Resilience | Planned |

This should be read as a maturity roadmap, not as a promise that every later item is already scheduled or fully designed in production detail.

---

## Release 1 - Secure Hybrid Identity and Modern Workplace

### Purpose

Release 1 establishes the **hybrid Microsoft foundation** for the project.

It is the phase where the on-premises environment, Microsoft 365 tenant, endpoint platform, and initial security / compliance layers come together.

### Release 1 focus areas

Release 1 includes:

- Hyper-V-based on-premises lab foundation
- Active Directory domain services with DC1 and DC2
- member server and Exchange Server Subscription Edition source platform
- Microsoft 365 tenant setup and namespace onboarding
- Entra Connect pilot synchronization
- Exchange hybrid readiness and pilot migration path
- Exchange Online, Teams, and SharePoint baseline
- Intune endpoint administration and lifecycle management
- Windows corporate and BYOD endpoint onboarding
- Linux visibility through Intune and baseline automation through Ansible
- iPhone BYOD enrollment through Intune Company Portal
- MFA, SSPR, and Conditional Access pilot baseline
- Windows compliance and security baseline
- BitLocker recovery and lifecycle-management lessons
- Purview sensitivity labels and DLP pilot
- monitoring and alerting baseline direction
- compliance mapping and evidence capture

### Release 1 status

Release 1 is not a planning-only phase anymore.

It has already demonstrated practical implementation across:

- hybrid identity
- Exchange pilot migration
- collaboration services
- endpoint enrollment and management
- identity protection pilot controls
- information protection baseline
- recovery and lifecycle lessons

### Remaining Release 1 maturity work

Release 1 still has room to deepen in areas such as:

- Windows configuration profiles
- update rings / patching
- Windows LAPS operational validation
- Defender / endpoint hardening
- monitoring and alerting depth
- document fingerprinting
- final documentation closeout and presentation polish

### Why Release 1 matters

Release 1 is the most important phase in the portfolio because it proves the project can move from architecture into implemented and evidenced Microsoft platform work.

It is the foundation for everything that comes next.

---

## Release 2 - Azure Secure Platform and MSP Operations

### Purpose

Release 2 expands the project from hybrid Microsoft foundations into **Azure platform engineering, governance, and managed-service-style administration**.

This phase is intended to show how the environment can evolve beyond Microsoft 365 and on-premises integration into a more complete cloud platform operating model.

### Planned Release 2 focus areas

Release 2 is planned to include:

- Azure landing zone foundation
- identity-aligned Azure subscription and management-group structure
- Azure Policy and governance controls
- role-based access control (RBAC)
- Terraform-based infrastructure as code
- Azure Lighthouse for delegated administration / MSP-style operations
- Defender for Cloud
- Microsoft Sentinel onboarding
- network security expansion
- private access / secure access patterns
- stronger operational monitoring and alerting
- Azure-native compliance and governance extension

### Why Release 2 comes after Release 1

Release 2 depends on the credibility established by Release 1.

The project first proves:

- hybrid identity
- Microsoft 365
- endpoint and Zero Trust direction
- operational control thinking

Only after that does it expand into:

- Azure governance
- delegated administration
- multi-layer operational visibility
- cloud platform security posture

This sequencing is intentional and mirrors how many real environments mature over time.

### Release 2 desired outcome

By the end of Release 2, the project should be able to demonstrate that the platform is not only a Microsoft 365 / endpoint environment, but also an **Azure-governed operational platform** with stronger cloud security and MSP-ready administration patterns.

---

## Release 3 - Secure Workload Modernization and Resilience

### Purpose

Release 3 moves the project into **application and workload modernization**.

This phase is where the platform evolves from infrastructure, identity, and control layers into secure delivery of workloads and services.

### Planned Release 3 focus areas

Release 3 is planned to include:

- containerized workload deployment
- Docker-first application packaging
- secure ingress and connectivity
- observability and workload monitoring
- workload security controls
- resilience and recovery design patterns
- secure operational management of workloads
- possible future extension into Kubernetes / AKS if justified

### Why Release 3 comes last

Workload modernization is intentionally placed after:

- identity and Microsoft 365 foundation
- endpoint and access control baseline
- Azure governance and operational maturity

That ordering is important because secure workload delivery is stronger when it sits on top of:

- stable identity
- stable endpoint trust
- stable cloud governance
- stable monitoring and compliance thinking

### Release 3 desired outcome

By the end of Release 3, the platform should demonstrate not only Microsoft administration and governance, but also secure, observable, and resilient workload operations.

---

## Roadmap Logic

The release order is deliberate.

### Release 1 answers:
- Can the platform establish hybrid Microsoft identity, messaging, endpoint, and protection foundations?

### Release 2 answers:
- Can the platform extend those foundations into Azure governance and operational cloud administration?

### Release 3 answers:
- Can the platform support secure workload modernization on top of those foundations?

This is the core maturity story of the project.

---

## What the Roadmap Is Not

To keep the roadmap credible, it should be clear that this document is **not**:

- a promise that every planned item is already underway
- a guarantee of final implementation dates
- a claim that all future architecture choices are frozen
- a substitute for evidence-backed implementation docs

Instead, it is:

- a direction-of-travel document
- a phased maturity plan
- a way to help readers understand how the project scales

---

## Relationship Between Roadmap and Current State

The roadmap should be read together with:

- `03-current-state-architecture.md` for what the environment looks like now
- `04-target-state-architecture.md` for the broader target-state direction
- `../release1/11-build-checklist.md` for the authoritative Release 1 implementation status
- `../release1/00-summary.md` for the Release 1 executive proof summary

This helps readers distinguish between:

- implemented state
- next-phase priorities
- longer-term direction

---

## Why This Matters Professionally

A strong roadmap helps the project feel intentional and serious.

It shows that the work is not just:

- a list of technologies tried in isolation
- a set of disconnected admin tasks
- a collection of screenshots without direction

Instead, it presents a clear progression from:

- hybrid platform foundation
- to Azure governance
- to secure workload modernization

That is exactly the kind of maturity story that helps recruiters, engineers, and hiring managers understand the value of the project quickly.

---

## Summary

The roadmap for the `azawslab Enterprise Hybrid Security Platform` is built around three phases:

- Release 1 establishes the hybrid Microsoft, endpoint, and protection foundation
- Release 2 expands into Azure secure platform engineering and MSP-style operations
- Release 3 extends into secure workload modernization and resilience

This phased approach is one of the strongest parts of the project because it shows a practical, evidence-backed growth path rather than a disconnected collection of labs.



