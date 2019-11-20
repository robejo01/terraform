#The Virtual Server for the Giftcard Service
 resource "bigip_ltm_virtual_server" "intexch-mailvs01" {
   name = "/${element(var.partitions, 1)}/GiftCard_VS"
   source = "0.0.0.0/0"
   mask = "255.255.255.255"
   destination = "${var.gc_vip}"
   port = 13010
   #client_profiles = ["/${element(var.partitions, 0)}/tcp"]
   #server_profiles = ["/${element(var.partitions, 0)}/tcp"]
   pool = "/${element(var.partitions, 1)}/GiftCard-Pool"
   source_address_translation = "automap"
   depends_on = ["bigip_ltm_pool.gc_pool"]
   translate_address = "enabled"
   translate_port = "enabled"
   ip_protocol = "tcp"
   vlans_enabled = "true"
   vlans = "${var.gc_vlans}"

 }
# Giftcard Service Pool
 resource "bigip_ltm_pool" "gc_pool" {
   name = "/${element(var.partitions, 1)}/GiftCard-Pool"
   load_balancing_mode = "least-connections-member"
   monitors = ["${var.icmp_mon}"]
   allow_snat = "yes"
   allow_nat = "yes"
 }
# Giftcard Service Pool Attachment
resource "bigip_ltm_pool_attachment" "node-gc_pool" {
  count = 2
  pool = "${bigip_ltm_pool.gc_pool.name}"
  node = "/${element(var.partitions, 1)}/${element(var.gc_pool_nodes, count.index)}:13010"
}
# Giftcard Service Virtual Address
resource "bigip_ltm_virtual_address" "exch_va" {
    name = "/${element(var.partitions, 1)}/${var.gc_vip}"
    advertize_route = false
    enabled = true
    arp = true
    auto_delete = false
    icmp_echo = true
    traffic_group = "/${element(var.partitions, 0)}/traffic-group-2"
}
