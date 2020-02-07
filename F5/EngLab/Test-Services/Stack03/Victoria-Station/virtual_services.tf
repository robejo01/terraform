#The Virtual Server for Victoria Station
resource "bigip_ltm_virtual_server" "test-vssvcs03" {
  name                       = "/${element(var.partitions, 1)}/Test-VSsvcS03"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = "${var.vs_vip}"
  port                       = 13010
  profiles                   = ["/${element(var.partitions, 0)}/tcp"]
  client_profiles            = ["/${element(var.partitions, 1)}/TEST-AppzoneS03"]
  pool                       = "/${element(var.partitions, 1)}/Dev-VSsvcS01-Pool"
  source_address_translation = "automap"
  depends_on                 = ["bigip_ltm_pool.vs_pool"]
  translate_address          = "enabled"
  translate_port             = "enabled"
  ip_protocol                = "tcp"
  vlans_enabled              = "true"
  vlans                      = "${var.vs_vlans}"

}
# Victoria Station Service Pool
resource "bigip_ltm_pool" "vs_pool" {
  name                = "/${element(var.partitions, 1)}/Test-VSsvcS03-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${var.icmp_mon}", "/${element(var.partitions, 1)}/VS_Check"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# Victoria Station Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-vs_pool" {
  count = 2
  pool  = "${bigip_ltm_pool.vs_pool.name}"
  node  = "/${element(var.partitions, 1)}/${element(var.vs_pool_nodes, count.index)}:13010"
}
# Victoria Station Service Virtual Address
resource "bigip_ltm_virtual_address" "dev_vs_va" {
  name            = "/${element(var.partitions, 1)}/${var.vs_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(var.partitions, 0)}/traffic-group-1"
}
