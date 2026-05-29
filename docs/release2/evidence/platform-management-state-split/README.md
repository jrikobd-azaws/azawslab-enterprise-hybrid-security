# Platform Management State Split Evidence

This folder captures the separation of platform-management infrastructure into its own Terraform state boundary — a strategic decision that reduces blast radius and clarifies ownership.

## Why This Matters

When management-plane resources (like AWX controllers, monitoring VMs, or automation runners) share state with workload or networking resources, a single mistake can take down both the platform and the tools used to recover it. By splitting the management state, this project demonstrates an enterprise-grade pattern: protect the control plane by isolating its state and its lifecycle.

## What It Demonstrates

- A clean separation of Terraform roots: `platform-management` vs. `platform-shared` and `platform-networking`.
- Evidence that AWX and other management components have their own state, lifecycle, and access controls.
- A design that prevents accidental destruction of the automation layer during unrelated changes.
- Alignment with the principle of least privilege and operational safety.

## How to Use This Evidence

- **Security architects:** This shows that even the lab’s control plane is protected from casual mutation — a hallmark of a security-conscious platform design.
- **Platform engineers & technical reviewers:** Read this folder alongside `docs/release2/11-terraform-state-and-pipeline-map.md`, `terraform/platform-management/dev/`, `docs/release2/evidence/A2-awx-control-plane/`, and the GitHub Actions workflows. It completes the story of secure, governed infrastructure delivery.
- This is a core part of the Release 2 platform-engineering narrative, not a side note.

## Public-Safe Redaction

No Terraform state files, plans, credentials, or private IP addresses are included. Only the sanitised evidence of the state split and its validation are publicly visible.

**[← Back to Release 2 evidence index](../README.md)**