# Appzone Service Servers

variable "az_ips" {
  type = "list"

  default = [
    "192.168.15.37",
    "192.168.15.62"
  ]
}

# VIP Variable

variable "az_vip" {
  type = "string"

  default = "192.168.15.68"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "az_pool_nodes" {
  type = "list"

  default = [
    "appzone01s01-test",
    "appzone02s01-test"
  ]
}

variable "az_vlans" {
  type = "list"

  default = [
    "/Common/Lab_Network"
  ]
}
