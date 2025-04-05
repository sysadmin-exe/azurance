provider "azurerm" {
  features {}

}

module "customer2_staging_eastus" {
  source = "https://github.com/sysadmin-exe/azurance.gitref=v0.0.1"

  # Required variables
  location        = "East US"
  customer_name   = "customer1"
  environment     = "staging"
  product_version = "1.0.0"
  platform_type   = "M"
}