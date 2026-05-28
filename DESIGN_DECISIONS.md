# Design Decisions - Senior Engineering Judgement

This document captures the architectural decisions that shaped the platform. Each decision includes the context, options considered, chosen path, and evidence location.

## 1. Identity as the Security Perimeter First

**Context:** The platform needed to secure users and devices before deploying cloud infrastructure.

**Options:** Start with Azure landing zone, or start with identity and endpoint security.

**Decision:** Build the hybrid identity, endpoint management, and information protection layer first in Release 1.

**Evidence:** `screenshots/release1/` - Conditional Access, Intune compliance, Autopilot, Exchange hybrid, Purview, and operational validation evidence.

## 2. Terraform over Bicep or ARM

**Context:** The platform required infrastructure as code across Azure and AWS.

**Options:** Bicep, ARM templates, or Terraform.

**Decision:** Use Terraform for provider-agnostic infrastructure delivery and consistent workflow across Azure and AWS.

**Evidence:** `docs/release2/evidence/P0/` through `P2b/`, `O3b/`, `O3c/` - Terraform plan/apply outputs, remote-backend evidence, and state-boundary documentation.

## 3. OIDC over Static Service Principal Secrets

**Context:** CI/CD pipelines needed cloud authentication without storing long-lived credentials.

**Options:** Store service principal secrets in GitHub Secrets, or use OpenID Connect federation.

**Decision:** Use GitHub Actions OIDC federation for Azure authentication.

**Evidence:** `docs/release2/evidence/P0/` - OIDC trust configuration, bootstrap records, and pipeline/backend validation.

## 4. Split-State Terraform Model

**Context:** A single Terraform state boundary would couple unrelated lifecycles and increase blast radius.

**Options:** Monolithic state, or lifecycle-aligned state roots.

**Decision:** Use separate state roots for governance, shared services, networking, AKS, AVD, management, workloads, and AWS branch resources.

**Evidence:** `terraform/`; `docs/release2/11-terraform-state-and-pipeline-map.md`.

## 5. AWX as the Automation Control Plane

**Context:** Automation needed RBAC, scheduling, audit trails, inventory management, and runtime secret retrieval.

**Options:** Standalone Ansible CLI, or a centralised AWX control plane.

**Decision:** Use Kubernetes-hosted AWX with Entra ID SSO, tiered job templates, GitHub sync, and runtime secrets from Azure Key Vault / AWS SSM.

**Evidence:** `docs/release2/evidence/A2-awx-control-plane/`.

## 6. Private AKS with No Public API Exposure

**Context:** Kubernetes control planes are high-value targets and should not be exposed unnecessarily.

**Options:** Public AKS API endpoint, or private AKS access pattern.

**Decision:** Deploy AKS using a private API access pattern and route workload egress through Azure Firewall.

**Evidence:** `docs/release2/evidence/O4/`.

## 7. AVD + FSLogix as the Secure Admin Workspace

**Context:** Operators needed a governed environment for privileged tools without relying on unmanaged local workstations.

**Options:** Local workstation administration, jump boxes, or AVD secure workspace.

**Decision:** Use Azure Virtual Desktop with FSLogix profile persistence, private endpoints, and a pre-staged administrative toolchain.

**Evidence:** `docs/release2/evidence/O5/`.

## 8. Human-in-the-Loop AI for CloudOps

**Context:** AI can accelerate operational analysis, but autonomous infrastructure mutation creates unacceptable risk.

**Options:** Autonomous AI agents, or AI assistance with explicit human approval gates.

**Decision:** Build the O6 AI Operations Enclave around MCP gateway policy enforcement, deny-by-default tool access, local-first model execution, Kubernetes support manifests, and human-in-the-loop execution boundaries.

**Evidence:** `docs/release2/evidence/O6/`; `kubernetes/`; `docs/release2/05-ai-operations-enclave.md`.

## 9. Release 3 as Roadmap, Not Concurrent Implementation

**Context:** Multi-cloud Kubernetes, GitOps, and DevSecOps are natural extensions, but they depend on the stable Release 2 platform foundation.

**Options:** Build Release 3 concurrently, or document it as a roadmap / platform evolution layer.

**Decision:** Keep Release 3 as a clearly marked roadmap layer until implementation evidence exists.

**Evidence:** `docs/release3/`.

These decisions are also reflected in `PORTFOLIO.md`, `ARCHITECTURE.md`, and the Release 2 capability stories.
