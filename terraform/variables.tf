variable "resource_group_name" {
  default     = "demo-rg"
  description = "Name of the Azure resource group"
}

variable "location" {
  default     = "westeurope"
  description = "Azure region"
}

variable "vm_name" {
  default     = "demo-vm"
  description = "Virtual machine name"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "my_ip_address" {
  default     = "89.64.12.157/32"
  description = "Your IP for SSH access"
}

