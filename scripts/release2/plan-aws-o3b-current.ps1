param(
  [string]$RepoRoot = 'C:\GitHub\azawslab-enterprise-hybrid-security',
  [string]$AwsProfile = 'azawslab-admin',
  [string]$SshSourceCidr = '77.99.208.6/32'
)

$ErrorActionPreference = 'Stop'

$AwsRoot = Join-Path -Path $RepoRoot -ChildPath 'terraform/aws-branch/dev'
Set-Location -Path $AwsRoot

$env:AWS_PROFILE = $AwsProfile

terraform init -input=false
terraform validate

terraform plan -no-color -input=false `
  -var-file='o3b-dev.tfvars' `
  -var="ssh_source_cidr=$SshSourceCidr" `
  -var='enable_o3b_ssm_parameters=true' `
  -var='enable_o3b_aws_cisco=true'