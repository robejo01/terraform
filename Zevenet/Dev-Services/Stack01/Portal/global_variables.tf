#############################################
#                                           #
#    DEVS01 UDXS01 - Zen/Zevenet Farm      #
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

variable "udx_vint_ip" {
  type    = "string"
  default = "192.168.15.27"
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
  default = "eth1.1000:27"
}

variable "udx_ciphers" {
  type    = "string"
  default = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:CDHE-ECDSA-AES256-SHA384:AES128-GCM-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA:DES-CBC3-SHA"
}

variable "udx_certname" {
  type    = "string"
  default = "portals01.dev.company.com.pem"
}

variable "udx_vhostname" {
  type    = "string"
  default = "portals01.dev.company.com"
}

variable "udx_redirurl" {
  type    = "string"
  default = "https://portals01.dev.company.com"
}

variable "udx_bkend1_ip" {
  type    = "string"
  default = "192.168.15.50"
}

variable "udx_bkend2_ip" {
  type    = "string"
  default = "192.168.15.54"
}

variable "udx_bkend_port" {
  type    = "string"
  default = "80"
}
