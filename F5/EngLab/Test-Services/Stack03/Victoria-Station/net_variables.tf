# Victoria Station Service Servers

variable "vs_ips" {
  type = "list"

  default = [
    "192.168.15.92",
    "192.168.15.93"
  ]
}

# VIP Variable

variable "vs_vip" {
  type = "string"

  default = "192.168.15.119"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "vs_pool_nodes" {
  type = "list"

  default = [
    "appzone01s03-test",
    "appzone02s03-test"
  ]
}

variable "vs_vlans" {
  type = "list"

  default = [
    "Lab_Network"
  ]
}
