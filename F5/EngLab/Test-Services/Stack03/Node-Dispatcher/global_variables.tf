provider "bigip" {
  address  = "192.168.2.36"
  username = ""
  password = ""
  #  token_auth = "true"
  #  login_ref = "tmos"
}

terraform {
  backend "consul" {
    address      = "address.of.consul.server"
    scheme       = "http"
    path         = "path/to/project"
    access_token = "YOUR-TOKEN-HERE"
  }
}

# This should contain all f5 partitions. DO NOT CHANGE UNLESS YOU KNOW WHAT YOU'RE DOING
variable "partitions" {
  type    = "list"
  default = ["Common", "EngLab", "MGMT"]
}
