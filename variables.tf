locals {
  resource_name_prefix = "${var.customer_name}-${environment}-"
  platform_type = {
    "S" = {
      size = "Standard_DS1_v2"
    }
    "M" = {
      size = "Standard_DS2_v2"
    }
    "L" = {
      size = "Standard_DS3_v2"
    }
    "XL" = {
      size = "Standard_DS4_v2"
    }
    "XXL" = {
      size = "Standard_DS5_v2"
    }
  }
}

variable "customer_name" {
  description = "The name of the customer using the product"
  type        = string
}

variable "environment" {
  description = "Deployment Environment Name"
  type        = string
}

variable "product_version" {
  description = "Version of product to be deployed"
  type        = string
}

variable "platform_type" {
  description = "Specifies the size and type of hosting platform as T-Shirt sizes"
  type        = string

  validation {
    condition     = contains(["S", "M", "L", "XL", "XXL"], var.platform_type)
    error_message = "platform_type must be one of: S, M, L, XL, XXL."
  }
}

variable "location" {
  description = "Location for hosting platform"
  type        = string
}

