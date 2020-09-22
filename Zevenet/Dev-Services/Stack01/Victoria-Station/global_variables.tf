#############################################
#                                           #
#         DEVS01 Victoria's Station         #
#             Zen/Zevenet Farm              #
#                                           #
#                                           #
#############################################
#                                           #
# Global Variables and Provider/Consul info #
#                                           #
#                                           #
#############################################
terraform {
  backend "consul" {
    address      = "address.of.consul.server"
    scheme       = "http"
    path         = "path/to/project"
    access_token = "YOUR-TOKEN-HERE"
  }
}

variable "api_key" {
  type    = "string"
  default = "API-KEY-HERE"
}

variable "vs_vint_ip" {
  type    = "string"
  default = "192.168.15.109"
}

variable "vs_vint_mask" {
  type    = "string"
  default = "255.255.255.0"
}

variable "vs_vint_gw" {
  type    = "string"
  default = "192.168.15.1"
}

variable "vs_vint_name" {
  type    = "string"
  default = "eth1.1000:109"
}

variable "vs_vhostname" {
  type    = "string"
  default = "vssvcs01.dev.company.com"
}

variable "vs_bkend1_ip" {
  type    = "string"
  default = "192.168.15.32"
}

variable "vs_bkend2_ip" {
  type    = "string"
  default = "192.168.15.102"
}

variable "vs_bkend_port" {
  type    = "string"
  default = "13010"
}
