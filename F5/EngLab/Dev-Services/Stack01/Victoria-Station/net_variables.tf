# Victoria Station Service Servers

variable "vs_ips" {
  type = "list"

  default = [
    "192.168.15.32",
    "192.168.15.102"
  ]
}

# VIP Variable

variable "vs_vip" {
  type = "string"

  default = "192.168.15.109"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "vs_pool_nodes" {
  type = "list"

  default = [
    "appzone01s01-dev",
    "appzone02s01-dev"
  ]
}

variable "vs_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
