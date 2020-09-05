provider "azurerm" {
  version = "2.0"
  features {}
}

#Create virtual_network
resource "azurerm_virtual_network" "azurevnet" {
  name                = "${var.name}-vnet"
  resource_group_name = var.resource_group
  location            = var.region
  address_space       = [var.address_space]
  tags     = {
    Name   = "${var.name}-vnet"
    Projet = var.name
  }
}

#Create subnet
resource "azurerm_subnet" "azuresubnet" {
  name                 = "${var.name}-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.azurevnet.name
  address_prefix       = var.address_prefix
}

#Deploy Public IP
resource "azurerm_public_ip" "publicip" {
  name                = "${var.name}-public-ip"
  location            = var.region
  resource_group_name = var.resource_group
  allocation_method   = var.ip_allocation_method
  sku                 = var.ip_sku
  tags     = {
    Name   = "${var.name}-public-ip"
    Projet = var.name
  }
}

#Create NIC
resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"  
  location            = var.region
  resource_group_name = var.resource_group

    ip_configuration {
    name                           = "${var.name}-ipconfig1"
    subnet_id                      = azurerm_subnet.azuresubnet.id 
    private_ip_address_allocation  = var.private_ip_allocation
    public_ip_address_id           = azurerm_public_ip.publicip.id
  }
  tags     = {
    Name   = "${var.name}-nic"
    Projet = var.name
  }
}

# Connect the security group to the network_interface
resource "azurerm_network_interface_security_group_association" "nsg-nic" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

#Create Boot Diagnostic Account
resource "azurerm_storage_account" "storage" {
  name                      = "${var.name}storageaccount"
  resource_group_name       = var.resource_group
  location                  = var.region
   account_tier             = var.sa_account_tier
   account_replication_type = var.sa_account_replication_type

   tags     = {
    Name   = "${var.name}-storage-account"
    Projet = var.name
  }
  }


#Create Virtual Machine
resource "azurerm_virtual_machine" "azurevm" {
  name                  = "${var.name}-vm"
  location              = var.region
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disk_on_termination

  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_image
    sku       = var.vm_sku
    version   = var.vm_version
  }

  storage_os_disk {
    name              = "${var.name}-disk"
    disk_size_gb      = var.os_disk_size
    caching           = var.os_disk_caching
    create_option     = var.os_disk_createoption
    managed_disk_type = var.os_disk_type
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.password
  }
  
  os_profile_linux_config {
    disable_password_authentication = var.password_authentication
  }

  admin_ssh_key {
  username = var.admin_username
  public_key     = tls_private_key.example_ssh.public_key_openssh
}

boot_diagnostics {
        enabled     = var.boot_diagnostics
        storage_uri = azurerm_storage_account.storage.primary_blob_endpoint
    }
    tags     = {
    Name   = "${var.name}-vm"
    Projet = var.name
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg"
  location            = var.region
  resource_group_name = var.resource_group
}

  resource "azurerm_network_security_rule" "sr1" {
  name                        = "SSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
}

  resource "azurerm_network_security_rule" "sr2" {
  name                        = "Alltraffic"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
}
