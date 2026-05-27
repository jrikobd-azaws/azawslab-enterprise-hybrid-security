# 05. AI Operations Enclave

> **Part of** [Release 2 — Azure Platform Engineering, Security, Automation, Private Platform & AI Operations](./README.md)
>
> **Status:** Implemented and evidenced.

---

## What This Solves

Granting AI autonomous infrastructure access creates material operational and security risk. Without explicit boundaries, policy enforcement, and human approval gates, an AI-driven agent could misinterpret instructions and make unintended changes to a governed cloud platform.

This capability story demonstrates how the **O6 AI Operations Enclave** introduces governed AI assistance into CloudOps without autonomous infrastructure mutation. AI agents support analysis, validation, summarisation, FinOps/SecOps review, GitOps text, and runbook drafting; execution remains gated behind human approval and the established Terraform/AWX/GitHub Actions delivery paths.

---

## What Was Built

| Component | Description | Evidence |
|---|---|---|
| **MCP Gateway / Controlled Tool Boundary** | Model Context Protocol gateway enforcing deny-by-default access; all tool requests validated against active policy | `docs/release2/evidence/O6/` (`o6-mcp-gateway-live.json`) |
| **Policy Decision Engine** | Per-project configuration defining which agents can use which tools; every decision logged | `docs/release2/evidence/O6/` (`o6-mcp-policy-decision-logs.json`) |
| **Agent-Specific Enforcement** | Role-scoped access for FinOps, Runbook, SecOps, and GitOps agents; each agent constrained to its authorised tools | `docs/release2/evidence/O6/` (`o6-*-agent-policy-logs.json`) |
| **Network Policy Verification** | Validation that enclave network egress rules and isolation boundaries are enforced | `docs/release2/evidence/O6/` (`o6-network-policy-verification.txt`, `o6-network-egress-deny-proof.json`) |
| **Namespace Lifecycle & Cleanup** | Creation, governance, and post-teardown validation of AI-managed namespaces | `docs/release2/evidence/O6/` (`o6-namespace-lifecycle.txt`, `o6-post-cleanup-validation.txt`) |
| **Companion Runtime** | `local-ai-lab-infra` — multi-agent LangGraph pipeline with local RAG (Chroma, Ollama), deny-by-default tool permissions, and human-in-the-loop gating. Supports multiple local models (`gpt-oss-tools`, `deepseek-r1-tools`, `gemma3-tools`, `llama3.2`, `nomic-embed-text`) and optional cloud APIs (Groq, GPT, Claude, DeepSeek R1, Mistral, NIM) | [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra); [`usage guide`](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/how_to_use_project.md) |
| **Kubernetes O6 Manifests** | Repository-level Kubernetes manifests and live-validation support for the O6 enclave, including namespace, policy, gateway, and job definitions used to validate the governed AI operations pattern | [`kubernetes/`](../../kubernetes/) |
---

## Architecture

```text
┌──────────────────────────────────────────────────────────────────┐
│                    Local AI Execution Engine                      │
│                 (local-ai-lab-infra Repository)                   │
│                                                                  │
│  ┌──────────────────────┐         ┌────────────────────────────┐ │
│  │ LangGraph Orchestrator│◄───────►│ Chroma Vector DB (RAG)    │ │
│  │ (Multi-Agent Logic)   │         └────────────────────────────┘ │
│  └──────────┬───────────┘                                        │
│             │                                                    │
│  ┌──────────▼───────────┐         ┌────────────────────────────┐ │
│  │ Ollama (local models)│◄───────►│ MCP Policy Gateway         │ │
│  │ gpt-oss-tools,       │         │ (Deny-by-Default)          │ │
│  │ deepseek-r1-tools,   │         └─────────────┬──────────────┘ │
│  │ gemma3-tools, etc.   │                        │                │
│  └──────────────────────┘                        │                │
│  ┌───────────────────────────────────────────────┘                │
│  │ Optional Cloud APIs (Groq, GPT, Claude, DeepSeek R1, etc.)  │
│  │ all subject to same MCP tool policy & local RAG gating       │
└─────────────────────────────────────────────────┼────────────────┘
                                                  │
           ┌──────────────────────────────────────┼──────────────────┐
           │                Gated Execution Boundary                 │
           │                                                         │
           │     ┌─────────────────────────────────────────────┐     │
           │     │          Human-in-the-Loop Gate             │     │
           │     │  (AI recommends → Human reviews → Git commit)│     │
           │     └────────────────────┬────────────────────────┘     │
           │                          │                              │
           │     ┌────────────────────▼────────────────────────┐     │
           │     │   Azure Platform (Terraform / AWX CI/CD)    │     │
           │     │        (AI cannot mutate infrastructure)     │     │
           │     └─────────────────────────────────────────────┘     │
           └─────────────────────────────────────────────────────────┘
```

