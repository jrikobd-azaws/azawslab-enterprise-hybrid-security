# Proof Gallery - Flagship Evidence in One View

This gallery highlights the strongest operational proof from each release. It is designed for a reviewer who wants a rapid confidence check before diving into detailed capability stories or evidence folders.

## Release 1 - Hybrid Modern Workplace, Identity & Endpoint Security

- **Exchange hybrid migration** - mailbox pilot and mail-flow validation  
  -> `screenshots/release1/modern-workplace/exchange-hybrid/`
- **Multi-platform Intune management** - Windows corp/BYOD, Ubuntu Linux, iPhone BYOD  
  -> `screenshots/release1/endpoint-management/intune/`
- **Purview document fingerprinting** - advanced DLP beyond basic sensitivity labels  
  -> `screenshots/release1/information-protection/purview/purview-fingerprint/`
- **Identity lifecycle automation with Microsoft Graph** - disable/revoke/enable, mover scenario, device rename  
  -> `screenshots/release1/identity-and-access/identity-operations/`

## Release 2 - Azure Platform Engineering, Security, Automation, Private Platform & AI Operations

- **Secretless Terraform delivery with OIDC** - no static credentials in CI/CD  
  -> `docs/release2/evidence/P0/`
- **Azure Policy deny enforcement** - `pa-loc-prod-norwayeast`, `pa-vmsku-prod-b2alsv2`  
  -> `docs/release2/evidence/P3/`
- **Transitive multi-cloud routing validation** - on-premises -> Azure -> AWS -> return path  
  -> `docs/release2/evidence/O3c/`
- **AWX automation control plane** - Entra SSO, RBAC, dynamic secrets from Key Vault/SSM  
  -> `docs/release2/evidence/A2-awx-control-plane/`
- **Synthetic alert firing with CPU stress test** - real alert and notification path validated  
  -> `docs/release2/evidence/P9a/`
- **Immutable backup with Multi-User Authorization** - staged redesign across three phases  
  -> `docs/release2/evidence/P9b-redesign/`
- **Private AKS cluster with firewall-enforced pod egress** - pod-level validation included  
  -> `docs/release2/evidence/O4/`
- **AVD + FSLogix secure admin workspace** - governance paired-region validation and private endpoint readiness  
  -> `docs/release2/evidence/O5/`
- **O6 AI Operations Enclave** - MCP gateway policy logs, deny-by-default enforcement, network policy validation  
  -> `docs/release2/evidence/O6/`

## How to Use This Gallery

- Each bullet is backed by the evidence folder listed.
- Open the evidence folder to inspect the CLI outputs, screenshots, logs, or validation files.
- For full narrative context, read the capability stories in `docs/release2/01-*.md` through `docs/release2/05-*.md` and the portfolio case study in `PORTFOLIO.md`.

This is a curated highlight, not a replacement for the complete evidence index.
