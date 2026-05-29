# Ansible Collections

This folder contains Ansible collection dependency declarations used by the platform automation work.

The collection requirements support Ansible and AWX execution, especially Release 2 network automation and operational validation. This folder is not standalone application code.

## Contents

| File | Purpose |
|---|---|
| `requirements.yml` | Declares Ansible collection dependencies required by automation roles and playbooks |

## Related Areas

- `ansible/`
- `ansible/release2/`
- `docs/release2/03-automation-secops-resilience.md`
- `docs/release2/evidence/A2-awx-control-plane/`

## Safety Notes

- Do not vendor third-party collections directly into this repository unless intentionally required.
- Keep dependency declarations explicit and reviewable.
- Use AWX/Ansible execution logs as evidence rather than committing generated runtime artifacts.
