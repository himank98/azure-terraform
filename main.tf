provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "vnet" {
    name     = "vnetgroup"
    location = "Central India"
}

resource "azurerm_virtual_network" "vnet01" {
    name = "vnet01"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    location = "${azurerm_resource_group.vnet.location}"
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet01" {
    name = "subnet01"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "10.0.1.0/24"
}

resource "azurerm_subnet" "subnet02" {
    name = "subnet02"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_subnet" "subnet03" {
    name = "subnet03"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "10.0.3.0/24"
}

resource "azurerm_subnet" "subnet04" {
    name = "subnet04"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "10.0.4.0/24"
}
