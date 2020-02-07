locals {

  gc_ips        = ["192.168.15.134", "192.168.15.135"]
  gc_pool_nodes = ["giftcardsvc01s01-test", "giftcardsvc02s01-test"]
  gc_vip        = "192.168.15.136"
  gc_vlan       = "Lab_Network"

  icmp_mon = "/Common/gateway_icmp"

}
