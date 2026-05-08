# O1 FortiGate Service-Chain Closeout Evidence

## Scope

This evidence closes out O1 for the Azure workload to HQ direction only.

Validated direction:

```text
Azure workload -> FortiGate NVA -> Azure VPN Gateway -> VyOS/HQ
```

Out of scope for this closeout:
- HQ/VyOS-initiated traffic toward Azure workloads through FortiGate
- GatewaySubnet ingress steering
- full bidirectional NVA inspection
- production no-NAT design

## Validated Path

```text
vm-dev-client-01 / 10.10.0.4
  -> workload UDR 192.168.1.0/24 via 10.0.3.36
  -> FortiGate port2
  -> FortiGate policy ID 1
  -> SNAT to 10.0.3.4
  -> FortiGate port1
  -> Azure VPN Gateway
  -> VyOS / 192.168.1.254
  -> reply through FortiGate back to 10.10.0.4
```

## Key Evidence

Azure route:
```text
192.168.1.0/24 -> VirtualAppliance -> 10.0.3.36
```

FortiGate debug flow:
```text
Allowed by Policy-1: SNAT
SNAT 10.10.0.4 -> 10.0.3.4
gw 10.0.3.1 via port1
```

VyOS tcpdump:
```text
vti1 In   10.0.3.4 -> 192.168.1.254  ICMP echo request
vti1 Out  192.168.1.254 -> 10.0.3.4  ICMP echo reply
```

FortiGate sniffer:
```text
port2 in   10.10.0.4 -> 192.168.1.254: icmp echo request
port1 out  10.0.3.4 -> 192.168.1.254: icmp echo request
port1 in   192.168.1.254 -> 10.0.3.4: icmp echo reply
port2 out  192.168.1.254 -> 10.10.0.4: icmp echo reply
```

## Conclusion

O1 FortiGate service-chain validation succeeded for Azure workload to HQ traffic.

## Lab Delta

SNAT was used for the first controlled validation to avoid asymmetric return routing. This should be revisited before presenting the design as a production service-chain pattern.
