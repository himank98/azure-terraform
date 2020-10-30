variable "location" {
    type = string
    default = "East US"
}
variable "vnetcidr" {
    type = string
    default = "192.168.0.0/16"
}
variable "websubnetcidr" {
    type = string
    default = "192.168.1.0/24"
}

variable "mgtsubnetcidr" {
    type = string
    default = "192.168.2.0/24"
}

variable "dbsubnetcidr" {
    type = string
    default = "192.168.3.0/24"
}

variable "adsubnetcidr" {
    type = string
    default = "192.168.4.0/24"
}

variable "primarydatabase" {
    type = string
    default = "sql-primary"
}

variable "secondarydatabase" {
    type = string
    default = "sql-secondary"
}

variable "primary_database_admin" {
    type = string
    default = "sqladmin"
}

variable "secondary_database_admin" {
    type = string
    default = "sqladmin"
}

variable "primary_password" {
    type = string
    default = "pa$$w0rd"
}

variable "secondary_password" {
    type = string
    default = "pa$$w0rd"
}

variable "primary_database_version" {
    type = string
    default = "12.0"
}

variable "secondary_database_version" {
    type = string
    default = "12.0"
}