# O6 AWX Job Template Proposal - Runbook Draft

Status: proposal only.

Purpose:

Define how O6 can generate human-reviewable runbook drafts without autonomous remediation.

Allowed outputs:

- incident summary
- topology summary
- route-risk summary
- Terraform review note
- Ansible runbook draft
- AWX job-template proposal
- GitOps pull request text

Denied actions:

- direct remediation
- `terraform apply`
- `kubectl apply`
- live `ansible-playbook` execution
- AWX job launch
- firewall mutation
- BGP mutation
- broad shell execution
- secret reads

Approval model:

Agent finding -> runbook draft -> human review -> approved GitHub Actions / AWX / service-management path.
