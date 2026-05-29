# GitHub Actions OIDC Delivery

GitHub Actions OIDC is used to avoid long-lived cloud deployment credentials in repository secrets.

## Why it matters

OIDC-based delivery aligns with modern platform security patterns by reducing static credential exposure and supporting controlled workflow-driven deployment.

## Reviewer focus

- Workflow separation by platform root.
- Plan/review/apply discipline.
- Evidence folders for validation.
- No routine local Terraform apply as the normal delivery path.

## Source links

- [GitHub workflows](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows)
- [Release 2 Terraform CI workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-ci.yml)
- [Release 2 Terraform apply workflow](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/.github/workflows/release2-terraform-apply.yml)
- [P0 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P0)