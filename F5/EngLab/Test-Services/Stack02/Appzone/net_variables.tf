# Appzone Service Servers

variable "az_ips" {
  type = "list"

  default = [
    "192.168.15.79",
    "192.168.15.80"
  ]
}

# Victoria Station Servers
variable "vs_ips" {
  type = "list"

  default = [
    "192.168.15.79",
    "192.168.15.80"
  ]
}

# VIP Variable

variable "az_vip" {
  type = "string"

  default = "192.168.15.86"
}

# Monitor Variables

variable "icmp_mon" {
  type = "string"

  default = "/Common/gateway_icmp"
}

variable "az_pool_nodes" {
  type = "list"

  default = [
    "appzone01s02-test",
    "appzone02s02-test"
  ]
}

variable "vs_pool_nodes" {
  type = "list"

  default = [
    "appzone01s02-test",
    "appzone02s02-test"
  ]
}

variable "az_vlans" {
  type = "list"

  default = [
    "/Common/Lab_Network"
  ]
}
