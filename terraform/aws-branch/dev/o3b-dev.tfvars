enable_o3b_aws_branch     = true
enable_o3b_aws_test_vms   = true
enable_o3b_aws_cisco      = false
enable_o3b_ssm_parameters = false

ssh_source_cidr              = "127.0.0.1/32"
key_pair_name                = "kp-dev-aws-branch"
test_vm_instance_type        = "t3.micro"
cisco_instance_type          = "t3.medium"
cisco_ami_ssm_parameter_name = "/aws/service/marketplace/prod-rhyp4n745z2jk/17.12.07b"
# Release 2 O3b management model:
# - ssh_source_cidr is the laptop break-glass/admin source supplied by workflow input.
# - additional_ssh_source_cidrs includes the Azure management/Ansible host.
additional_ssh_source_cidrs = [
  "4.235.98.212/32"
]
# O3b management host AWS runtime access:
# vm-dev-mgmt-01 uses IAM Roles Anywhere to retrieve only approved SSM SecureString parameters.
enable_o3b_mgmt_rolesanywhere = true

o3b_rolesanywhere_ca_certificate_path = "certs/o3b-mgmt-ca.crt"

o3b_mgmt_ssm_parameter_arns = [
  "arn:aws:ssm:eu-west-1:275544662748:parameter/azawslab/release2/o3b/cisco-restconf-password",
  "arn:aws:ssm:eu-west-1:275544662748:parameter/azawslab/release2/o3b/vpn-psk"
]

# O3c private validation:
# - Allows SSH to the trusted AWS test VM only from the Azure management host private IP.
# - This is intentionally not applied to the DMZ test VM.
# - Matching non-secret metadata is published to AWS SSM for audit/runtime reference.
trusted_private_ssh_source_cidrs = [
  "10.10.1.4/32"
]
