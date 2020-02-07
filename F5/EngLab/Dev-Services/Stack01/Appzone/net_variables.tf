# Appzone Service Servers

variable "az_ips" {
  type = "list"

  default = [
    "192.168.15.32",
    "192.168.15.102",
  ]
}

variable "vs_ips" {
  type = "list"

  default = [
    "192.168.15.120",
    "192.168.15.121"
  ]
}

# VIP Variable

variable "az_vip" {
  type = "string"

  default = "192.168.15.101"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "az_pool_nodes" {
  type = "list"

  default = [
    "appzone01s01-dev",
    "appzone02s01-dev",
    ]
}

variable "vs_pool_nodes" {
  type = "list"

  default = [
    "vss01s01-dev",
    "vss02s01-dev"
  ]
}

variable "az_vlans" {
  type = "list"

  default = [
    "/Common/Lab_Network"
  ]
}
