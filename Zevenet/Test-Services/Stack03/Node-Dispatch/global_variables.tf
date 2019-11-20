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
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/krkld/infrastructure/zevenet/test-services/stack03/bdispatch"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

variable "api_key" {
  type    = "string"
  default = "xFaaqQcAlbQOIRYpdsBgKgp6RSMKPAJU1fYjoOFXQbS4XdOgTSeGtnQ4djXiPL223"
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
  default = "bdispatchs03.test.tsafe.systems"
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
