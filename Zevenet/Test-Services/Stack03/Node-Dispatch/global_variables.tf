#############################################
#                                           #
#   TestS03 BDispatch - Zen/Zevenet Farm    #
#                                           #
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

variable "bd_vint_ip" {
  type    = "string"
  default = "192.168.15.105"
}

variable "bd_vint_name" {
  type    = "string"
  default = "eth1.1000:105"
}

variable "bd_vhostname" {
  type    = "string"
  default = "bdispatchs03.test.company.com"
}

variable "bd_bkend1_ip" {
  type    = "string"
  default = "192.168.15.111"
}

variable "bd_bkend2_ip" {
  type    = "string"
  default = "192.168.15.112"
}

variable "bd_bkend_port" {
  type    = "string"
  default = "38040"
}
