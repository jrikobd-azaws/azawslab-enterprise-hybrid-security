# O6 AI Enclave Kubernetes Scaffold

This folder contains the prepared Kubernetes scaffold for the O6 Secure AI Operations Enclave.

Current state:

- Prepared only.
- Not deployed.
- No cloud resources are currently active.
- No AKS namespace has been applied.
- No public ingress is defined.
- No LoadBalancer service is defined.
- No secrets are stored in this folder.

Files:

- `namespace.yaml` - prepared `ai-enclave` namespace.
- `serviceaccounts.yaml` - prepared Workload Identity service accounts with placeholder client IDs.
- `networkpolicy-deny-all.yaml` - deny-all baseline.
- `networkpolicy-allow-dns.yaml` - DNS egress exception.
- `networkpolicy-allow-internal-mcp.yaml` - internal agent-to-MCP gateway path.

Future live validation commands, only during approved validation window:

```powershell
kubectl apply --dry-run=server -f kubernetes\o6-ai-enclave
kubectl apply -f kubernetes\o6-ai-enclave
kubectl get ns ai-enclave
kubectl get sa -n ai-enclave
kubectl get networkpolicy -n ai-enclave
```

Do not run live `kubectl apply` until the private AKS dependency is intentionally available and the validation window is approved.
