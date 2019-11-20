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
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/krkld/infrastructure/zevenet/test-services/stack02/giftcard"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

variable "api_key" {
  type    = "string"
  default = "xFaaqQcAlbQOIRYpdsBgKgp6RSMKPAJU1fYjoOFXQbS4XdOgTSeGtnQ4djXiPL223"
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
  default = "giftcardsvcs02.test.tsafe.systems"
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
