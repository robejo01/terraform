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
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/krkld/infrastructure/zevenet/dev-services/stack01/victoria-station"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

variable "api_key" {
  type    = "string"
  default = "xFaaqQcAlbQOIRYpdsBgKgp6RSMKPAJU1fYjoOFXQbS4XdOgTSeGtnQ4djXiPL223"
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
  default = "vssvcs01.dev.tsafe.systems"
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
