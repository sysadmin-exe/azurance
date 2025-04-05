# Azure Provider configuration
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "azurance" {
  name     = "${local.resource_name_prefix}rg"
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "azurance" {
  name                = "${local.resource_name_prefix}vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azurance.location
  resource_group_name = azurerm_resource_group.azurance.name
}

# Create three subnets in different AZs
resource "azurerm_subnet" "subnet1" {
  name                 = "${local.resource_name_prefix}subnet1"
  resource_group_name  = azurerm_resource_group.azurance.name
  virtual_network_name = azurerm_virtual_network.azurance.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${local.resource_name_prefix}subnet2"
  resource_group_name  = azurerm_resource_group.azurance.name
  virtual_network_name = azurerm_virtual_network.azurance.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "${local.resource_name_prefix}subnet3"
  resource_group_name  = azurerm_resource_group.azurance.name
  virtual_network_name = azurerm_virtual_network.azurance.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Create a network interface for the VM
resource "azurerm_network_interface" "azurance" {
  name                = "${local.resource_name_prefix}nic"
  location            = azurerm_resource_group.azurance.location
  resource_group_name = azurerm_resource_group.azurance.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a network security group
resource "azurerm_network_security_group" "azurance" {
  name                = "${local.resource_name_prefix}nsg"
  location            = azurerm_resource_group.azurance.location
  resource_group_name = azurerm_resource_group.azurance.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "azurance" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.azurance.id
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "azurance" {
  name                  = "${local.resource_name_prefix}vm"
  location              = azurerm_resource_group.azurance.location
  resource_group_name   = azurerm_resource_group.azurance.name
  network_interface_ids = [azurerm_network_interface.azurance.id]
  size                  = lookup(local.platform_type, "${var.platform_type}".size, "Standard_DS1_v2")
  admin_username        = "instanceadmin"
  computer_name         = "${local.resource_name_prefix}vm"
  zone                  = "3"

  os_disk {
    name                 = "${local.resource_name_prefix}osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub") # Make sure this file exists
  }
}

# Create a public IP for the load balancer
resource "azurerm_public_ip" "lb" {
  name                = "${local.resource_name_prefix}lb-pip"
  location            = azurerm_resource_group.azurance.location
  resource_group_name = azurerm_resource_group.azurance.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create the load balancer
resource "azurerm_lb" "azurance" {
  name                = "${local.resource_name_prefix}lb"
  location            = azurerm_resource_group.azurance.location
  resource_group_name = azurerm_resource_group.azurance.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

# Create backend address pool
resource "azurerm_lb_backend_address_pool" "azurance" {
  loadbalancer_id = azurerm_lb.azurance.id
  name            = "BackEndAddressPool"
}

# Associate NIC with LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "azurance" {
  network_interface_id    = azurerm_network_interface.azurance.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.azurance.id
}

# Create LB probe
resource "azurerm_lb_probe" "azurance" {
  loadbalancer_id = azurerm_lb.azurance.id
  name            = "http-probe"
  port            = 80
}

# Create LB rule
resource "azurerm_lb_rule" "azurance" {
  loadbalancer_id                = azurerm_lb.azurance.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.azurance.id]
  probe_id                       = azurerm_lb_probe.azurance.id
}

# Create a storage account for the blob storage
resource "azurerm_storage_account" "azurance" {
  name                     = "azurancestorageacct"
  resource_group_name      = azurerm_resource_group.azurance.name
  location                 = azurerm_resource_group.azurance.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a blob container
resource "azurerm_storage_container" "azurance" {
  name                  = "${local.resource_name_prefix}container"
  storage_account_id    = azurerm_storage_account.azurance.id
  container_access_type = "private"
}