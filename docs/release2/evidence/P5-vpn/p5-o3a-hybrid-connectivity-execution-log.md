# P5/O3a Hybrid Connectivity Execution Log

## Scope

This log records the real implementation path for the P5/O3a hybrid connectivity milestone.

The objective was to establish secure connectivity between the Azure hub/spoke environment and the Hyper-V/VyOS lab network:

```text
Azure hub/spoke environment
        |
        | secure hybrid connectivity
        |
Hyper-V / VyOS lab
192.168.1.0/24
```

## Final outcome

The final working design uses Azure VPN Gateway for AES-256 IPSec termination and keeps FortiGate deployed as the Azure hub NVA for inspection/service-chaining validation.

```text
[Azure Workload Spoke]
  vm-dev-client-01 / 10.10.0.4
        |
        | learned route: 192.168.1.0/24 via VirtualNetworkGateway
        |
[Azure Hub VNet]
  VPN Gateway: vpngw-dev-vyos-norwayeast-01
  Public IP: 20.100.50.9
        |
        | IKEv2 / IPSec
        | AES256 / SHA256 / DHGroup14 / PFS14
        |
[VyOS01 / Hyper-V]
  DDNS: vyos01.hq.azawslab.co.uk
  LAN: 192.168.1.0/24
  Gateway: 192.168.1.254
```

## Implementation timeline

### 1. FortiGate Stage 1 deployment

FortiGate was deployed successfully as an Azure NVA foundation using Terraform and GitHub Actions.

Validated items:

- FortiGate VM deployed and running.
- Public IP provisioned.
- Two NICs attached:
  - untrusted: 10.0.3.4
  - trusted: 10.0.3.36
- IP forwarding enabled on both NICs.
- Management access restricted by Azure NSG.
- Admin credential sourced from Azure Key Vault.
- FortiGate GUI login validated.

Evidence:

```text
docs/release2/evidence/P5-vpn/p5-o3a-fortigate-stage1-validation.txt
```

### 2. PAYG Marketplace blocker

The first FortiGate PAYG deployment attempt failed because the Azure subscription could not purchase paid Marketplace offers.

Engineering decision:

- Do not weaken governance.
- Do not bypass Terraform.
- Switch from PAYG to BYOL evaluation path.

### 3. FortiGate BYOL deployment

The FortiGate image was changed to BYOL:

```text
publisher = fortinet
offer     = fortinet_fortigate-vm_v5
sku       = fortinet_fg-vm
version   = 7.2.13
```

The VM size was aligned with the BYOL Marketplace validation path:

```text
Standard_D2s_v4
```

Azure Policy was updated to allow the required VM SKU through governance.

### 4. Accelerated networking adjustment

Azure rejected the FortiGate VM because Standard_D2s_v4 was restricted to one accelerated NIC, while the FortiGate design used two NICs.

Engineering decision:

- Disable accelerated networking for FortiGate lab NICs.
- Keep IP forwarding enabled.
- Document this as a lab delta.

Rationale:

- The lab goal was connectivity and architecture validation, not throughput benchmarking.
- Production deployments should use a Fortinet-recommended VM size and licensing model.

### 5. FortiGate IPSec crypto blocker

FortiGate BYOL permanent evaluation mode was found to restrict IPSec proposals to low-encryption DES-based options.

VyOS did not support single DES and supported modern options such as AES and 3DES.

Engineering decision:

- Do not force legacy DES.
- Do not weaken the IPSec baseline.
- Decouple encryption termination from NVA inspection.

Resulting architecture decision:

```text
Azure VPN Gateway = AES-256 IPSec termination
FortiGate NVA     = deployed inspection/service-chaining plane
VyOS              = simulated HQ/branch edge
```

### 6. Azure VPN Gateway fallback implementation

Azure VPN Gateway was added as the lab-safe IPSec termination point.

Important platform adjustments:

- Legacy VpnGw1 SKU was rejected because new non-AZ VPN Gateway SKUs are no longer supported.
- Updated SKU to VpnGw1AZ.
- Public IP was updated to a zonal Standard Public IP using zones 1, 2, and 3.

Created resources:

```text
pip-vpngw-vyos-norwayeast-01
vpngw-dev-vyos-norwayeast-01
lngw-dev-vyos-norwayeast-01
vcn-dev-vpngw-to-vyos
```

### 7. VyOS IPSec configuration

VyOS was configured with:

```text
IKEv2
AES256
SHA256
DH group 14
PFS group 14
NAT-T
VTI-based route-based IPSec
```

The tunnel came up successfully.

Azure confirmed active IKE and Quick Mode SAs.

### 8. Hub-spoke gateway transit fix

After the tunnel came up, Azure workload traffic initially failed because the workload spoke did not have a route back to the on-premises/HQ prefix.

Before fix:

```text
192.168.0.0/16 -> None
No 192.168.1.0/24 route via VirtualNetworkGateway
```

Terraform module update:

```text
Hub-to-spoke peering:
  allow_gateway_transit = true
  allow_forwarded_traffic = true

Spoke-to-hub peering:
  use_remote_gateways = true
  allow_forwarded_traffic = true
```

After fix:

```text
192.168.1.0/24 -> VirtualNetworkGateway
```

### 9. Data-plane validation

Final validation confirmed working routed traffic.

Validated paths:

```text
Azure VM 10.10.0.4 -> VyOS LAN gateway 192.168.1.254
VyOS LAN source 192.168.1.254 -> Azure hub FortiGate interface 10.0.3.4
```

Azure VPN connection showed:

```text
ConnectionStatus = Connected
EgressBytesTransferred > 0
IngressBytesTransferred > 0
```

Evidence:

```text
docs/release2/evidence/P5-vpn/p5-o3a-azure-vpngw-vyos-data-plane-validation.txt
```

## Final design rationale

The final design intentionally separates connectivity from inspection:

```text
Connectivity plane:
  Azure VPN Gateway
  IKEv2 / IPSec / AES-256

Inspection plane:
  FortiGate NVA
  Future service chaining and segmentation validation

Deployment plane:
  Terraform
  GitHub Actions
  OIDC

Secret plane:
  Azure Key Vault
```

This reflects a realistic enterprise pattern where managed VPN termination provides reliable encrypted connectivity, while an NVA provides inspection, segmentation, and future policy enforcement.

## Lab deltas

The following are documented lab deltas:

- FortiGate runs as a single VM, not an HA pair.
- FortiGate uses BYOL permanent evaluation mode.
- FortiGate BYOL trial crypto restrictions prevented production-grade direct IPSec validation.
- Azure VPN Gateway was used to preserve AES-256 IPSec standards.
- FortiGate accelerated networking was disabled due Standard_D2s_v4 two-NIC constraints.
- FortiGate inspection/service-chaining is a follow-on validation step.

## Production alignment

A production design would normally include:

- FortiGate full license or enterprise NVA license.
- NVA HA pair or managed NVA scale model.
- Azure Route Server, Virtual WAN, or carefully governed UDRs for scalable route propagation.
- Centralized logging to Log Analytics / Sentinel.
- Strict NSG and firewall policy enforcement.
- CI/CD-only changes through OIDC.
- Key Vault-backed secrets.
- Documented break-glass and governance controls.
