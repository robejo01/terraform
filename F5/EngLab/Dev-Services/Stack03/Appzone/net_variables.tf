# Appzone Service Servers

variable "az_ips" {
  type = "list"

  default = [
    "192.168.15.190",
    "192.168.15.191"
  ]
}

# VIP Variable

variable "az_vip" {
  type = "string"

  default = "192.168.15.106"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "az_pool_nodes" {
  type = "list"

  default = [
    "appzone01s03-dev",
    "appzone02s03-dev"
  ]
}

variable "az_vlans" {
  type = "list"

  default = [
    "/Common/Lab_Network"
  ]
}
