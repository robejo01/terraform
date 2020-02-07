# Dispatcher Service Servers

variable "bdisp_ips" {
  type = "list"

  default = [
    "192.168.15.58",
    "192.168.15.60"
  ]
}

# VIP Variable

variable "bdisp_vip" {
  type = "string"

  default = "192.168.15.29"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "bdisp_pool_nodes" {
  type = "list"

  default = [
    "bdispatch01-test",
    "bdispatch02-test"
  ]
}

variable "bdisp_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
