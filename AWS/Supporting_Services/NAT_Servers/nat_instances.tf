################
# NAT Group 11 #
################
### The NAT Instances ###
# Notes: This deployment is part of a 2 step process.  The first process will deploy the NAT instances with their primary and public IPs in addition to allocating some Elastic IPs for each Primary instance to use.
# Notes: You will need to manually assign the secondary IP address to each instance due to TF's lack of official support of this feature - https://groups.google.com/forum/#!topic/terraform-tool/ziz5ji1CJZI
## NAT01-A ##
  resource "aws_instance" "nat01-a" {
    # 18.04 Bionic
    ami           = "${var.nat_ami}"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    subnet_id = "${var.nata_subnet}"
    private_ip = "${var.nat01a_ips}"
    associate_public_ip_address = true
    source_dest_check = false
    vpc_security_group_ids = ["${var.mgmt-allow-all}", "${var.mgmt-dmz-tier}"]
    iam_instance_profile = "NAT_Monitor"
    key_name                    = "ops_nvir_01"

    tags = "${merge(var.nat_tags, map("Name", "MGMT-Nat01-A"))}"
  }

  # Make the forward entries
    resource "aws_route53_record" "nat01-a-DNSFW" {
      zone_id         = "Z005409525PD6ALH1W7TS"
      name            = "mgmt-nat01-a"
      type            = "A"
      ttl             = "3600"
      allow_overwrite = true
      records         = "${aws_instance.nat01-a.*.private_ip}"
    }

    # Make the reverse entries
    resource "aws_route53_record" "nat01-a-DNSRV" {
      zone_id = "Z00540592B7ICSSI2KR2R"
      name    = "${element(split(".", var.nat01a_ips), 3)}"
      type    = "PTR"
      ttl     = "3600"
      records = "${aws_route53_record.nat01-a-DNSFW.*.fqdn}"
    }

## NAT02-A ##
  resource "aws_instance" "nat02-a" {
    # 18.04 Bionic
    ami           = "${var.nat_ami}"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    subnet_id = "${var.nata_subnet}"
    private_ip = "${var.nat02a_ips}"
    associate_public_ip_address = true
    source_dest_check = false
    vpc_security_group_ids = ["${var.mgmt-allow-all}", "${var.mgmt-dmz-tier}"]
    iam_instance_profile = "NAT_Monitor"
    key_name                    = "ops_nvir_01"

    tags = "${merge(var.nat_tags, map("Name", "MGMT-Nat02-A"))}"
  }

  # Make the forward entries
  resource "aws_route53_record" "nat02-a-DNSFW" {
    zone_id         = "Z005409525PD6ALH1W7TS"
    name            = "mgmt-nat02-a"
    type            = "A"
    ttl             = "3600"
    allow_overwrite = true
    records         = "${aws_instance.nat02-a.*.private_ip}"
  }

  # Make the reverse entries
  resource "aws_route53_record" "nat02-a-DNSRV" {
    zone_id = "Z00540592B7ICSSI2KR2R"
    name    = "${element(split(".", var.nat02a_ips), 3)}"
    type    = "PTR"
    ttl     = "3600"
    records = "${aws_route53_record.nat02-a-DNSFW.*.fqdn}"
  }

## NAT01-B ##
  resource "aws_instance" "nat01-b" {
    # 18.04 Bionic
    ami           = "${var.nat_ami}"
    instance_type = "t3.micro"
    availability_zone = "us-east-1b"
    subnet_id = "${var.natb_subnet}"
    private_ip = "${var.nat01b_ips}"
    associate_public_ip_address = true
    source_dest_check = false
    vpc_security_group_ids = ["${var.mgmt-allow-all}", "${var.mgmt-dmz-tier}"]
    iam_instance_profile = "NAT_Monitor"
    key_name                    = "ops_nvir_01"

    tags = "${merge(var.nat_tags, map("Name", "MGMT-Nat01-B"))}"
  }

  # Make the forward entries
    resource "aws_route53_record" "nat01-b-DNSFW" {
      zone_id         = "Z005409525PD6ALH1W7TS"
      name            = "mgmt-nat01-b"
      type            = "A"
      ttl             = "3600"
      allow_overwrite = true
      records         = "${aws_instance.nat01-b.*.private_ip}"
    }

    # Make the reverse entries
    resource "aws_route53_record" "nat01-b-DNSRV" {
      zone_id = "Z00539091DGEKV8X59HU2"
      name    = "${element(split(".", var.nat01b_ips), 3)}"
      type    = "PTR"
      ttl     = "3600"
      records = "${aws_route53_record.nat01-b-DNSFW.*.fqdn}"
    }

## NAT02-B ##
  resource "aws_instance" "nat02-b" {
    # 18.04 Bionic
    ami           = "${var.nat_ami}"
    instance_type = "t3.micro"
    availability_zone = "us-east-1b"
    subnet_id = "${var.natb_subnet}"
    private_ip = "${var.nat02b_ips}"
    associate_public_ip_address = true
    source_dest_check = false
    vpc_security_group_ids = ["${var.mgmt-allow-all}", "${var.mgmt-dmz-tier}"]
    iam_instance_profile = "NAT_Monitor"
    key_name                    = "ops_nvir_01"

    tags = "${merge(var.nat_tags, map("Name", "MGMT-Nat02-B"))}"
  }

  # Make the forward entries
    resource "aws_route53_record" "nat02-b-DNSFW" {
      zone_id         = "Z005409525PD6ALH1W7TS"
      name            = "mgmt-nat02-b"
      type            = "A"
      ttl             = "3600"
      allow_overwrite = true
      records         = "${aws_instance.nat02-b.*.private_ip}"
    }

    # Make the reverse entries
    resource "aws_route53_record" "nat02-b-DNSRV" {
      zone_id = "Z00539091DGEKV8X59HU2"
      name    = "${element(split(".", var.nat02b_ips), 3)}"
      type    = "PTR"
      ttl     = "3600"
      records = "${aws_route53_record.nat02-b-DNSFW.*.fqdn}"
    }

# Let's create some EIPs
# Since these have already been allocated as per the notes above, all you need to do is manually associate them to the instances that were launched.  Telling TF to do this will strip away the previously established public from the instance rendering it useless when the eipswing script is run from the secondary instance since it'll no longer have a public once it deems it needs to run the eipswing script to take the EIP back from the secondary.
  resource "aws_eip" "nat01-a-eip" {
    associate_with_private_ip = "${var.nat01a_ips}"

    tags = "${merge(var.nat_tags, map("Name", "MGMT-Nat01-A"))}"
  }

  resource "aws_eip" "nat01-b-eip" {
    associate_with_private_ip = "${var.nat01b_ips}"

    tags = "${merge(var.nat_tags, map("Name", "MGMT-Nat01-B"))}"
  }