*Diagram placeholder — `diagrams/release2/ai-ops-enclave.png`*

---

## How It Works

### 1. Dual-Repository Control Model

The architecture physically separates the **AI runtime** from the **infrastructure state**.

- **`local-ai-lab-infra`** is the execution engine: a LangGraph-orchestrated multi-agent pipeline with local RAG (Chroma) and local inference via Ollama. It runs a selection of local models (`gpt-oss-tools`, `deepseek-r1-tools`, `gemma3-tools`, `llama3.2`, `nomic-embed-text`) and can optionally use cloud-hosted APIs (Groq, GPT, Claude, DeepSeek R1, Mistral, NIM). All model access is governed by the same MCP tool policy.
- **`azawslab-enterprise-hybrid-security`** acts as the evidence vault: the `docs/release2/evidence/O6/` directory stores auditable logs, policy decisions, and validation records, proving that the enclave operated under governance.

### 2. Privacy-First Local Code Generation

Sensitive Infrastructure as Code (Terraform, Ansible) is generated locally using Ollama with the available local models. Proprietary IaC never leaves the host unless cloud review is explicitly configured with sanitised summaries. This pattern keeps confidential platform design within the local enclave while still permitting non-sensitive documentation analysis to use cloud-based models.

### 3. MCP Gateway / Controlled Tool Boundary

The Model Context Protocol (MCP) gateway acts as a security proxy. Every tool request from an agent is intercepted and validated against `configs/project_config.yaml`. If the requesting agent is not explicitly permitted to use that tool, the request is rejected and the decision is logged in `o6-mcp-policy-decision-logs.json`. This deny-by-default posture ensures no agent can perform unintended actions.

### 4. Human-in-the-Loop Execution Authority

The enclave enforces a strict boundary between **analysis** and **execution**. AI agents can:

- Analyse logs, configuration states, and cost data.
- Generate runbook drafts, Terraform snippets, and security reviews.
- Produce pull-request summaries and GitOps commentary.

But they **cannot** apply Terraform, execute Ansible playbooks, or mutate any infrastructure. Every AI-generated artefact must be reviewed by a human operator. Validation is deliberately separated from deployment: AI output may be linted, validated, reviewed, and converted into a runbook or pull request, but infrastructure mutation remains behind human approval and the established Terraform/AWX delivery path.

### 5. Evidence as a First-Class Output

O6 is designed so AI-assisted operations produce reviewable evidence. The evidence folder captures the full control boundary and lifecycle:

- MCP gateway configuration proves the controlled tool boundary was deployed and active.
- Policy decision logs prove that allow/deny decisions were enforced and recorded.
- Agent-specific policy logs demonstrate role-scoped access for FinOps, Runbook, SecOps, and GitOps workflows.
- Network policy verification proves that enclave egress rules and isolation boundaries were validated.
- Namespace lifecycle and post-cleanup validation prove the enclave can be governed, cleaned up, and revalidated without residual artifacts.

---

## Evidence

