#############################################
#                                           #
#    TestS02 Giftcard - Zen/Zevenet Farm    #
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

variable "gc_vint_ip" {
  type    = "string"
  default = "192.168.15.42"
}

variable "gc_vint_mask" {
  type    = "string"
  default = "255.255.255.0"
}

variable "gc_vint_gw" {
  type    = "string"
  default = "192.168.15.1"
}

variable "gc_vint_name" {
  type    = "string"
  default = "eth1.1000:42"
}

variable "gc_vhostname" {
  type    = "string"
  default = "giftcardsvcs02.test.company.com"
}

variable "gc_bkend1_ip" {
  type    = "string"
  default = "192.168.15.63"
}

variable "gc_bkend2_ip" {
  type    = "string"
  default = "192.168.15.64"
}

variable "gc_bkend_port" {
  type    = "string"
  default = "13010"
}
