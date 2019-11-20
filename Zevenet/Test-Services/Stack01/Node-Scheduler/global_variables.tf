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
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/krkld/infrastructure/zevenet/test-services/stack01/scheduler"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

variable "api_key" {
  type    = "string"
  default = "xFaaqQcAlbQOIRYpdsBgKgp6RSMKPAJU1fYjoOFXQbS4XdOgTSeGtnQ4djXiPL223"
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
  default = "bschedules01.test.tsafe.systems"
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
