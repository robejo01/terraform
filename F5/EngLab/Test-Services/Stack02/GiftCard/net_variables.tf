# Giftcard Service Servers

variable "gc_ips" {
  type = "list"

  default = [
    "192.168.15.63",
    "192.168.15.64"
  ]
}

# VIP Variable

variable "gc_vip" {
  type = "string"

  default = "192.168.15.42"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "gc_pool_nodes" {
  type = "list"

  default = [
    "giftcardsvc01s02-test",
    "giftcardsvc02s02-test"
  ]
}

variable "gc_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
