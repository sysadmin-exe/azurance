provider "azurerm" {
  features {}

}

terraform {
  backend "azurerm" {
    # This is a shared standalone resource group for the backend
    resource_group_name  = "customer3-terraform-backend"
    storage_account_name = "customer3tfstate"
    container_name       = "customer3tfstate"
    key                  = "customer3/dev/terraform.tfstate"
  }
}

module "customer3_dev_eastus" {
  source = "https://github.com/sysadmin-exe/azurance.gitref=v0.0.1"

  # Required variables
  location        = "East US"
  customer_name   = "customer1"
  environment     = "dev"
  product_version = "1.0.0"
  platform_type   = "S"
}