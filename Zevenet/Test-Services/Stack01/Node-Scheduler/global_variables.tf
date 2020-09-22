#############################################
#                                           #
#   TestS01 Scheduler - Zen/Zevenet Farm    #
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
    path         = "path/to/project
    access_token = "YOUR-TOKEN-HERE"
  }
}

variable "api_key" {
  type    = "string"
  default = "API-KEY-HERE"
}

variable "bs_vint_ip" {
  type    = "string"
  default = "192.168.15.39"
}

variable "bs_vint_name" {
  type    = "string"
  default = "eth1.1000:39"
}

variable "bs_vhostname" {
  type    = "string"
  default = "bschedules01.test.company.com"
}

variable "bs_bkend1_ip" {
  type    = "string"
  default = "192.168.15.59"
}

variable "bs_bkend2_ip" {
  type    = "string"
  default = "192.168.15.61"
}

variable "bs_bkend_port" {
  type    = "string"
  default = "38050"
}
