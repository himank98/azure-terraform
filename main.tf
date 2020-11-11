provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "vnet" {
    name     = "vnetgroup"
    location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet01" {
    name = "vnet01"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    location = "${azurerm_resource_group.vnet.location}"
    address_space = ["${var.vnetcidr}"]
}

resource "azurerm_subnet" "web-subnet" {
    name = "web-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "${var.websubnetcidr}"
}

resource "azurerm_subnet" "mgt-subnet" {
    name = "mgt-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "${var.mgtsubnetcidr}"
}

resource "azurerm_subnet" "db-subnet" {
    name = "db-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "${var.dbsubnetcidr}"
}

resource "azurerm_subnet" "ad-subnet" {
    name = "ad-subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    address_prefix = "${var.adsubnetcidr}"
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

resource "azurerm_subnet_network_security_group_association" "web-nsg-subnet" {
  subnet_id = "${azurerm_subnet.web-subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.web-nsg.id}"
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
        destination_port_range = "3306"
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

resource "azurerm_network_interface" "net-interface" {
    name = "dev-network"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    location = "${azurerm_resource_group.vnet.location}"

    ip_configuration{
        name = "dev-webserver"
        subnet_id = "${azurerm_subnet.web-subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "dev-web" {
  name = "dev-web"
  location = "${azurerm_resource_group.vnet.location}"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  network_interface_ids = [ "${azurerm_network_interface.net-interface.id}" ]
  vm_size = "Standard_D2s_v3"
  delete_os_disk_on_termination = true
  
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }

  storage_os_disk {
    name = "dev-webdisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "${var.host_name}"
    admin_username = "${var.username}"
    admin_password = "${var.os_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    "environment" = "dev"
  }
}

resource "azurerm_sql_server" "primary" {
    name = "${var.primary_database}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    location = "${azurerm_resource_group.vnet.location}"
    version = "${var.primary_database_version}"
    administrator_login = "${var.primary_database_admin}"
    administrator_login_password = "${var.primary_password}"
}

resource "azurerm_sql_server" "secondary" {
    name = "${var.secondary_database}"
    resource_group_name = "${azurerm_resource_group.vnet.name}"
    location = "West Us"
    version = "${var.secondary_database_version}"
    administrator_login = "${var.secondary_database_admin}"
    administrator_login_password = "${var.secondary_password}"
}

resource "azurerm_sql_database" "db1" {
  name                = "db1"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  location            = "${azurerm_resource_group.vnet.location}"
  server_name         = "${azurerm_sql_server.primary.name}"
}
resource "azurerm_sql_failover_group" "failoverpolicy" {
  name                = "sql-database-failover123"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  server_name         = "${azurerm_sql_server.primary.name}"
  databases           = [azurerm_sql_database.db1.id]
  partner_servers {
    id = azurerm_sql_server.secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}


