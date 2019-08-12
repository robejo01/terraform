################################################
## # # # # US-East-1 AWS11 MGMT # # # # # # # ##
# Apt-Cacher Instance-Related Security Groups ##
################################################

resource "aws_security_group" "mgmt-app-stack01" {
  name        = "MGMT App Stack01"
  description = "Application layer security group"
  vpc_id      = "${var.mgmt_vpc}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["10.20.11.11/32"]
    description = "Allow all traffic from icinga01-a in Prod1 (TF managed desc.)"
  }

  ingress {
    # Apt Cache rules
    from_port = 3142
    to_port = 3142
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.110.0.0/16", "10.220.0.0/16", "10.155.0.0/16"]
    description = "Allow TCP 3142 traffic from this subnet (TF managed desc.)"
  }

  ingress {
    #UDP 123 rules
    from_port = 123
    to_port = 123
    protocol = "udp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.110.0.0/16", "10.220.0.0/16", "10.155.0.0/16"]
    description = "Allow NTP traffic from this subnet (TF managed desc.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name","MGMT App Stack01"))}"

    # Don't destroy this SG before creating a new one.
    lifecycle {
      create_before_destroy = true
    }
}
