#The Virtual Server for the Audit Service
 resource "bigip_ltm_virtual_server" "Auditsvcvs01" {
   name = "/${element(var.partitions, 1)}/Audit-Service_VS"
   source = "0.0.0.0/0"
   mask = "255.255.255.255"
   destination = "${var.as_vip}"
   port = 13000
   #client_profiles = ["/${element(var.partitions, 0)}/tcp"]
   #server_profiles = ["/${element(var.partitions, 0)}/tcp"]
   pool = "/${element(var.partitions, 1)}/Audit-Service-Pool"
   source_address_translation = "automap"
   depends_on = ["bigip_ltm_pool.as_pool"]
   translate_address = "enabled"
   translate_port = "enabled"
   ip_protocol = "tcp"
   vlans_enabled = "true"
   vlans = "${var.as_vlans}"

 }
# Audit Service Pool
 resource "bigip_ltm_pool" "as_pool" {
   name = "/${element(var.partitions, 1)}/Audit-Service-Pool"
   load_balancing_mode = "least-connections-member"
   monitors = ["${var.icmp_mon}"]
   allow_snat = "yes"
   allow_nat = "yes"
 }
# Audit Service Attachment
resource "bigip_ltm_pool_attachment" "node-as_pool" {
  count = 2
  pool = "${bigip_ltm_pool.as_pool.name}"
  node = "/${element(var.partitions, 1)}/${element(var.as_pool_nodes, count.index)}:13000"
}
# Audit Service Virtual Address
resource "bigip_ltm_virtual_address" "as_va" {
    name = "/${element(var.partitions, 1)}/${var.as_vip}"
    advertize_route = false
    enabled = true
    arp = true
    auto_delete = false
    icmp_echo = true
    traffic_group = "/${element(var.partitions, 0)}/traffic-group-2"
}
