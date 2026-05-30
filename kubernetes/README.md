# Kubernetes Manifests

> Part of: [Azawslab Enterprise Hybrid Security Platform](../README.md)  
> Best for: technical reviewers, platform engineers, DevOps/SRE reviewers, and AI operations reviewers  
> Purpose: implementation support material for the Release 2 O6 AI Operations Enclave validation path

This folder contains Kubernetes manifests used to support Release 2 O6 AI Operations Enclave validation.

The formal O6 evidence record remains under [`docs/release2/evidence/O6/`](../docs/release2/evidence/O6/). This folder contains implementation support material, manifests, and live-validation scaffolding.

## Contents

| Path | Purpose |
|---|---|
| [`o6-ai-enclave/`](o6-ai-enclave/) | O6 enclave manifest set and supporting definitions |
| [`o6-ai-enclave-live/`](o6-ai-enclave-live/) | Live-validation version of the O6 enclave manifests |
| [`o6-live-core-all.yaml`](o6-live-core-all.yaml) | Consolidated core O6 live-validation manifest |
| [`o6-live-jobs-all.yaml`](o6-live-jobs-all.yaml) | Consolidated O6 live-validation job manifest |

## Relationship to Release 2

These manifests support the O6 AI Operations Enclave described in:

- [`docs/release2/05-ai-operations-enclave.md`](../docs/release2/05-ai-operations-enclave.md)
- [`docs/release2/evidence/O6/`](../docs/release2/evidence/O6/)
- [`docs/release2/evidence/README.md`](../docs/release2/evidence/README.md)

The root-level `kubernetes/` folder is supporting implementation material. It is not the primary evidence index.

## Safety notes

- Do not commit kubeconfig files.
- Do not commit Kubernetes Secrets with raw values.
- Do not commit raw tokens or generated credentials.
- Sanitize any exported cluster output before adding it to evidence.

---

## Navigation

- [Repository home](../README.md)
- [Reviewer guide](../REVIEWER_GUIDE.md)
- [Release 2 overview](../docs/release2/README.md)
- [O6 AI Operations Enclave](../docs/release2/05-ai-operations-enclave.md)
- [O6 evidence](../docs/release2/evidence/O6/)
- [Live AI operations page](https://www.azawslab.co.uk/ai-operations/)