# A2 AWX Automation Control Plane Closure

## Purpose

A2 centralizes the validated A1 Ansible network/security automation model into AWX, using enterprise identity, RBAC, project sync, and runtime secret retrieval.

A2 is an automation control-plane enabler for O4 and O5. It does not replace O4 private AKS or O5 secure admin/dev workspace.

## Final Architecture

```text
[Engineer / Operator]
        |
        | Browser through SSH tunnel
        v
[A2 AWX: devawx01 / vm-dev-awx-01]
        |
        +-- Entra / Azure AD SSO
        +-- AWX RBAC teams
        +-- GitHub project sync
        +-- AWX job templates
        |
        | SSH dispatcher credential
        v
[Management Ansible Host: vm-dev-mgmt-01]
        |
        +-- Azure Key Vault secret retrieval
        +-- AWS SSM secret retrieval through Roles Anywhere
        +-- Existing A1 Ansible baseline
        |
        +------------------+-------------------+-------------------+
        |                  |                   |                   |
        v                  v                   v
[FortiGate NVA]        [VyOS Router]        [Cisco AWS Branch]
 read-only API          network_cli          RESTCONF + OpenSSH
 sanitized backup       backup/write/rollback sanitized backup
```

## Secret Flow

```text
AWX job template
  |
  | SSH dispatch
  v
vm-dev-mgmt-01
  |
  +-- Azure Key Vault:
  |     FORTIOS_ACCESS_TOKEN
  |     O3B_VYOS_ANSIBLE_PASSWORD
  |
  +-- AWS SSM:
  |     O3B_CISCO_RESTCONF_PASSWORD
  |
  v
Ansible runtime variables only

No plaintext secret is committed to Git.
No secret value is written into evidence.
```

## Tier Model

```text
Tier 1:
  Read-only validation.
  Expected result: no configuration change.

Tier 2:
  Sanitized backup.
  Expected result: no device configuration change.
  Output: sanitized files only.

Tier 3:
  Idempotency / no-change proof.
  Expected result: changed=0 where applicable.

Tier 4:
  Approved write/change.
  Implemented first as low-risk VyOS marker write.
  Requires approval flag, ticket, reason, backup, apply, post-check.

Tier 5:
  Rollback/emergency.
  Removes the same VyOS marker.
  Requires rollback approval flag, ticket, reason, post-rollback validation.
```

## Why the Dispatcher Model Was Used

AWX is the control plane, not the direct network-device execution plane.

```text
AWX owns:
  - identity
  - RBAC
  - audit trail
  - templates
  - operator control

vm-dev-mgmt-01 owns:
  - device reachability
  - Ansible collections/runtime
  - Azure Key Vault / AWS SSM retrieval
  - FortiGate, VyOS, and Cisco execution path
```

This preserves the validated A1 execution path and avoids introducing a new unproven AWX-pod-to-device network path.

## Validated Results

```text
Tier 1 AWX job:
  Job ID 35
  Successful

Tier 2 AWX job:
  Job ID 38
  Successful

Tier 3 AWX job:
  Job ID 40
  Successful

Tier 4 AWX job:
  Job ID 44
  Successful

Tier 5 AWX job:
  Job ID 46
  Successful

SSO:
  AWX social user AWXAdmin created
  Email awx-admin@entra.azawslab.co.uk
  Last login confirmed
```

## Closure Decision

A2 AWX Automation Control Plane is closed.

Remaining items move to later phases:

```text
O4:
  Private AKS modern application platform.

O5:
  AVD + FSLogix secure admin/dev workspace.

Future A2 extensions:
  - O4 support templates after O4 exists.
  - O5 support templates after O5 exists.
  - FortiGate write workflow only after separate write token validation.
  - Cisco write workflow only after transport stability is proven.
```