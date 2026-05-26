# Evidence Verification Guide — Azawslab Enterprise Hybrid Security Platform

## 1. Purpose

This guide serves as the technical reviewer's proof-navigation and redaction standard. The Azawslab Enterprise Hybrid Security Platform is anchored in verifiable artifacts: screenshots, CLI outputs, Terraform records, AWX job logs, policy evidence, validation files, and implementation notes. This document explains how evidence is structured, what specific evidence types prove, how claims are mapped by release, and the strict redaction standards applied to protect sensitive tenant information while preserving engineering integrity.

---

## 2. Evidence Model by Release

The portfolio spans different operational domains, requiring distinct types of evidence to prove capability.

*   **Release 1: Hybrid Modern Workplace, Identity & Endpoint Security**
    Release 1 is heavily UI- and screenshot-backed. Evidence focuses on user-facing outcomes, compliance states, and portal configurations. All Release 1 evidence is located in `screenshots/release1/` and supported by documentation in `docs/release1/`.

*   **Release 2: Azure Platform Engineering, Security, Automation, Private Platform & AI Operations**
    Release 2 is CLI-heavy, IaC-heavy, and automation-heavy. Evidence focuses on infrastructure state, remote execution, and programmatic validation. Evidence is located in `docs/release2/evidence/`, using specific tracking directories such as `A1-ansible-network-baseline/`, `A2-awx-control-plane/`, `O1/`, `O2/`, `O3b/`, `O3c/`, `O4/`, `O5/`, `O6/`, and the relevant `P*` phase evidence folders covering governance, Terraform, networking, firewall, monitoring, and platform validation.

*   **Release 3: Multi-Cloud Kubernetes, GitOps & DevSecOps**
    Release 3 is roadmap and platform evolution. Evidence positions focus on target architectures and planned control models. Proof placeholders are utilized and will be replaced as implementation evidence is actively produced.

---

## 3. Screenshot Evidence

Screenshot evidence is primarily used to prove portal configuration state, identity policy existence, endpoint compliance posture, application deployment status, and operational recovery validation.

*What it proves:* Screenshots validate the final outcome of an engineering decision (e.g., an Intune endpoint successfully reporting a compliant state, a DLP policy tip triggering in Word, or a BitLocker recovery key being retrieved from Entra ID).

*What it does not prove:* Screenshots do not replace CLI or configuration logs where deep infrastructure state, routing logic, or deployment pipelines must be proven.

---

## 4. CLI and Terraform Evidence

CLI and Terraform outputs are the definitive proof for cloud infrastructure and network routing.

*What it proves:* CLI outputs (`.txt` and `.json`) validate runtime state, BGP route propagation, private endpoint integration, Kubernetes cluster state, firewall egress behaviors, and Azure Policy evaluations.

*Terraform execution:* Terraform evidence includes `plan` and `apply` outputs, backend state boundary validations, and module behavior logs.

*Apply Model:* **GitHub Actions controlled apply is the default execution model** for this portfolio. Evidence of CI/CD pipeline execution is prioritized. Local Terraform applies are strictly exceptional and documented as such when utilized.

---

## 5. AWX / Ansible Evidence

The automation control plane relies on AWX and Ansible to enforce configuration management and operational runbooks.

*What it proves:* Phase A2 evidence proves the successful deployment of the AWX automation control plane, Kubernetes-hosted job execution, dynamic runtime secret retrieval from Azure Key Vault and AWS SSM, controlled playbook execution, network state validation, infrastructure backups, and the enforcement of a tiered automation model.

---

## 6. AKS / AVD / O6 Evidence

The private platform and AI operations components are treated as first-class evidence categories, requiring specialized validation artifacts.

*   **O4 Private AKS Evidence:** Validates the private cluster state, private API server posture, Azure Firewall egress paths, pod-level egress validation, internal application accessibility, managed Prometheus/Grafana deployments, and AWX readiness.

*   **O5 AVD + FSLogix Evidence:** Validates the secure workspace architecture. Proof includes governance paired-region validation (Norway East primary / Norway West paired), required provider registrations, SKU/quota readiness checks, network overlap verification, AVD endpoint dependencies, and FSLogix private endpoint prerequisites.

*   **O6 AI Operations Enclave Evidence:** Validates the human-approved AI operations model. Proof artifacts include MCP gateway configurations, policy decision logs, agent-specific enforcement records, network policy verification, namespace lifecycle management, and post-cleanup validation checks. This is supported by context from the `local-ai-lab-infra` companion execution environment.

---

## 7. Redaction Standard

To maintain security while proving engineering capability, raw logs and screenshots are strictly sanitized before commit. The following redaction rules are universally enforced:

*   **Redacted:** Tenant IDs, Subscription IDs (where sensitive), sensitive public/private IP addresses, and specific Object IDs.
*   **Redacted:** Usernames, email addresses, and internal hostnames (if sensitive).
*   **Redacted:** All secrets, access keys, tokens, connection strings, SAS URLs, certificates, `.tfvars`, raw `.tfstate` contents, `kubeconfig` files, SSH keys, and passwords.
*   **Never Committed:** Raw secrets or unencrypted state files are never committed to version control.
*   **Preserved:** Enough non-sensitive metadata, log structure, and deployment output remains visible to definitively prove the engineering claim without compromising the environment.

---

## 8. Proof Link Wording

The documentation adheres to a strict placeholder standard to ensure complete transparency during portfolio migration and future roadmap expansion:

*   `proof link to be inserted` — Used explicitly for evidence that exists but whose final public path in the repository is not yet confirmed.
*   `diagram placeholder` — Used explicitly for architectural or flow diagrams that are planned but not yet generated.
*   No file paths or evidence names are invented or hallucinated. If proof is pending, the placeholder is used.

---

## 9. Reviewer Navigation

To efficiently audit the repository, reviewers are encouraged to follow the path most relevant to their domain:

*   **Recruiter / Hiring Manager:** Start with `README.md` for the executive summary, track `SKILLS_MATRIX.md` for role-alignment, and review `PORTFOLIO.md` for the overarching narrative case study.
*   **Cloud Platform Reviewer:** Focus on `ARCHITECTURE.md`, `docs/release2/evidence/P0/` through `P6/`, and `docs/release2/evidence/O4/` to evaluate landing zone construction, IaC state management, and Private AKS configuration.
*   **Security Reviewer:** Audit `screenshots/release1/identity-and-access/` for Zero Trust access controls, `docs/release2/evidence/P6/` for Azure Firewall egress rules, and `docs/release2/evidence/P3/` for Azure Policy deny-enforcement.
*   **Modern Workplace Reviewer:** Navigate directly to `screenshots/release1/` to review Intune compliance, Autopilot workflows, Purview information protection, and operational recovery scenarios.
*   **DevOps / SRE Reviewer:** Evaluate `.github/workflows/` for pipeline design, `docs/release2/evidence/A2-awx-control-plane/` for the automation control plane, and `docs/release2/evidence/P9a/` for Azure Monitor alerting configurations.
*   **AI Operations Reviewer:** Review `docs/release2/evidence/O6/` to audit the MCP boundary logs, policy decision constraints, and human-in-the-loop AI CloudOps execution.