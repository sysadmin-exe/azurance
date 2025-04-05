provider "azurerm" {
  features {}

}

terraform {
  backend "azurerm" {
    # This is a shared standalone resource group for the backend
    resource_group_name  = "customer1-terraform-backend"
    storage_account_name = "customer1tfstate"
    container_name       = "customer1tfstate"
    key                  = "customer1/production/terraform.tfstate"
  }
}

module "customer1_production_eastus" {
  source = "https://github.com/sysadmin-exe/azurance.gitref=v0.0.1"

  # Required variables
  location        = "East US"
  customer_name   = "customer1"
  environment     = "production"
  product_version = "1.0.0"
  platform_type   = "XXL"
}