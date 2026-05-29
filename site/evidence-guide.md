# Evidence Guide

This site is evidence-led. Claims should point to implementation source, screenshots, CLI output, workflow evidence, manifests, or redacted validation artifacts.

## Evidence model

| Evidence type | Purpose |
|---|---|
| Screenshots | Prove portal-level configuration and operational outcomes |
| CLI output | Prove validation commands and runtime state |
| GitHub Actions runs | Prove workflow-controlled delivery |
| Terraform source | Prove infrastructure definition and root ownership |
| Kubernetes manifests | Prove platform support objects and policy boundaries |
| README files in evidence folders | Explain what each evidence set validates |
| Diagrams | Explain architecture and flow relationships |

## Redaction principle

The repository should prove capability without exposing secrets or risky private state.

Do not publish:

- Terraform state files
- Terraform binary plans
- Kubeconfigs
- Private keys or certificates
- Tokens or raw credentials
- Sensitive tenant identifiers
- Raw unredacted operational logs

## How reviewers should use the evidence

1. Start with the [Proof Gallery](proof-gallery.md).
2. Open the relevant evidence folder.
3. Read the folder README first.
4. Inspect screenshots, logs, and source files only as needed.
5. Use the repository links for raw technical evidence.

## Full source document

- [Full EVIDENCE_GUIDE.md in GitHub](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/EVIDENCE_GUIDE.md)