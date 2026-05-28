# O6 Monitoring Workbook Outline

Status: prepared only. No live Azure Monitor workbook is currently deployed.

Recommended workbook sections:

1. Model/API call volume
2. MCP/tool call decisions
3. Denied tool calls
4. Redaction events
5. Output-filter events
6. Fallback events
7. Approval-required events
8. Agent-level activity summary
9. Correlation ID drill-down

Minimum fields:

- timestamp
- correlation_id
- agent_name
- agent_identity
- provider
- model
- tool_name
- target_system
- policy_decision
- redaction_applied
- output_filter_result
- fallback_used
- status
- duration_ms
- error

Current state:

- Query pack prepared.
- No live dashboard deployed.
- No cloud resources are currently active.
