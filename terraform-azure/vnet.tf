resource "azurerm_resource_group" "messagingapp-rg" {
  name     = "messagingapp-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "messagingapp-vnet" {
  name                = "example-network"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "messagin-app"
  }
}

resource "azurerm_subnet" "messagingapp-BE-snet" {
  name                 = "messagingapp-BE-subnet"
  resource_group_name  = azurerm_resource_group.messagingapp-rg.name
  virtual_network_name = azurerm_virtual_network.messagingapp-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "messagingapp-FE-snet" {
  name                 = "messagingapp-FE-subnet"
  resource_group_name  = azurerm_resource_group.messagingapp-rg.name
  virtual_network_name = azurerm_virtual_network.messagingapp-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "messagingapp-DB-snet" {
  name                 = "messagingapp-DB-subnet"
  resource_group_name  = azurerm_resource_group.messagingapp-rg.name
  virtual_network_name = azurerm_virtual_network.messagingapp-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "messagingapp-BE-pip" {
  name                = "messagingapp-BE-pip"
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
  location            = azurerm_resource_group.messagingapp-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "messagin-app"
  }
}

resource "azurerm_public_ip" "messagingapp-FE-pip" {
  name                = "messagingapp-FE-pip"
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
  location            = azurerm_resource_group.messagingapp-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "messagin-app"
  }
}

resource "azurerm_network_security_group" "messagingapp-BE-NSG" {
  name                = "messagingapp-BE-ssh"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
}

resource "azurerm_network_security_rule" "messagingapp-BE-ssh" {
  name                        = "messagingapp-BE-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.messagingapp-rg.name
  network_security_group_name = azurerm_network_security_group.messagingapp-BE-NSG.name
}

resource "azurerm_network_security_rule" "messagingapp-BE-http" {
  name                        = "messagingapp-BE-ssh"
  priority                    = 101
  direction                   = "Intbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.messagingapp-rg.name
  network_security_group_name = azurerm_network_security_group.messagingapp-BE-NSG.name
}



resource "azurerm_network_security_group" "messagingapp-FE-NSG" {
  name                = "messagingapp-FE-SG"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
}


resource "azurerm_network_security_rule" "messagingapp-FE-ssh" {
  name                        = "messagingapp-FE-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.messagingapp-rg.name
  network_security_group_name = azurerm_network_security_group.messagingapp-FE-NSG.name
}

resource "azurerm_network_security_rule" "messagingapp-FE-http" {
  name                        = "messagingapp-FE-http"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.messagingapp-rg.name
  network_security_group_name = azurerm_network_security_group.messagingapp-FE-NSG.name
}


resource "azurerm_network_security_group" "messagingapp-DB-NSG" {
  name                = "messagingapp-DB-NSG"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
}

resource "azurerm_network_security_rule" "messagingapp-DB-ssh" {
  name                        = "messagingapp-DB-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.messagingapp-rg.name
  network_security_group_name = azurerm_network_security_group.messagingapp-DB-NSG.name
}

resource "azurerm_network_security_rule" "messagingapp-DB-http" {
  name                        = "messagingapp-FE-http"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.messagingapp-rg.name
  network_security_group_name = azurerm_network_security_group.messagingapp-DB-NSG.name
}

resource "azurerm_network_interface" "messagingapp-BE-nic" {
  name                = "messagingapp-BE-nic"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.messagingapp-BE-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.messagingapp-BE-pip.id
  }
}

resource "azurerm_network_interface_application_security_group_association" "messagingapp-BE-nic-nsg" {
  network_interface_id          = azurerm_network_interface.messagingapp-BE-nic.id
  application_security_group_id = azurerm_application_security_group.messagingapp-BE-NSG.id
}

resource "azurerm_network_interface" "messagingapp-FE-nic" {
  name                = "messagingapp-FE-nic"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.messagingapp-FE-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.messagingapp-FE-pip.id
  }
}

resource "azurerm_network_interface_application_security_group_association" "messagingapp-FE-nic-nsg" {
  network_interface_id          = azurerm_network_interface.messagingapp-FE-nic.id
  application_security_group_id = azurerm_application_security_group.messagingapp-FE-NSG.id
}

resource "azurerm_network_interface" "messagingapp-DB-nic" {
  name                = "messagingapp-DB-nic"
  location            = azurerm_resource_group.messagingapp-rg.location
  resource_group_name = azurerm_resource_group.messagingapp-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.messagingapp-DB-snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_security_group_association" "messagingapp-DB-nic-nsg" {
  network_interface_id          = azurerm_network_interface.messagingapp-DB-nic.id
  application_security_group_id = azurerm_application_security_group.messagingapp-DB-NSG.id
}

resource "azurerm_linux_virtual_machine" "messagingapp-vm" {
  name                = "messagingapp-vm"
  resource_group_name = azurerm_resource_group.messagingapp-rg.name
  location            = azurerm_resource_group.messagingapp-rg.location
  size                = "Standard_F2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.messagingapp-FE-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}