# Dispatcher Service Servers

variable "bsch_ips" {
  type = "list"

  default = [
    "192.168.15.59",
    "192.168.15.61"
  ]
}

# VIP Variable

variable "bsch_vip" {
  type = "string"

  default = "192.168.15.39"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "bsch_pool_nodes" {
  type = "list"

  default = [
    "bschedule01-test",
    "bschedule02-test"
  ]
}

variable "bsch_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
