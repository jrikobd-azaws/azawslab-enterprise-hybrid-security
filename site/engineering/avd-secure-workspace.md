# AVD Secure Workspace and FSLogix

## What this proves

This page separates the Azure Virtual Desktop secure workspace story from the AKS platform story. It focuses on workspace access, session host patterns, FSLogix, private endpoint orientation and administrative access design.

## Why it matters

AVD is a strong enterprise signal for secure operations workspaces, remote administration and controlled access to private platforms.

## Source implementation

| Area | Source |
|---|---|
| AVD Terraform root | [terraform/platform-avd/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) |
| AVD secure workspace module | [terraform/modules/avd-secure-workspace](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/modules/avd-secure-workspace) |
| Private platform narrative | [docs/release2/04-private-platform-secure-workspace.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/04-private-platform-secure-workspace.md) |

## Evidence and validation

| Evidence | Purpose |
|---|---|
| [O5 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | AVD secure workspace validation |
| [Release 2 evidence index](../evidence/release2-evidence-index.md) | Capability-mapped evidence entry point |

## Reviewer signal

This page should be used by reviewers looking for AVD, FSLogix, private workspace access, secure operations workstations and enterprise workspace engineering.