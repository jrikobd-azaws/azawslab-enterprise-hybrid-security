# Scripts

This folder contains support scripts used for documentation migration, Release 1 validation, and Release 2 platform operations.

Scripts in this repository are not a general-purpose one-click deployment interface. Review each script before running it and use the linked release documentation to understand its context.

## Folder Map

| Path | Purpose |
|---|---|
| `portfolio/` | Documentation migration, source-truth normalization, and portfolio maintenance helpers |
| `release1/` | Release 1 operational validation and support scripts |
| `release2/` | Release 2 preflight, validation, wrapper, and implementation support scripts |
| `release2/p2b/` | Historical Release 2 P2b WinRM helper scripts relocated from the repository root |

## Root Configuration

The root-level `ansible.cfg` is intentional. It supports Ansible/AWX execution behaviour, including dynamic inventory and plugin configuration. It is configuration, not a loose deployment script.

## Safety Rules

- Inspect a script before running it.
- Do not commit secrets, generated credentials, tokens, kubeconfigs, `.tfstate`, or `.tfplan` files.
- Do not run local `terraform apply` as a routine path. GitHub Actions controlled apply remains the default for Terraform-managed infrastructure.
- Treat scripts as operational helpers tied to release documentation and evidence, not as standalone automation products.
