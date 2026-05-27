# O6 AWX Job Template Proposal - Terraform Review

Status: proposal only.

Purpose:

Provide a human-reviewed AWX job-template pattern for Terraform review in the O6 AI Operations Enclave model.

Allowed actions:

- `terraform fmt -check -recursive`
- `terraform init -backend=false`
- `terraform validate`
- Terraform plan summary collection only when explicitly approved.

Denied actions:

- `terraform apply`
- `terraform destroy`
- `terraform apply -auto-approve`
- `terraform destroy -auto-approve`
- state mutation
- production resource mutation

Human approval boundary:

AI agents may generate review notes or proposal text. AWX execution remains human-approved and RBAC-governed.
