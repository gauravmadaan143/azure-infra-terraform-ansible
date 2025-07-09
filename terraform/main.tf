terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"           # ✅ Replace with your actual RG for state
    storage_account_name = "gmadantfstate01"      # ✅ Must exist, globally unique
    container_name       = "tfstate"              # ✅ Must exist inside the above storage account
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ✅ Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# ✅ Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# ✅ Subnet
resource "azurerm_subnet" "main" {
  name                 = "demo-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ✅ NSG with SSH rule for your IP
resource "azurerm_network_security_group" "main" {
  name                = "demo-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip_address
    destination_address_prefix = "*"
  }
}

# ✅ Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# ✅ Public IP
resource "azurerm_public_ip" "main" {
  name                = "demo-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_metho_

