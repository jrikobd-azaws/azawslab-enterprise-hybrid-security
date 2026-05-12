# A1 - Ansible Network/Security Automation Baseline

## Purpose

This folder is the Release 2 source-of-truth baseline for network and security-device automation.

It covers:

- FortiGate Azure inspection/service-chain firewall
- VyOS HQ edge router
- Cisco 8000V AWS branch router

## Design

```text
GitHub repo
  ansible/release2/network
        |
        v
vm-dev-mgmt-01
        |
        +--> Azure Key Vault
        |      p5-fortigate-api-token
        |      o3b-vyos-ansible-password
        |
        +--> AWS SSM
        |      /azawslab/release2/o3b/cisco-restconf-password
        |
        +--> FortiGate 10.0.3.4:443
        +--> VyOS 192.168.1.254:22
        +--> Cisco 54.229.23.76:443 and 22
```

## Transports

FortiGate:

- REST API over HTTPS 443
- API user: ansible-o1-svc
- Token loaded from Azure Key Vault

VyOS:

- Ansible network_cli over SSH 22
- Password loaded from Azure Key Vault

Cisco 8000V:

- RESTCONF over HTTPS 443 for API validation
- OpenSSH fallback over SSH 22 for CLI-only routing and running-config evidence
- RESTCONF password loaded from AWS SSM

## Secret policy

Do not commit:

- FortiGate token
- VyOS password
- Cisco password
- PSKs
- private keys
- raw running-config backups
- raw FortiGate config backups
- `.tfstate`
- `.tfplan`

Commit only:

- playbooks
- roles
- sanitized evidence
- sanitized backups after review

## Standard commands on vm-dev-mgmt-01

```bash
cd ~/azawslab-o3b-ansible/network
./scripts/run-readonly-validation.sh
./scripts/run-sanitized-backup.sh
./scripts/run-idempotency-check.sh
```

## Evidence output

Runtime evidence is written to:

```text
~/azawslab-o3b-ansible/evidence/a1-ansible-network-baseline/
```

Sanitized backups are written to:

```text
~/azawslab-o3b-ansible/backups/sanitized/
```