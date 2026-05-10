# 11-hybrid-management-extension

## 1. Objective

## 2. Business Problem

## 3. Technical Solution

## 4. Architecture Snapshot

## 5. Implementation Summary

## 6. Validation Summary

## 7. Evidence Path

## 8. Key Commands Used

## 9. Lessons Learned

## 10. Recruiter-Ready Outcome Statement

---

## P5 Update - FortiGate Symmetric HQ-to-Azure Workload Path

The HQ-to-Azure IIS validation exposed asymmetric routing. The workload subnet already sent return traffic for 192.168.1.0/24 to FortiGate port2, but GatewaySubnet initially sent HQ-initiated traffic directly to the workload subnet. FortiGate therefore saw return traffic only.

The validated fix was a targeted GatewaySubnet UDR for 10.10.0.0/24 with next hop FortiGate port1, creating a symmetric inspected path.

```text
DC1
  -> VPN Gateway / GatewaySubnet
  -> UDR 10.10.0.0/24 -> FortiGate port1
  -> FortiGate policy port1 -> port2
  -> vm-dev-client-01
  -> FortiGate port2
  -> FortiGate policy port2 -> port1
  -> VPN Gateway
  -> DC1
```

This route was validated manually and must be reconciled into Terraform before P5 is considered fully IaC-complete.
