terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}

  use_cli         = false
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# ===============================
# 1. Resource Group
# ===============================
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# ===============================
# 2. Virtual Network
# ===============================
resource "azurerm_virtual_network" "main" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# ===============================
# 3. Subnet
# ===============================
resource "azurerm_subnet" "main" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ===============================
# 4. Network Security Group (NSG)
# ===============================
resource "azurerm_network_security_group" "main" {
  name                = "demo-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# Allow SSH from DevOps agents (temporarily set to allow all for testing)
resource "azurerm_network_security_rule" "allow_ssh_from_any" {
  name                        = "Allow-SSH-From-Any"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*" # 🔁 Change back later to AzureCloud or YOUR IP
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# ===============================
# 5. Public IP for the VM
# ===============================
resource "azurerm_public_ip" "main" {
  name                = "demo-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ===============================
# 6. Network Interface Card (NIC)
# ===============================
resource "azurerm_network_interface" "main" {
  name                = "demo-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# ===============================
# 7. Linux VM (RHEL)
# ===============================
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.main.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_8"
    version   = "latest"
  }
}

