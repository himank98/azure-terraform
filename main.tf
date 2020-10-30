provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "vnet" {
    name     = "vnetgroup"
    location = "East Us"
}

resource "azurerm_virtual_network" "vnet01" {
    name = "vnet01"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    location = "${azurerm_resource_group.vnet.location}"
    address_space = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "web-subnet" {
    name = "web-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "192.168.1.0/24"
}

resource "azurerm_subnet" "mgt-subnet" {
    name = "mgt-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "192.168.2.0/24"
}

resource "azurerm_subnet" "db-subnet" {
    name = "db-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "192.168.3.0/24"
}

resource "azurerm_subnet" "ad-subnet" {
    name = "ad-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "192.168.4.0/24"
}

resource "azurerm_network_security_group" "web-nsg" {
    name = "web-nsg"
    location = "${azurerm_resource_group.vnet.location}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"

    security_rule {
        name = "ssh-rule"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}   


resource "azurerm_network_security_group" "db-nsg" {
    name = "db-nsg"
    location = "${azurerm_resource_group.vnet.location}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"

    security_rule {
        name = "ssh-rule"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_network_security_group" "mgt-nsg" {
    name = "mgt-nsg"
    location = "${azurerm_resource_group.vnet.location}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"

    security_rule {
        name = "ssh-rule"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_network_security_group" "ad-nsg" {
    name = "ad-nsg"
    location = "${azurerm_resource_group.vnet.location}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"

    security_rule {
        name = "ssh-rule"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_public_ip" "example" {
  name                = "bastionhostip"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  location            = "${azurerm_resource_group.vnet.location}"
  allocation_method   = "Static"
}