| What | Where | Why It Matters |
|---|---|---|
| MCP gateway configuration | `docs/release2/evidence/O6/` (`o6-mcp-gateway-live.json`) | Proves the controlled tool boundary was deployed and configured |
| Policy decision logs | `docs/release2/evidence/O6/` (`o6-mcp-policy-decision-logs.json`) | Proves allow/deny enforcement decisions were captured |
| Agent-specific policy records | `docs/release2/evidence/O6/` (`o6-*-agent-policy-logs.json`) | Proves role-scoped access for FinOps, Runbook, SecOps, GitOps |
| Network policy verification | `docs/release2/evidence/O6/` (`o6-network-policy-verification.txt`, `o6-network-egress-deny-proof.json`) | Proves enclave network boundaries were enforced |
| Namespace lifecycle management | `docs/release2/evidence/O6/` (`o6-namespace-lifecycle.txt`) | Proves AI-managed namespaces were governed |
| Post-cleanup validation | `docs/release2/evidence/O6/` (`o6-post-cleanup-validation.txt`) | Proves the enclave can be torn down cleanly |
| Companion project runtime | [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra); [`usage guide`](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/how_to_use_project.md) | Proves the multi-agent pipeline and configuration exist |
| Kubernetes manifest support | [`kubernetes/`](../../kubernetes/) | Provides O6 Kubernetes manifests and live-validation scaffolding; formal validation evidence remains under `docs/release2/evidence/O6/` |
---

## Operational Notes

- **AI does not mutate infrastructure.** All execution — Terraform apply, Ansible playbook runs — remains within the controlled CI/CD pipelines and requires human approval.
- **Deny-by-default applies to every agent.** No agent can use a tool unless explicitly permitted in the project configuration.
- **Local code generation protects sensitive IaC.** The local Ollama models handle code generation; code does not leave the machine unless cloud review is explicitly configured.
- **Policy decision logs are retained as evidence.** Every allow/deny decision is recorded for audit.
- **The companion project provides the AI runtime; the main repository provides platform-side evidence.** Together, they show the full O6 pattern without mixing runtime implementation details into the core platform evidence repository.
- **Kubernetes manifests support O6 live validation.** The root-level `kubernetes/` folder contains O6 enclave manifests and job definitions; formal evidence remains in `docs/release2/evidence/O6/`.
---

## What I Learned

- **AI governance is a first-class platform engineering concern.** The MCP gateway, deny-by-default tool access, and human-in-the-loop gating are as essential to a modern platform as firewalls and RBAC.
- **Local LLM inference is operationally viable for sensitive IaC tasks.** Running models like `deepseek-r1-tools` and `gpt-oss-tools` locally provides sufficient capability for code generation while maintaining data sovereignty.
- **Evidence of AI governance matters as much as evidence of AI output.** Policy decision logs and agent enforcement records prove that the AI was controlled, not just that it produced results.
- **Validation is not deployment.** Keeping AI-generated output subject to human review and standard CI/CD pipelines ensures that AI accelerates operations without bypassing the governance the platform was built to enforce.

---

## Implementation Positioning

The O6 AI Operations Enclave demonstrates a governed, human-approved approach to AI-assisted CloudOps. It proves that AI can accelerate operational analysis and runbook drafting without introducing autonomous infrastructure mutation. The combination of deny-by-default tool permissions, MCP policy enforcement, local-first code generation (with multiple local models and optional cloud APIs), human-in-the-loop gating, and auditable decision logs provides strong evidence for **Cloud Security Architect** and **DevOps / SRE** roles where AI governance is increasingly expected.

Reviewers should focus on:
- The explicit execution boundary between AI analysis and infrastructure mutation.
- The deny-by-default tool access model and per-project policy configuration.
- The privacy-first local code generation pattern using a growing set of local models.
- The evidence trail: policy decision logs, agent enforcement records, network policy verification, and post-cleanup validation.