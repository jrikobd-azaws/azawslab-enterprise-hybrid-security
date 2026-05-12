# A2 Platform Linux VM AWX Terraform Design

## Purpose

Create a reusable Linux platform VM module and use it for the new A2 AWX automation control plane VM.

## Decision

This patch creates:

```text
terraform/modules/platform-linux-vm
```

and uses it for:

```text
vm-dev-awx-01
```

This patch does not refactor `vm-dev-mgmt-01`.

## Why vm-dev-mgmt-01 is not refactored in this patch

`vm-dev-mgmt-01` is the active Ansible and operations control node.

Refactoring it into a module requires Terraform moved blocks and a strict no-replacement plan. That will be done later in a separate branch.

## Terraform Wiring

```text
terraform/platform-management/dev
  |
  +-- existing inline:
  |     vm-dev-mgmt-01
  |     unchanged
  |
  +-- new:
        module.a2_awx_vm
          source = ../../modules/platform-linux-vm
          vm_name = vm-dev-awx-01
          subnet = snet-mgmt
          public_ip = false
          identity = SystemAssigned
          tags = local.common_tags + A2 tags

        Key Vault access:
          kvdevazawsne01
          AWX managed identity
          Get/List only
```

## Expected Plan

```text
Plan: 3 to add, 0 to change, 0 to destroy.
```

Expected resources:

```text
module.a2_awx_vm[0].azurerm_network_interface.this
module.a2_awx_vm[0].azurerm_linux_virtual_machine.this
azurerm_key_vault_access_policy.a2_awx_vm_secrets[0]
```

If Key Vault is switched to RBAC mode, the access policy is replaced by:

```text
azurerm_role_assignment.a2_awx_vm_key_vault_secrets_user[0]
```

## Stop Conditions

Stop immediately if a plan shows:

- destroy
- replacement
- change to `vm-dev-mgmt-01`
- change to `nic-vm-dev-mgmt-01-01`
- change to `pip-vm-dev-mgmt-01-norwayeast-01`
- route table changes
- public IP for `vm-dev-awx-01`
- unsupported VM SKU
- missing mandatory tags
- change to `terraform/modules/compute`
- change to `vm-dev-client-01`

## Apply Rule

Local Terraform is allowed only for:

```text
init
validate
plan/preflight
```

Apply remains GitHub Actions controlled unless explicitly approved.
