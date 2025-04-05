locals {
    resource_name_prefix = "${var.customer_name}-${environment}-"
}

variable "customer_name" {
    description = "The name of the customer using the product"
    type = string
}

variable "environment" {
    description = "Deployment Environment Name"
    type = string
}

variable "product_version" {
    description = Version of product to be deployed"
    type = string
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
    type = string
}

var