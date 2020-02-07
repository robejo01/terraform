# Giftcard Nodes
resource "bigip_ltm_node" "giftcardsvcs01-test-nodes" {
  count   = 2
  name    = "/${element(local.partitions, 1)}/${element(local.gc_pool_nodes, count.index)}"
  address = element(local.gc_ips, count.index)
  monitor = "/${element(local.partitions, 0)}/icmp"
}

#The Virtual Server for Giftcard
resource "bigip_ltm_virtual_server" "test-giftcardsvcs01" {
  name                       = "/${element(local.partitions, 1)}/Test-Giftcardscvs01"
  source                     = "0.0.0.0/0"
  mask                       = "255.255.255.255"
  destination                = local.gc_vip
  port                       = 13010
  profiles                   = ["/${element(local.partitions, 0)}/http"]
  pool                       = "/${element(local.partitions, 1)}/Test-Giftcardscvs01-Pool"
  source_address_translation = "automap"
  depends_on                 = [bigip_ltm_pool.gc_pool]
  translate_address          = "enabled"
  translate_port             = "enabled"
  ip_protocol                = "tcp"
  vlans_enabled              = "true"
  vlans                      = [local.gc_vlan]

}
# Giftcard Service Pool
resource "bigip_ltm_pool" "gc_pool" {
  name                = "/${element(local.partitions, 1)}/Test-Giftcardscvs01-Pool"
  load_balancing_mode = "least-connections-member"
  monitors            = ["${local.icmp_mon}", "/${element(local.partitions, 1)}/GiftCard-Service-Mon"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
# Giftcard Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-gc_pool" {
  count = 2
  pool  = bigip_ltm_pool.gc_pool.name
  node  = "/${element(local.partitions, 1)}/${element(local.gc_pool_nodes, count.index)}:13010"
}
# Giftcard Service Virtual Address
resource "bigip_ltm_virtual_address" "test_gc_va" {
  name            = "/${element(local.partitions, 1)}/${local.gc_vip}"
  advertize_route = false
  enabled         = true
  arp             = true
  auto_delete     = false
  icmp_echo       = true
  traffic_group   = "/${element(local.partitions, 0)}/traffic-group-1"
}
