output "platform_endpoint" {
  description = "PPublic IP To Access Platform"
  value       = azurerm_lb.azurance.frontend_ip_configuration[0].public_ip_address
}

output "platform_name" {
  description = "Name of the platform"
  value       = "${local.resource_name_prefix}-${var.platform_type}"
}