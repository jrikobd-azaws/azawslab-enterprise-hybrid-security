# Ansible and AWX Automation Control Plane

## What this proves

This page highlights the Day 2 automation layer of the platform: Ansible automation, AWX control-plane evidence, operational scripts and management-plane infrastructure support.

## Why it matters

Terraform provisions infrastructure. Ansible and AWX show operational control after provisioning: configuration, validation, network automation, repeatable jobs and controlled operations workflows.

## Source implementation

| Area | Source |
|---|---|
| Ansible root | [ansible](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible) |
| Release scripts | [scripts](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/scripts) |
| Platform management Terraform root | [terraform/platform-management/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-management/dev) |
| Release 2 automation narrative | [docs/release2/03-automation-secops-resilience.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/03-automation-secops-resilience.md) |

## Evidence and validation

| Evidence | Purpose |
|---|---|
| [A2 AWX control-plane evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) | AWX control-plane validation |
| [Release 2 evidence index](../evidence/release2-evidence-index.md) | Capability-mapped evidence entry point |

## Reviewer signal

This page proves operational maturity beyond provisioning: automation dispatch, controlled operations, management-plane separation and validated Day 2 execution.