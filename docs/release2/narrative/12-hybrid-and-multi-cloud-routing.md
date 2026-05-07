# 12-hybrid-and-multi-cloud-routing

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

## P5/O3a Hybrid Connectivity Extension - FortiGate, VPN Gateway, and VyOS

This phase extends the completed Azure hub-spoke networking foundation into a controlled hybrid connectivity pattern. The objective is to connect the Azure platform to the local Hyper-V lab through a secure IPSec path so that Azure-hosted management and Ansible orchestration can later reach private lab systems without exposing them directly to the internet.

The Terraform ownership boundary remains in the platform networking root because the resources involved are network-transit components: VPN Gateway, Local Network Gateway, VPN connection objects, FortiGate-related network resources, and route-table updates. This avoids mixing hybrid transit resources into workload or management state.

```text
[terraform/platform-networking/dev]
        |
        | backend key:
        | platform-networking-dev.tfstate
        |
        +--> Existing P5 hub/spoke networking
        +--> New fortigate-vpn.tf skeleton
              |
              +--> FortiGate-related Azure resources
              +--> VPN Gateway resources
              +--> Local Network Gateway for VyOS
              +--> VPN connection
              +--> route-table updates for 192.168.1.0/24

[Hyper-V / VyOS]
        |
        | DDNS peer:
        | vyos01.hq.azawslab.co.uk
        |
        v
[192.168.1.0/24 lab subnet]
```

### Lab Delta

In a production enterprise environment, the remote peer would normally use a stable static public IP address, redundant edge devices, controlled change windows, and formal routing/firewall approval. In this lab, the Hyper-V edge is represented by VyOS with Dynamic DNS. This is documented as a lab-safe adaptation to prove the routing and automation pattern without requiring business-grade WAN services.

### Current Deployment Safety

The FortiGate and VPN resources are held behind Terraform enable flags and are not deployed by local apply. Local PowerShell and Terraform commands are used only for preflight, validation, and evidence capture. Any future apply must run through the controlled GitHub Actions release-2 environment using OIDC.

### Validation Intent

Successful validation will prove that Azure can route to the Hyper-V lab subnet through the approved VPN path. This is a prerequisite before Azure-hosted Ansible orchestration can perform domain join, configuration management, or server administration against private Hyper-V systems.

