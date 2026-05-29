# FortiGate Service-Chain Role

This role codifies the validated Release 2 O1 FortiGate service-chain configuration.

## Scope

Validated direction:

```text
Azure workload -> FortiGate -> Azure VPN Gateway -> VyOS/HQ
```

Validated path:

```text
[Azure Workload VM]
  10.10.0.4
      |
      | Terraform UDR:
      | 192.168.1.0/24 -> 10.0.3.36
      v
[FortiGate port2]
  10.0.3.36
      |
      | policy:
      | source      = 10.10.0.0/16
      | destination = 192.168.1.0/24
      | service     = PING
      | SNAT        = enabled
      | logging     = all
      v
[FortiGate port1]
  10.0.3.4
      |
      v
[Azure VPN Gateway -> VyOS/HQ]
  192.168.1.254
```

## Codified objects

Address objects:
- `AZURE_WORKLOAD_10_10_0_0_16`
- `HQ_LAB_192_168_1_0_24`

Static routes:
- `10.10.0.0/16 -> 10.0.3.33 via port2`
- `192.168.1.0/24 -> 10.0.3.1 via port1`

Firewall policy:
- `O1-AzureWorkload-to-HQ-ICMP-SNAT`

## Lab delta

SNAT is enabled for first controlled validation to avoid asymmetric return routing.

This role does not codify:
- HQ/VyOS-initiated inspection toward Azure workloads
- GatewaySubnet ingress steering
- full bidirectional inspection
- production no-NAT service chaining

## Authentication

Do not commit FortiGate passwords or API tokens.

Use runtime secrets, Ansible Vault, or environment-specific inventory kept outside the repo.
