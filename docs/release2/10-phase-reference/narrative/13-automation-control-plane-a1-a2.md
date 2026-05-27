# A1/A2 Automation Control Plane Narrative

## Objective

A1 and A2 define the Release 2 automation operations layer.

A1 is complete. It established a validated Ansible network/security automation baseline for FortiGate, VyOS, and Cisco 8000V.

A2 is the next recommended planning and implementation step. It will centralize the validated A1 model into AWX with enterprise-style login, RBAC, GitHub project sync, and runtime secret retrieval.

## A1 Completed State

```text
ansible/release2/network/
  inventories/
  group_vars/
  playbooks/
  roles/
  scripts/
```

A1 validated:

- FortiGate read-only API access through a least-privilege token.
- FortiGate sanitized API snapshot.
- VyOS read-only validation and sanitized backup.
- Cisco RESTCONF validation.
- Cisco controlled OpenSSH fallback for CLI-only evidence.
- Runtime secrets from Azure Key Vault and AWS SSM.
- Idempotency/no-device-change proof.

Evidence:

```text
docs/release2/evidence/A1-ansible-network-baseline/
```

## A2 Target State

```text
[Operator]
    |
    v
[AWX on Azure-managed host]
    |
    +-- Entra/Azure AD login
    +-- AWX RBAC
    +-- GitHub project sync
    +-- Azure Key Vault runtime secrets
    +-- AWS SSM runtime secrets
    |
    +-- A1 validation jobs
    +-- O4 private AKS support jobs
    +-- O5 secure admin/dev workspace support jobs
```

## Why A2 Before O4

O4 private AKS will need controlled operational execution for:

- `az`
- `kubectl`
- Helm
- Docker/container tooling
- namespace/bootstrap tasks
- sample app deployment
- evidence capture

A2 gives those operations a controlled enterprise-style front end instead of relying only on unmanaged shell sessions from the management host.

## Non-Claims

A2 does not replace O4.

A2 does not create the private AKS platform.

A2 is the automation control plane that prepares the environment for O4 and O5.
