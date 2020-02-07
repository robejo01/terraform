# UDX Nodes
resource "bigip_ltm_node" "portals03-dev-nodes" {
  count   = 2
  name    = "/${element(var.partitions, 1)}/${element(var.udx_pool_nodes, count.index)}"
  address = "${element(var.udx_ips, count.index)}"
  monitor = "/${element(var.partitions, 0)}/icmp"
}

#The Virtual Server for UDX
resource "bigip_ltm_virtual_server" "dev-portals03" {
  name                       = "/${element(var.partitions, 1)}/Dev-PortalS03"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = "${var.udx_vip}"
  port                       = 443
  profiles                   = ["/${element(var.partitions, 0)}/tcp"]
  client_profiles            = ["/${element(var.partitions, 1)}/DEV-PortalS03"]
  pool                       = "/${element(var.partitions, 1)}/Dev-PortalS03-Pool"
  source_address_translation = "automap"
  depends_on                 = ["bigip_ltm_pool.udx_pool"]
  translate_address          = "enabled"
  translate_port             = "enabled"
  ip_protocol                = "tcp"
  vlans_enabled              = "true"
  vlans                      = "${var.udx_vlans}"

}
# UDX Service Pool
resource "bigip_ltm_pool" "udx_pool" {
  name                = "/${element(var.partitions, 1)}/Dev-PortalS03-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${var.icmp_mon}", "/${element(var.partitions, 1)}/PHPPortal_Check"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# UDX Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-udx_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.udx_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.udx_pool_nodes, count.index)}:80"
}
# UDX Service Virtual Address
resource "bigip_ltm_virtual_address" "dev_udx_va" {
  name            = "/${element(var.partitions, 1)}/${var.udx_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(var.partitions, 0)}/traffic-group-1"
}
