module "security" {
  source = "../../modules/security"

  resource_group_name = "rg-dev-security-uksouth"
  location            = "uksouth"
}
