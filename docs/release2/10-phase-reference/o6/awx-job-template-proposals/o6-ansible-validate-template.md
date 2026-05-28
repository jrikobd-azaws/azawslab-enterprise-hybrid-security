# O6 AWX Job Template Proposal - Ansible Validation

Status: proposal only.

Purpose:

Provide a human-reviewed AWX job-template pattern for Ansible syntax and inventory validation.

Allowed actions:

- `ansible-playbook --syntax-check`
- `ansible-inventory --list`
- optional `ansible-lint`
- optional `yamllint`

Denied actions:

- live Ansible playbook execution
- inventory mutation
- credential changes
- device configuration changes
- AWX job launch by AI without human approval

Human approval boundary:

O6 may draft runbook improvements and validation summaries. Production execution remains governed through AWX RBAC and human approval.
