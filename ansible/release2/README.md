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


## FortiGate API Token Model

Release 2 FortiGate automation should use a dedicated REST API token rather than reusable human admin credentials.

Runbook:

```text
ansible/release2/docs/fortigate-api-token-runbook.md
```

Do not commit API tokens, passwords, private keys, or vault password files.

## FortiGate Legacy IPSec Cleanup

The old direct FortiGate-to-VyOS IPSec configuration should be cleaned only after a pre-cleanup snapshot and reference review.

Runbook:

```text
ansible/release2/docs/fortigate-legacy-ipsec-cleanup-runbook.md
```

Do not delete `ipsec-vyos` until references are reviewed and O1 service-chain validation can be preserved.

## FortiGate API Readiness Validation

Read-only validation playbook:

```text
ansible/release2/playbooks/fortigate-readonly-api-check.yml
```

Service-chain codification playbook:

```text
ansible/release2/playbooks/fortigate-service-chain.yml
```

Both playbooks expect the FortiGate token to be loaded from the runtime environment as `FORTIOS_ACCESS_TOKEN`.

## P2b Windows Common Baseline Validation

The Release 2 Windows common baseline has been validated from the Azure-connected management host.

```text
vm-dev-mgmt-01 / 10.10.1.4
  -> private WinRM TCP/5985
  -> vm-dev-client-01 / 10.10.0.4
```

Validated result:

```text
First run:  ok=6 changed=1 unreachable=0 failed=0
Second run: ok=6 changed=0 unreachable=0 failed=0
```

The common role currently validates WinRM connectivity, ensures `C:\Temp` exists, creates the baseline marker file, and ensures the `RemoteRegistry` service is running with manual startup.

Evidence:

```text
docs/release2/evidence/P2b/p2b-ansible-common-role-idempotency-validation.txt
docs/release2/evidence/P2b/p2b-ansible-windows-common-execution-log.md
```

Deferred roles:

```text
ad-join   - deferred until DC/DNS/domain readiness is confirmed
webserver - deferred until IIS/application scope is confirmed
```

Do not commit runtime inventory files containing real Windows credentials.

## P2b Linux AD join pattern

The HQ Linux host is joined to Active Directory from `vm-dev-mgmt-01`, using the management VM as the Ansible control node.

Final design:
- Linux host: `hq-linux-vm01`
- Linux IP: `192.168.1.30`
- Linux SSH/sudo user: `hq-admin`
- Linux SSH/sudo secret: `hq-linux-admin-password`
- AD join service account: `svc.ansible`
- AD join secret: `hq-svc-ansible-password`
- Target OU: `OU=Linux,OU=AzawsLab,DC=hq,DC=azawslab,DC=co,DC=uk`
- Service-account group: `azw-hq-ansible-operators`
- Delegation scope: Linux OU computer join rights only

Security notes:
- Secrets are retrieved at runtime from Key Vault using the `vm-dev-mgmt-01` managed identity.
- Secrets are not stored in inventory or committed files.
- The Linux join path does not use root login.
- The Linux join path does not use passwordless sudo.
- Native Ansible `become` was not used for the join because sudo prompt handling was unreliable for this Ubuntu host. The final playbook uses an explicit passworded `sudo -S` / `expect` pattern with Key Vault runtime secrets.
- The Linux AD join automation must not modify the host static IP configuration. Static IP, gateway, and DNS are prerequisites and should only be validated by the join workflow.

Validation:
- `realm list` shows `hq.azawslab.co.uk`.
- `sssd` is active.
- `apache2` is active.
- Local Apache test returns `HTTP/1.1 200 OK`.
- DC1 confirms `HQ-LINUX-VM01` under the Linux OU.

## P5 FortiGate two-policy reconciliation

The current O1/P2b FortiGate baseline is intentionally limited to two active firewall policies because the lab FortiGate license has a policy-entry limit.

Final managed policy model:
- Policy 1: `O1-AzureWorkload-to-HQ-Required-SNAT`
  - Direction: `port2 -> port1`
  - Services: `Windows AD`, `PING`, `NTP`
  - NAT: enabled
- Policy 11: `O1-HQ-to-AzureWorkload-Web-ICMP`
  - Direction: `port1 -> port2`
  - Services: `HTTP`, `HTTPS`, `PING`
  - NAT: disabled

Operational playbooks:
- `playbooks/fortigate-readonly-api-check.yml`
- `playbooks/fortigate-retired-policy-cleanup.yml`
- `playbooks/fortigate-service-chain.yml`
- `playbooks/fortigate-two-policy-refresh.yml`

Design guardrails:
- The service-chain role manages only policy 1 and policy 11.
- Retired policy IDs 10, 12, 20, and 21 are removed only by the guarded cleanup playbook.
- AWS/O3b FortiGate policies are not created until the AWS-Cisco/FortiGate route path is active and validated.
- FortiGate API tokens are loaded at runtime and are not committed.
