#############################################
#                                           #
#    DEVS02 Appzone - Zen/Zevenet Farm      #
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

variable "az_vint_ip" {
  type    = "string"
  default = "192.168.15.104"
}

variable "az_vint_mask" {
  type    = "string"
  default = "255.255.255.0"
}

variable "az_vint_gw" {
  type    = "string"
  default = "192.168.15.1"
}

variable "az_vint_name" {
  type    = "string"
  default = "eth1.1000:104"
}

variable "az_ciphers" {
  type    = "string"
  default = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:CDHE-ECDSA-AES256-SHA384:AES128-GCM-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA:DES-CBC3-SHA"
}

variable "az_certname" {
  type    = "string"
  default = "appzones02.dev.company.com.pem"
}

variable "az_vhostname" {
  type    = "string"
  default = "appzones02.dev.company.com"
}

variable "az_redirurl" {
  type    = "string"
  default = "https://appzones02.dev.company.com"
}

variable "az_bkend1_ip" {
  type    = "string"
  default = "192.168.15.33"
}

variable "az_bkend2_ip" {
  type    = "string"
  default = "192.168.15.103"
}

variable "az_bkend_port" {
  type    = "string"
  default = "10080"
}
