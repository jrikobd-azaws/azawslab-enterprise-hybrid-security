# Hyper-V Lab Foundation Evidence

This folder provides supporting evidence for the local Hyper-V virtualisation platform that underpins the entire hybrid lab environment.

## Why This Matters

The lab was not a collection of isolated cloud screenshots. It ran on a repeatable, enterprise-style local infrastructure — a fully virtualised Active Directory domain, Windows Server workloads, and identity services — before any cloud integration. This proves that the platform was designed with a real, production-like foundation, not just a series of click-through demos.

## What It Demonstrates

- A complete local Active Directory forest, DNS, and domain infrastructure.
- Windows Server 2022+ domain controllers and member servers running on Hyper-V.
- A staging ground for Entra Connect, hybrid identity, and cross-platform trust before Azure integration.
- Repeatable, scripted lab deployment (not a one-off hand-built environment).

## How to Use This Evidence

- **Recruiters & hiring managers:** This folder confirms the lab’s realism and the engineer’s commitment to building a complete platform, not just isolated features.
- **Technical reviewers:** Use this as context for the on-premises side of the hybrid architecture. Start with `ARCHITECTURE.md` and the Release 1 documents, then come here for proof that the foundations were real.
- For the most recruiter-friendly visual proof, see `screenshots/release1/platform-foundation/` and `screenshots/release1/identity-and-access/`.

## Public-Safe Redaction

All evidence is curated for public portfolio review. Sensitive tenant identifiers, internal hostnames, credentials, and operational secrets are redacted. The remaining artefacts prove the technical capability without exposing the lab’s private state.

**[← Back to Release 2 evidence index](../README.md)**