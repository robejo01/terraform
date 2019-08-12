################################
##### US-East-1 AWS11 MGMT #####
###### Apt Cache Servers #######
################################

variable "num_ac_instances" {
  default = 2
}
resource "aws_instance" "mgmt-apt-cache01" {
  # 18.04 Bionic
  count         = "${var.num_ac_instances}"
  ami           = "${var.ac_ami}"
  instance_type = "t3.micro"

  availability_zone           = "${element(var.azs, count.index)}"
  subnet_id                   = "${element(var.ac_subnets, count.index)}"
  private_ip                  = "${element(var.ac_ips, count.index)}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${var.mgmt-app-tier}", "${aws_security_group.mgmt-app-stack01.id}" ]
  key_name                    = "ops_nvir_01"

  tags = "${merge(var.ac_tags, map("Name", "Apt-Cache01-${lookup(var.pretty_az_ids, element(var.azs, count.index), "Unknown ID")}"))}"
}

# Make the forward entries
  resource "aws_route53_record" "ac01-DNSFW" {
    count           = "${var.num_ac_instances}"
    zone_id         = "Z08446893JYLU96W0JOO8"
    name            = "aptcache01-${lookup(var.pretty_az_ids, element(var.azs, count.index), "Unknown ID")}"
    type            = "A"
    ttl             = "3600"
    allow_overwrite = true
    records         = ["${element(aws_instance.mgmt-apt-cache01.*.private_ip, count.index)}"]
  }

  # Make the reverse entries
  resource "aws_route53_record" "ac01-DNSRV" {
    count   = "${var.num_ac_instances}"
    zone_id = "${element(var.ac_reverse_zones, count.index)}"
    name    = "${element(split(".", element(aws_instance.mgmt-apt-cache01.*.private_ip, count.index)), 3)}"
    type    = "PTR"
    ttl     = "3600"
    records = ["${element(aws_route53_record.ac01-DNSFW.*.fqdn, count.index)}"]
  }
