param(
  [string]$RepoRoot = 'C:\GitHub\azawslab-enterprise-hybrid-security'
)

$ErrorActionPreference = 'Stop'

$PlatformRoot = Join-Path -Path $RepoRoot -ChildPath 'terraform/platform-networking/dev'
Set-Location -Path $PlatformRoot

terraform init -input=false
terraform validate

terraform plan -no-color -input=false `
  -var='enable_p5_fortigate=true' `
  -var='enable_o3a_fortigate_vyos_ipsec=false' `
  -var='enable_o3a_azure_vpngw_vyos=true' `
  -var='enable_o1_fortigate_service_chain=true' `
  -var='enable_p5_gateway_ingress_fortigate=true' `
  -var='enable_o3b_aws_cisco_vpn=true'