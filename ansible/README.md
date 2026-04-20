# Ansible

**Related navigation:** [README](../README.md) | [Release 1 Summary](../docs/release1/00-summary.md) | [Release 1 Build Checklist](../docs/release1/11-build-checklist.md)

This folder contains the targeted automation used to support Linux baseline administration in Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

## What this folder proves

- Release 1 Linux management was supported by real automation, not only visibility in Microsoft tooling
- baseline package, configuration, and system-preparation tasks were applied through Ansible
- Ubuntu participation in the environment was documented as an operationally managed platform, not just a passive asset

## Current Release 1 scope

- inventory targeting through `hosts.ini`
- Linux baseline role content under `roles/linux_baseline/`
- baseline configuration tasks in `main.yml`

## Boundaries

This folder should be read as a focused Release 1 Linux baseline automation workstream. It does not claim full enterprise configuration-management maturity across all platform types.

## Related docs

- [Endpoint Enrollment and Platform Coverage](../docs/release1/04-endpoint-enrollment.md)
- [Endpoint Overview](../docs/release1/03-endpoint-overview.md)
- [Release 1 Build Checklist](../docs/release1/11-build-checklist.md)
- [Intune Evidence](../screenshots/release1/intune/README.md)


