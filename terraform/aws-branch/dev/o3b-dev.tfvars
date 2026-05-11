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
