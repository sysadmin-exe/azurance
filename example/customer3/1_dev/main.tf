provider "azurerm" {
  features {}
  
}

module "customer3_dev_eastus" {
  source = "https://github.com/sysadmin-exe/azurance.gitref=v0.0.1"
  
  # Required variables
  location             = "East US"
  customer_name = "customer1"
  environment          = "dev"
  product_version       = "1.0.0"
  platform_type        = "S"
}