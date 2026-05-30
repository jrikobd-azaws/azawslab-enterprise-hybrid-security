# Scripts

> Part of: [Azawslab Enterprise Hybrid Security Platform](../README.md)  
> Best for: technical reviewers, operations reviewers, DevOps/SRE reviewers, and maintainers  
> Purpose: support scripts for validation, operational checks, and release-specific implementation workflows

This folder contains support scripts used for Release 1 validation and Release 2 platform operations.

Scripts in this repository are not a general-purpose one-click deployment interface. Review each script before running it and use the linked release documentation to understand its context.

## Folder map

| Path | Purpose |
|---|---|
| [`release1/`](release1/) | Release 1 operational validation and support scripts |
| [`release2/`](release2/) | Release 2 preflight, validation, wrapper, and implementation support scripts |
| [`release2/p2b/`](release2/p2b/) | Historical Release 2 P2b WinRM helper scripts relocated from the repository root |

## Root configuration

The root-level [`ansible.cfg`](../ansible.cfg) is intentional. It supports Ansible/AWX execution behaviour, including dynamic inventory and plugin configuration. It is configuration, not a loose deployment script.

## Safety rules

- Inspect a script before running it.
- Do not commit secrets, generated credentials, tokens, kubeconfigs, `.tfstate`, or `.tfplan` files.
- Do not run local `terraform apply` as a routine path. GitHub Actions controlled apply remains the default for Terraform-managed infrastructure.
- Treat scripts as operational helpers tied to release documentation and evidence, not as standalone automation products.

---

## Navigation

- [Repository home](../README.md)
- [Reviewer guide](../REVIEWER_GUIDE.md)
- [Release 1 overview](../docs/release1/README.md)
- [Release 2 overview](../docs/release2/README.md)
- [Terraform overview](../terraform/README.md)
- [Release 2 evidence index](../docs/release2/evidence/README.md)