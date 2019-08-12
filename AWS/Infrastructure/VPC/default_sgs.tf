###################################
# # # US-East-1 AWS10 STG # # # ###
# # # Default Secutiry Groups # # #
###################################
########### Allow All #############
###################################

resource "aws_security_group" "stg-allow-all" {
  name                     = "STG Allow All"
  description              = "Allow all rule"
  vpc_id                   = "${aws_vpc.AWS10.id}"

  ingress {
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["0.0.0.0/0"]
  }

  egress {
    from_port              = 0
    to_port                = 0
    protocol               = "-1"
    cidr_blocks            = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name","STG Allow All"))}"
}

###################################
############# App Tier ############
###################################

resource "aws_security_group" "stg-app-tier" {
  name        = "STG App Tier"
  description = "Application layer security group"
  vpc_id      = "${aws_vpc.AWS10.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.1.4/32", "192.168.0.0/23", "10.20.1.6/32", "10.20.2.4/32", "50.201.105.32/28", "10.20.11.11/32", "10.20.12.38/32"]
    description = "Allow all inbound traffic from this subnet (TF managed desc.)"
  }

  ingress {
    # SSH rules
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.12.38/32", "10.20.1.4/32", "10.20.1.6/32", "10.20.2.4/32"]
    description = "Allow SSH from this device (TF managed desc.)"
  }

  ingress {
    #ICMP rules
    from_port = 0
    to_port = -1
    protocol = "icmp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.155.0.0/16", "10.20.1.4/32"]
    description = "Allow echo reply traffic (TF managed desc.)"
  }

  ingress {
    #ICMP rules
    from_port = 8
    to_port = -1
    protocol = "icmp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.155.0.0/16", "10.20.1.4/32"]
    description = "Allow echo request traffic (TF managed desc.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name","STG App Tier"))}"

    # Don't destroy this SG before creating a new one.
    lifecycle {
      create_before_destroy = true
    }
}

########################################
############# Data Tier ################
########################################

resource "aws_security_group" "stg-data-tier" {
  name        = "STG Data Tier"
  description = "Data layer security group"
  vpc_id      = "${aws_vpc.AWS10.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    self = true
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.1.4/32", "10.20.1.6/32", "10.20.2.4/32", "10.20.11.11/32"]
    description = "Allow all inbound traffic from this address (TF managed desc.)"
  }

  ingress {
    # SSH rules
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.12.38/32"]
    description = "Allow ssh from Alienvault (TF managed desc.)"
  }

  ingress {
    #ICMP rules
    from_port = 0
    to_port = -1
    self = true
    protocol = "icmp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    description = "Allow echo reply traffic (TF managed desc.)"
  }

  ingress {
    #ICMP rules
    from_port = 8
    to_port = -1
    self = true
    protocol = "icmp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    description = "Allow echo request traffic (TF managed desc.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name","STG Data Tier"))}"

    # Don't destroy this SG before creating a new one.
    lifecycle {
      create_before_destroy = true
    }
}

########################################
############# DMZ Tier #################
########################################

resource "aws_security_group" "stg-dmz-tier" {
  name        = "STG DMZ Tier"
  description = "DMZ layer security group"
  vpc_id      = "${aws_vpc.AWS10.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["172.20.128.0/24", "172.20.129.0/24", "10.20.1.4/32", "192.168.0.0/23", "192.168.14.0/24", "10.20.1.6/32", "10.20.2.4/32", "172.22.128.0/24", "172.22.129.0/24", "50.201.105.32/28", "10.20.11.11/32"]
    description = "Allow all inbound traffic from this subnet (TF managed desc.)"
  }

  ingress {
    # SSH rules
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.12.38/32"]
    description = "Allow ssh from Alienvault (TF managed desc.)"
  }

  ingress {
    #ICMP rules
    from_port = 0
    to_port = -1
    self = true
    protocol = "icmp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.220.16.250/32", "10.220.17.250/32"]
    description = "Allow echo reply traffic from the apt cachers (TF managed desc.)"
  }

  ingress {
    #ICMP rules
    from_port = 8
    to_port = -1
    self = true
    protocol = "icmp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.220.16.250/32", "10.220.17.250/32"]
    description = "Allow echo request traffic from the apt cachers (TF managed desc.)"
  }

  ingress {
    from_port = 3142
    to_port = 3142
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.220.16.250/32", "10.220.17.250/32"]
    description = "Allow apt-cacher traffic from the apt cachers (TF managed desc.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name","STG DMZ_Tier"))}"

    # Don't destroy this SG before creating a new one.
    lifecycle {
      create_before_destroy = true
    }
}
