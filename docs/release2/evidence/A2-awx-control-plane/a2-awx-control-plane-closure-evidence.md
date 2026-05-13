# A2 AWX Automation Control Plane Closure Evidence

Captured UTC: 2026-05-13T15:13:00Z

## Closure Result

A2 AWX Automation Control Plane is functionally complete.

Validated:

- AWX management access through the approved SSH tunnel and management path.
- AWX project sync from GitHub branch `a2-awx-platform-management-design`.
- Management-host dispatcher model.
- Azure Key Vault runtime secret retrieval.
- AWS SSM runtime secret retrieval through Roles Anywhere.
- Entra / Azure AD SSO login.
- AWX social user creation for `awx-admin@entra.azawslab.co.uk`.
- AWX Tier 1 through Tier 5 templates.
- First low-risk reversible VyOS write and rollback.

## Evidence Screenshot

- `a2-awx-entra-sso-social-user-awxadmin-login.png`

The screenshot proves:

```text
AWX user: AWXAdmin
Email: awx-admin@entra.azawslab.co.uk
Type: SOCIAL
Last Login: present
```

## A2 Validated Architecture

```text
Laptop / Operator
  |
  | SSH tunnel:
  | 127.0.0.1:8080 -> 10.10.1.5:32625
  v
AWX on devawx01 / vm-dev-awx-01
  |
  +-- Entra / Azure AD SSO
  +-- AWX RBAC teams
  +-- GitHub project sync
  +-- AWX job templates
  |
  | SSH machine credential
  v
vm-dev-mgmt-01 / 10.10.1.4
  |
  +-- Azure Key Vault runtime secrets
  |     - p5-fortigate-api-token
  |     - o3b-vyos-ansible-password
  |
  +-- AWS SSM runtime secret
  |     - /azawslab/release2/o3b/cisco-restconf-password
  |
  v
Existing A1 Ansible baseline
  |
  +-- FortiGate read-only validation and sanitized backup
  +-- VyOS read-only validation, sanitized backup, marker write, marker rollback
  +-- Cisco RESTCONF read-only validation and OpenSSH fallback backup
```

## A2 Tier Validation

```text
Tier 1 - Read-only validation
  AWX job ID: 35
  Result: successful

Tier 2 - Sanitized backup
  AWX job ID: 38
  Result: successful

Tier 3 - Idempotency / no-change proof
  AWX job ID: 40
  Result: successful

Tier 4 - Approved write/change
  AWX job ID: 44
  Result: successful
  Scope: low-risk VyOS marker write

Tier 5 - Rollback/emergency
  AWX job ID: 46
  Result: successful
  Validation ticket: A2MARKER-20260513134531
  Scope: removed same VyOS marker and performed post-rollback validation
```

## Identity and RBAC

```text
Entra tenant:
  entra.azawslab.co.uk

AWX SSO app:
  app-a2-awx-sso

AWX SSO verification user:
  awx-admin@entra.azawslab.co.uk

AWX social user:
  AWXAdmin

Entra groups:
  azw-awx-admins
  azw-awx-operators
  azw-awx-change-approvers
  azw-awx-emergency-admins
```

## Entra Group Object IDs

```text
azw-awx-admins:
  cb32c451-e8fa-4e51-9102-7c028793fc01

azw-awx-operators:
  a8312e0a-3344-40af-ad96-a489affaca33

azw-awx-change-approvers:
  0c1993af-1970-4f97-b259-57c7ffb5d881

azw-awx-emergency-admins:
  36eb60c9-f642-41e8-b032-6dc38e19b5b1
```

## Guardrails

```text
Not claimed:
  - AWX direct-to-device execution.
  - Custom AWX execution environment.
  - FortiGate write workflow.
  - Cisco broad write workflow.
  - O4/O5 operational job templates.

Guardrails:
  - FortiGate write requires separate write-capable token before any FortiGate write workflow.
  - Cisco broad write remains disabled until transport is proven enterprise-stable.
  - A2 uses vm-dev-mgmt-01 as the validated execution host for device access.
```

## Closure Statement

A2 is closed as the AWX automation control plane for Release 2.

```text
A2 AWX control plane
  -> Entra / Azure AD login
  -> AWX RBAC
  -> GitHub project sync
  -> Azure Key Vault runtime secrets
  -> AWS SSM runtime secrets
  -> Tier 1 read-only validation
  -> Tier 2 sanitized backup
  -> Tier 3 idempotency/preflight proof
  -> Tier 4 approved low-risk write
  -> Tier 5 rollback/emergency
```