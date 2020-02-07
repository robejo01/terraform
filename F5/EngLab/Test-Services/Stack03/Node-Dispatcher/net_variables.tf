# Dispatcher Service Servers

variable "bdisp_ips" {
  type = "list"

  default = [
    "192.168.15.111",
    "192.168.15.112"
  ]
}

# VIP Variable

variable "bdisp_vip" {
  type = "string"

  default = "192.168.15.105"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "bdisp_pool_nodes" {
  type = "list"

  default = [
    "bdispatch01s03-test",
    "bdispatch02s03-test"
  ]
}

variable "bdisp_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
