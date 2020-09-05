variable "region" {
  description = "Enter the location for your resource"
}

variable "resource_group" {
  description = "Enter the location for your resource"
}

variable "name" {
  description = "Enter name for your resource"
}

variable "address_space" {
  description = "Enter address_space for your virtual_network"
}

variable "address_prefix" {
  description = "Enter address_prefix for your subnet"
}

variable "ip_allocation_method" {
  description = "which allocation method you need for your IP"
}

variable "ip_sku" {
  default = "Basic"
}

variable "private_ip_allocation" {
  default = "Dynamic"
}

variable "sa_account_tier" {
  default = "Standard"
}
variable "sa_account_replication_type"{
  default = "LRS"
}
variable "vm_size"{
  description = "Choose your virtual machine type"
}
variable "delete_os_disk_on_termination"{
  default = true
}
variable "delete_data_disk_on_termination"{
  default = true
}
variable "vm_publisher" {
  default = "Canonical"
}
variable "vm_image" {
  description = "Choose your virtual machine image"
}
variable "vm_sku" {
  default = "Choose your virtual machine sku"
}
variable "vm_version" {
  default = "latest"
}
variable "os_disk_size" {
  description = "Choose the size of your OS disk"
}
variable "os_disk_caching" {
  default = "ReadWrite"
}
variable "os_disk_createoption" {
  default = "FromImage"
}
variable "os_disk_type" {
  description = "Choose the OS disk type"
}
variable "computer_name" {
  description = "Enter a name for your vm"
}
variable "admin_username" {
  description = "Enter a username for your vm"
}
variable "password" {
  description = "Enter password for the user"
}
variable "password_authentication" {
  default = false
}
variable "boot_diagnostics" {
  default = true
}
