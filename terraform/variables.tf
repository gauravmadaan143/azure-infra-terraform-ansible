variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
  default     = "demo-rg"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "vm_name" {
  type        = string
  description = "Virtual machine name"
  default     = "demo-vm"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key used for the Azure VM"
}

variable "my_ip_address" {
  type        = string
  description = "Your current public IP address with CIDR for SSH access"
  default     = "89.64.12.157/32"
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

