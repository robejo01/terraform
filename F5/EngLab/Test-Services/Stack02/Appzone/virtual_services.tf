# Appzone Nodes
resource "bigip_ltm_node" "appzone-test-nodes" {
  count   = 2
  name    = "/${element(var.partitions, 1)}/${element(var.az_pool_nodes, count.index)}"
  address = "${element(var.az_ips, count.index)}"
  monitor = "/${element(var.partitions, 0)}/icmp"
}

# Victoria Station Nodes
resource "bigip_ltm_node" "appzoneVS-test-nodes" {
  count   = 2
  name    = "/${element(var.partitions, 1)}/${element(var.vs_pool_nodes, count.index)}"
  address = "${element(var.vs_ips, count.index)}"
  monitor = "/${element(var.partitions, 0)}/icmp"
}

#The Virtual Server for Appzone
resource "bigip_ltm_virtual_server" "test-appzones02" {
  name                       = "/${element(var.partitions, 1)}/Test-AppzoneS02"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = "${var.az_vip}"
  port                       = 0
  profiles                   = ["/${element(var.partitions, 0)}/http"]
  client_profiles            = ["/${element(var.partitions, 1)}/TEST-AppzoneS02"]
  pool                       = "/${element(var.partitions, 1)}/Test-AppzoneS02-Pool"
  source_address_translation = "automap"
  depends_on                 = ["bigip_ltm_pool.az_pool"]
  translate_address          = "enabled"
  translate_port             = "enabled"
  ip_protocol                = "tcp"
  vlans_enabled              = "true"
  vlans                      = "${var.az_vlans}"
  irules                     = ["/${element(var.partitions, 1)}/Appzone443_and_10443"]

}
# Appzone Service Pool
resource "bigip_ltm_pool" "az_pool" {
  name                = "/${element(var.partitions, 1)}/Test-AppzoneS02-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${var.icmp_mon}", "/${element(var.partitions, 1)}/Appzone_Check", "/${element(var.partitions, 1)}/VS_Check"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# Appzone Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-az_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.az_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.az_pool_nodes, count.index)}:10080"
}
# Victoria Station Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-az-vs_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.az_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.vs_pool_nodes, count.index)}:13010"
}
# Appzone Service Virtual Address
resource "bigip_ltm_virtual_address" "test_az_va" {
  name            = "/${element(var.partitions, 1)}/${var.az_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(var.partitions, 0)}/traffic-group-1"
}
