# BDispatcher Nodes
resource "bigip_ltm_node" "bdispatchs03-test-nodes" {
  count   = 2
  name    = "/${element(var.partitions, 1)}/${element(var.bdisp_pool_nodes, count.index)}"
  address = "${element(var.bdisp_ips, count.index)}"
  monitor = "/${element(var.partitions, 0)}/icmp"
}

#The Virtual Server for Dispatcher
resource "bigip_ltm_virtual_server" "test-bdispatchs03" {
  name                       = "/${element(var.partitions, 1)}/Test-BDispatchs03"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = "${var.bdisp_vip}"
  port                       = 38040
  profiles                   = ["/${element(var.partitions, 0)}/http"]
  pool                       = "/${element(var.partitions, 1)}/Test-BDispatchs03-Pool"
  source_address_translation = "automap"
  depends_on                 = ["bigip_ltm_pool.bdisp_pool"]
  translate_address          = "enabled"
  translate_port             = "enabled"
  ip_protocol                = "tcp"
  vlans_enabled              = "true"
  vlans                      = "${var.bdisp_vlans}"

}
# Dispatcher Service Pool
resource "bigip_ltm_pool" "bdisp_pool" {
  name                = "/${element(var.partitions, 1)}/Test-BDispatchs03-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${var.icmp_mon}", "/${element(var.partitions, 1)}/Node_Check"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# Dispatcher Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-Dispatcher_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.bdisp_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.bdisp_pool_nodes, count.index)}:38040"
}
# Appzone Service Virtual Address
resource "bigip_ltm_virtual_address" "test_Dispatcher_va" {
  name            = "/${element(var.partitions, 1)}/${var.bdisp_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(var.partitions, 0)}/traffic-group-2"
}
