provider "azurerm" {
  features {}
  
}

module "customer1_production_eastus" {
  source = "https://github.com/sysadmin-exe/azurance.gitref=v0.0.1"
  
  # Required variables
  location             = "East US"
  customer_name = "customer1"
  environment          = "production"
  product_version       = "1.0.0"
  platform_type        = "XXL"
}