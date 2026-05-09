# FortiGate API Token Runbook

## Purpose

This runbook defines the enterprise-aligned authentication model for Release 2 FortiGate Ansible automation.

The preferred model is a dedicated FortiGate REST API administrator with an API token, not reusable human admin credentials.

## Why API Token

API token authentication is preferred because it supports:

- separation between human admin and automation identity
- no reusable admin password in Ansible inventory
- easier rotation and revocation
- trusted-host restriction
- narrower operational blast radius
- clearer audit narrative for portfolio/interview discussion

## Target Identity

Recommended FortiGate automation identity:

```text
ansible-o1-svc
```

Purpose:

```text
Release 2 O1 FortiGate service-chain automation
```

## Trusted Host Requirement

Restrict the API administrator to the approved management source.

Preferred source:

```text
vm-dev-mgmt-01 approved egress/source address or approved management CIDR
```

Lab fallback:

```text
current approved admin source IP only
```

Do not leave the API administrator open to all sources.

## Privilege Model

Preferred:

```text
custom admin profile with only firewall address, router static, and firewall policy permissions required for O1
```

Lab fallback:

```text
temporary super_admin profile for validation only
```

If the lab fallback is used, document it as a lab delta and replace it with a narrower profile later.

## Token Storage

Do not commit the token.

Acceptable storage options:

```text
1. Ansible Vault on vm-dev-mgmt-01
2. Azure Key Vault retrieved at runtime by vm-dev-mgmt-01
3. temporary runtime environment variable for short validation windows
```

Do not store the token in:

```text
- Git
- hosts.ini
- group_vars committed to repo
- Terraform variables
- Terraform state
- GitHub Actions logs
```

## Runtime Environment Variable Pattern

Example:

```bash
export FORTIOS_ACCESS_TOKEN='<token value>'
```

Inventory should reference the variable, not the literal token.

Example inventory variable:

```ini
ansible_httpapi_token={{ lookup('env', 'FORTIOS_ACCESS_TOKEN') }}
```

## Example Inventory Pattern

```ini
[fortigate]
fortigate-azure ansible_host=20.100.195.166

[fortigate:vars]
ansible_connection=httpapi
ansible_network_os=fortinet.fortios.fortios
ansible_httpapi_use_ssl=true
ansible_httpapi_validate_certs=false
ansible_httpapi_port=443
ansible_httpapi_token={{ lookup('env', 'FORTIOS_ACCESS_TOKEN') }}
```

## Management Path

Preferred execution path:

```text
Operator
  -> approved management access
  -> vm-dev-mgmt-01
  -> FortiGate HTTPS API
```

Do not broaden public SSH/HTTPS exposure to make automation easier.

## API Token Creation Checklist

Before creating the token:

- [ ] Confirm FortiGate management access is source-restricted.
- [ ] Confirm `vm-dev-mgmt-01` or approved admin source can reach FortiGate HTTPS.
- [ ] Create dedicated REST API admin `ansible-o1-svc`.
- [ ] Restrict trusted hosts.
- [ ] Assign least-privilege profile where practical.
- [ ] Generate token.
- [ ] Store token outside Git.
- [ ] Test Ansible syntax before applying.
- [ ] Run Ansible against FortiGate only after review.

## Validation

Before running the service-chain role:

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbooks/fortigate-service-chain.yml --syntax-check
```

Then perform a read-only connectivity test before any write operation where possible.

## Rotation

Token rotation process:

1. Create a replacement token for `ansible-o1-svc`.
2. Update the runtime secret store.
3. Validate Ansible connectivity.
4. Revoke the old token.
5. Record rotation in the project evidence or operations notes if relevant.

## Revocation

Revoke the token immediately if:

- token exposure is suspected
- trusted-host source changes unexpectedly
- automation host is compromised
- the role is no longer required
- the lab is being torn down

## Lab Delta

If a broad admin profile is temporarily used for speed, document it as a lab delta. The target enterprise pattern remains a dedicated API admin with trusted-host restriction and least privilege.
