# O6 - AI Operations Enclave

## What This Evidence Proves
The O6 AI Operations Enclave is governed and evidenced: MCP gateway configured, deny-by-default policy enforced, agent-specific access scoped, network isolation verified, and namespace lifecycle validated.

## Evidence Inventory
- MCP gateway config (`o6-mcp-gateway-live.json`)
- Policy decision logs (`o6-mcp-policy-decision-logs.json`)
- Agent enforcement records:
  - `o6-finops-agent-policy-logs.json`
  - `o6-runbook-agent-policy-logs.json`
  - `o6-secops-agent-policy-logs.json`
- Network policy and egress validation:
  - `o6-networkpolicies-live.json`
  - `o6-network-egress-deny-proof.json`
- Namespace lifecycle:
  - `o6-namespace-live.json`
  - `o6-namespace-delete-output.json`
  - `o6-namespace-post-delete-check.json`
- Post-cleanup validation:
  - `o6-post-cleanup-node-resource-group-check.txt`
  - `o6-post-cleanup-resource-group-check.txt`
  - `o6-post-cleanup-resource-list.txt`

## How to Interpret
Check the MCP gateway config for tool definitions and the policy decision logs for allow/deny actions. Verify that network egress deny rules are in place and that namespaces are cleaned after use.

## Redaction Notes
Resource names, internal endpoints, and tool IDs are partially redacted; enforcement decisions are preserved.

## Related Capability Document
- [05. AI Operations Enclave](../../05-ai-operations-enclave.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Policy decisions, network boundaries, namespace lifecycle, and cleanup checks are captured as reviewable evidence.**