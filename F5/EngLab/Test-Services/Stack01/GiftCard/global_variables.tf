provider "bigip" {
  address  = "192.168.2.36"
  username = ""
  password = ""
  #  token_auth = "true"
  #  login_ref = "tmos"
}

terraform {
  backend "consul" {
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/krkld/infrastructure/f5/test-services/stack01/giftcard"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

locals {
  # This should contain all f5 partitions. DO NOT CHANGE UNLESS YOU KNOW WHAT YOU'RE DOING
  partitions = ["Common", "EngLab", "MGMT"]
}
