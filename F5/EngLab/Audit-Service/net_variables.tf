# Audit Service Servers

variable "as_ips" {
  type = "list"

  default = [
    "192.168.15.63",
    "192.168.15.64"
  ]
}

# VIP Variable

variable "as_vip" {
  type = "string"

  default = "192.168.15.41"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "as_pool_nodes" {
  type = "list"

  default = [
    "giftcardsvc01s02",
    "giftcardsvc02s02"
  ]
}

variable "as_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
