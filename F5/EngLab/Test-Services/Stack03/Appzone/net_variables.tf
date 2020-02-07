# Appzone Service Servers

variable "az_ips" {
  type = "list"

  default = [
    "192.168.15.92",
    "192.168.15.93"
  ]
}

# VIP Variable

variable "az_vip" {
  type = "string"

  default = "192.168.15.94"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "az_pool_nodes" {
  type = "list"

  default = [
    "appzone01s03-test",
    "appzone02s03-test"
  ]
}

variable "az_vlans" {
  type = "list"

  default = [
    "/Common/Lab_Network"
  ]
}
