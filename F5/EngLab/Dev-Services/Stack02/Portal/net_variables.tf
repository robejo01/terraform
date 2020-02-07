# Portal Service Servers

variable "udx_ips" {
  type = "list"

  default = [
    "192.168.15.22",
    "192.168.15.23"
  ]
}

# VIP Variable

variable "udx_vip" {
  type = "string"

  default = "192.168.15.55"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "udx_pool_nodes" {
  type = "list"

  default = [
    "portal01s02-dev",
    "portal02s02-dev"
  ]
}

variable "udx_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
