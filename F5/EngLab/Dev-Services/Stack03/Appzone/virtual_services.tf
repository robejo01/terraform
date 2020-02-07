# Appzone Nodes
resource "bigip_ltm_node" "appzone-dev-nodes" {
  count   = 2
  name    = "/${element(var.partitions, 1)}/${element(var.az_pool_nodes, count.index)}"
  address = "${element(var.az_ips, count.index)}"
  monitor = "/${element(var.partitions, 0)}/icmp"
}

#The Virtual Server for Appzone
resource "bigip_ltm_virtual_server" "dev-appzones03" {
  name                       = "/${element(var.partitions, 1)}/Dev-AppzoneS03"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = "${var.az_vip}"
  port                       = 0
  profiles                   = ["/${element(var.partitions, 0)}/tcp"]
  client_profiles            = ["/${element(var.partitions, 1)}/DEV-AppzoneS03"]
  pool                       = "/${element(var.partitions, 1)}/Dev-AppzoneS03-Pool"
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
  name                = "/${element(var.partitions, 1)}/Dev-AppzoneS03-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${var.icmp_mon}", "/${element(var.partitions, 1)}/Appzone_Check"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# Appzone Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-az_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.az_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.az_pool_nodes, count.index)}:10080"
}
# Appzone Service Virtual Address
resource "bigip_ltm_virtual_address" "dev_az_va" {
  name            = "/${element(var.partitions, 1)}/${var.az_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(var.partitions, 0)}/traffic-group-1"
}
