#############################################
#                                           #
#    TESTS02 UDX - Zen/Zevenet Farm         #
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
    path         = "tf-legacy/state/krkld/infrastructure/zevenet/test-services/stack02/test-portals02"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

variable "api_key" {
  type    = "string"
  default = "xFaaqQcAlbQOIRYpdsBgKgp6RSMKPAJU1fYjoOFXQbS4XdOgTSeGtnQ4djXiPL223"
}

variable "udx_vint_ip" {
  type    = "string"
  default = "192.168.15.88"
}

variable "udx_vint_mask" {
  type    = "string"
  default = "255.255.255.0"
}

variable "udx_vint_gw" {
  type    = "string"
  default = "192.168.15.1"
}

variable "udx_vint_name" {
  type    = "string"
  default = "eth1.1000:88"
}

variable "udx_ciphers" {
  type    = "string"
  default = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:CDHE-ECDSA-AES256-SHA384:AES128-GCM-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA:DES-CBC3-SHA"
}

variable "udx_certname" {
  type    = "string"
  default = "portals02.test.tsafe.systems.pem"
}

variable "udx_vhostname" {
  type    = "string"
  default = "portals02.test.tsafe.systems"
}

variable "udx_redirurl" {
  type    = "string"
  default = "https://portals02.test.tsafe.systems"
}

variable "udx_bkend1_ip" {
  type    = "string"
  default = "192.168.15.83"
}

variable "udx_bkend2_ip" {
  type    = "string"
  default = "192.168.15.87"
}

variable "udx_bkend_port" {
  type    = "string"
  default = "80"
}
