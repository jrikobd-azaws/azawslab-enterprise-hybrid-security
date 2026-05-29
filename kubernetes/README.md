# Kubernetes Manifests

This folder contains Kubernetes manifests used to support Release 2 O6 AI Operations Enclave validation.

The formal O6 evidence record remains under `docs/release2/evidence/O6/`. This folder contains implementation support material, manifests, and live-validation scaffolding.

## Contents

| Path | Purpose |
|---|---|
| `o6-ai-enclave/` | O6 enclave manifest set and supporting definitions |
| `o6-ai-enclave-live/` | Live-validation version of the O6 enclave manifests |
| `o6-live-core-all.yaml` | Consolidated core O6 live-validation manifest |
| `o6-live-jobs-all.yaml` | Consolidated O6 live-validation job manifest |

## Relationship to Release 2

These manifests support the O6 AI Operations Enclave described in:

- `docs/release2/05-ai-operations-enclave.md`
- `docs/release2/evidence/O6/`

The root-level `kubernetes/` folder is supporting implementation material. It is not the primary evidence index.

## Safety Notes

- Do not commit kubeconfig files.
- Do not commit Kubernetes Secrets with raw values.
- Do not commit raw tokens or generated credentials.
- Sanitize any exported cluster output before adding it to evidence.
