# O4 - Private AKS Platform

## What This Evidence Proves
A private AKS cluster is operational with no public API, container egress through Azure Firewall, managed Prometheus/Grafana monitoring, and AWX integration readiness.

## Evidence Inventory
- Cluster overview (running state)
- Firewall egress validation (firewall-level and pod-level)
- Internal application accessibility
- Managed monitoring dashboard evidence
- AWX readiness audit and tier execution logs

## How to Interpret
Confirm the cluster's API server is private; verify that pod egress traffic appears in firewall logs; check the Grafana dashboard for cluster metrics.

## Redaction Notes
Cluster names, internal IPs, and pod details are redacted; operational state is preserved.

## Related Capability Document
- [04. Private Platform & Secure Workspace](../../04-private-platform-secure-workspace.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Container workloads are isolated, monitored, and automation-ready.**