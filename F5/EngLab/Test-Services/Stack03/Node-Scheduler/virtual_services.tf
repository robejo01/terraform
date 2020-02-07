# BDScheduler Nodes
resource "bigip_ltm_node" "bschedules03-test-nodes" {
  count   = 2
  name    = "/${element(var.partitions, 1)}/${element(var.bsch_pool_nodes, count.index)}"
  address = "${element(var.bsch_ips, count.index)}"
  monitor = "/${element(var.partitions, 0)}/icmp"
}

#The Virtual Server for Scheduler
resource "bigip_ltm_virtual_server" "test-bschedules03" {
  name                       = "/${element(var.partitions, 1)}/Test-BSchedules03"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = "${var.bsch_vip}"
  port                       = 38050
  profiles                   = ["/${element(var.partitions, 0)}/http"]
  pool                       = "/${element(var.partitions, 1)}/Test-BSchedules03-Pool"
  source_address_translation = "automap"
  depends_on                 = ["bigip_ltm_pool.bsch_pool"]
  translate_address          = "enabled"
  translate_port             = "enabled"
  ip_protocol                = "tcp"
  vlans_enabled              = "true"
  vlans                      = "${var.bsch_vlans}"

}
# Scheduler Service Pool
resource "bigip_ltm_pool" "bsch_pool" {
  name                = "/${element(var.partitions, 1)}/Test-BSchedules03-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${var.icmp_mon}", "/${element(var.partitions, 1)}/Node_Check"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# Scheduler Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-scheduler_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.bsch_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.bsch_pool_nodes, count.index)}:38050"
}
# Scheduler Service Virtual Address
resource "bigip_ltm_virtual_address" "test_scheduler_va" {
  name            = "/${element(var.partitions, 1)}/${var.bsch_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(var.partitions, 0)}/traffic-group-1"
}
