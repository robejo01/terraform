# Appzone Service Servers

variable "az_ips" {
  type = "list"

  default = [
    "192.168.15.33",
    "192.168.15.103"
  ]
}

# VIP Variable

variable "az_vip" {
  type = "string"

  default = "192.168.15.104"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "az_pool_nodes" {
  type = "list"

  default = [
    "appzone01s02-dev",
    "appzone02s02-dev"
  ]
}

variable "az_vlans" {
  type = "list"

  default = [
    "/Common/Lab_Network"
  ]
}
