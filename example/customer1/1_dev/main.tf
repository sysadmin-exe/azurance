provider "azurerm" {
  features {}

}

terraform {
  # This is a shared standalone resource group for the backend

  backend "azurerm" {
    resource_group_name  = "customer1-terraform-backend"
    storage_account_name = "customer1tfstate"
    container_name       = "customer1tfstate"
    key                  = "customer1/dev/terraform.tfstate"
  }
}

module "customer1_dev_eastus" {
  source = "https://github.com/sysadmin-exe/azurance.gitref=v0.0.1"

  # Required variables
  location        = "East US"
  customer_name   = "customer1"
  environment     = "dev"
  product_version = "1.0.0"
  platform_type   = "S"
}