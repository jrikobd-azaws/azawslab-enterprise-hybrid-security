---
title: Companion AI Lab
---

# Companion Project: local-ai-lab-infra

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/proof-gallery/">
    <span class="portfolio-chip-label">Proof</span>
    <span class="portfolio-chip-value">Gallery</span>
  </a>
  <a class="portfolio-chip" href="/skills-matrix/">
    <span class="portfolio-chip-label">Skills</span>
    <span class="portfolio-chip-value">Matrix</span>
  </a>
</div>

`local-ai-lab-infra` is the working companion implementation for the O6 AI Operations Enclave story.

The main repository demonstrates the enterprise hybrid security platform, O6 evidence, Kubernetes support manifests, and governance boundary. The companion repository demonstrates the local-first multi-agent AI infrastructure workflow that supports the O6 narrative.

## What the companion project implements

| Area | Implementation signal |
|---|---|
| Local-first AI coding | DeepSeek Coder runs through Ollama for Terraform and Ansible generation |
| Multi-agent workflow | Architect, Coder, SecOps, FinOps, and GitOps roles are orchestrated as a pipeline |
| RAG and local knowledge | Local vector DB/RAG support provides project-aware context |
| Tool permissions | Project configuration controls allowed and denied tools per workspace |
| Deny-by-default security | Agents cannot call tools unless those tools are explicitly allowed |
| Workspace isolation | Different client or project workspaces can have different permissions |
| Validation hooks | Terraform and Ansible validation are supported without deployment |
| Data-boundary controls | Local generation, optional cloud review, and redaction controls reduce unnecessary exposure |

## Relationship to this portfolio

| Repository | Role |
|---|---|
| `azawslab-enterprise-hybrid-security` | Enterprise platform, security architecture, IaC, evidence vault, O6 enclave pattern |
| `local-ai-lab-infra` | Local-first multi-agent AI infrastructure implementation with RAG, provider routing, validation, and tool-control boundaries |

## Why it matters

Together, the two repositories show a stronger story than either one alone:

- The main repo proves enterprise hybrid/cloud platform engineering.
- The companion repo proves practical AI-assisted infrastructure workflow design.
- O6 connects them through a governed operations model.
- Human review, validation, and permission boundaries remain central.

## Reviewer signals

| Signal | What it shows |
|---|---|
| Local-first coding | Sensitive IaC generation can remain on the engineer-controlled machine |
| Multi-agent workflow | AI responsibilities are separated into architecture, coding, security, cost, and GitOps stages |
| Deny-by-default permissions | Tool access is constrained instead of assumed |
| Validation hooks | Generated Terraform and Ansible can be checked before human review |
| Configurable cloud review | Cloud agents can be used selectively with data-boundary awareness |

## Source links

- [local-ai-lab-infra repository](https://github.com/jrikobd-azaws/local-ai-lab-infra){ target="_blank" }
- [Companion configuration model](https://github.com/jrikobd-azaws/local-ai-lab-infra/tree/main/configs){ target="_blank" }
- [Main repo O6 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6){ target="_blank" }
- [Main repo O6 Kubernetes support](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/kubernetes){ target="_blank" }

!!! note "Accurate positioning"
    The companion repo is a lab/reference implementation. Its value is the governed workflow: local-first generation, permission control, validation, redaction, and human-reviewed outputs.

[Back to Home](index.md)
