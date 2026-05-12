# A2/O4/O5 Integrated Platform Design

## Objective

This document aligns the next Release 2 implementation path across A2, O4, and O5.

The goal is to avoid rework by designing the automation control plane, private AKS platform, and secure admin/dev workspace together before Terraform or Ansible implementation starts.

## Domain Model

```text
HQ / on-prem:
  hq.azawslab.co.uk

Azure / Entra:
  entra.azawslab.co.uk

AWS branch:
  br.azawslab.co.uk
```

## Integrated Architecture

```text
[Engineer]
    |
    v
[O5 AVD single-user admin/dev workspace]
    |
    +-- PowerShell 7
    +-- Azure CLI
    +-- AWS CLI
    +-- Terraform
    +-- Git
    +-- VS Code
    +-- kubectl
    +-- Helm
    +-- Docker CLI or approved container tooling
    |
    v
[A2 AWX vm-dev-awx-01]
    |
    +-- Entra/Azure AD login
    +-- AWX RBAC
    +-- GitHub project sync
    +-- Azure Key Vault runtime secrets
    +-- AWS SSM runtime secrets
    |
    +-- Tier 1 read-only validation
    +-- Tier 2 sanitized backup
    +-- Tier 3 preflight/dry-run
    +-- Tier 4 approved write/change
    +-- Tier 5 rollback/emergency
    |
    v
[O4 Private AKS Platform]
    |
    +-- ACR
    +-- Workload Identity
    +-- Key Vault CSI Driver
    +-- internal ingress
    +-- NGINX or .NET sample app
    +-- Azure Firewall egress
    +-- FortiGate hybrid/private inspection only where proven
```

## A2 AWX Scope

A2 deploys and validates the AWX automation control plane.

A2 is not read-only. A2 must include read, backup, preflight, approved write, and rollback/emergency tiers in the same implementation package.

The first write validation should be low risk and reversible.

Recommended first write:

```text
VyOS:
  idempotent low-risk marker or description change
```

Recommended first rollback:

```text
VyOS:
  revert or remove the same marker or description change
```

FortiGate write requires a separate write-capable API token.

Cisco broad write remains guarded until RESTCONF/NETCONF or network_cli transport is proven enterprise-stable.

## O4 Private AKS Scope

O4 deploys a private AKS modern application platform.

Included:

- Private AKS cluster.
- ACR.
- Workload Identity.
- OIDC issuer.
- Key Vault CSI Driver.
- Internal ingress.
- NGINX or .NET sample container.
- Azure Firewall egress path.
- FortiGate only where private/hybrid inspection is proven.

## O5 AVD Scope

O5 deploys a single-user secure admin/dev workspace.

Included:

- Personal/single-user AVD model.
- FSLogix profile container.
- Azure Files private endpoint.
- Admin/dev platform tooling.
- AWX access validation.
- AKS tooling validation.

## Implementation Rule

A2/O4/O5 implementation should start only after this integrated design is merged.

Terraform changes must explain root/module/variable/wiring with a text diagram before code.

Ansible/AWX changes must explain inventory/group_vars/playbook/role/runtime-secret/job-template flow before code.
