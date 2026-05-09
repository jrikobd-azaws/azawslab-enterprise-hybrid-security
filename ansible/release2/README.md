# Release 2 Ansible Automation

This folder contains the Release 2 Ansible automation path.

## Source

The initial scaffold was recovered from the Azure-connected management host:

```text
vm-dev-mgmt-01
```

This matches the P2b design where Ansible runs from an Azure-connected Linux management host over private network paths to private workloads.

## Scope

Current scope:
- common Windows workload baseline
- deferred AD join role
- deferred webserver role
- future FortiGate service-chain role

## Management Path

Preferred execution path:

```text
Operator
  -> Azure control plane / approved management path
  -> vm-dev-mgmt-01
  -> private workload or network target
```

Do not use broad public SSH, RDP, WinRM, or FortiGate management exposure as the default management model.

## Secret Handling

Do not commit:
- passwords
- Ansible Vault password files
- private keys
- API tokens
- FortiGate admin secrets
- real production inventories

Use example inventories and runtime secret injection instead.

## FortiGate Service Chaining

FortiGate service-chain work must include route, policy, logging, and counter validation.

Do not claim inspection until FortiGate policy counters or logs prove traffic traversal.

## O1 FortiGate Service-Chain Codification

The FortiGate service-chain role codifies the validated O1 manual configuration.

```text
Terraform:
  Azure route table and UDR

Ansible:
  FortiGate address objects
  FortiGate static routes
  FortiGate policy
  SNAT lab-delta setting
```

Runbook playbook:

```text
ansible/release2/playbooks/fortigate-service-chain.yml
```

Do not commit FortiGate credentials, API tokens, private keys, or vault password files.

