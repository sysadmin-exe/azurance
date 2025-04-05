provider "azurerm" {
  features {}

}

terraform {
  backend "azurerm" {
    # This is a shared standalone resource group for the backend
    resource_group_name  = "customer2-terraform-backend"
    storage_account_name = "customer2tfstate"
    container_name       = "customer2tfstate"
    key                  = "customer2/staging/terraform.tfstate"
  }
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