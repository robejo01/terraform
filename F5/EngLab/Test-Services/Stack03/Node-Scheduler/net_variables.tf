# Dispatcher Service Servers

variable "bsch_ips" {
  type = "list"

  default = [
    "192.168.15.110",
    "192.168.15.113"
  ]
}

# VIP Variable

variable "bsch_vip" {
  type = "string"

  default = "192.168.15.108"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "bsch_pool_nodes" {
  type = "list"

  default = [
    "bschedule01s03-test",
    "bschedule02s03-test"
  ]
}

variable "bsch_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
