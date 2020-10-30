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