#########################
##                     ##
### US-EAST-1 - AWS10 ###
##                     ##
#########################
resource "aws_vpc" "AWS10" {
  cidr_block       = "10.155.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  enable_classiclink_dns_support = "false"
  assign_generated_ipv6_cidr_block = "false"

  tags    = "${merge(var.base_env_tags, map("Name","STG10"))}"
}
## Internet Gateway
resource "aws_internet_gateway" "AWS10-GW" {
  vpc_id = "${aws_vpc.AWS10.id}"

  tags = "${merge(var.base_env_tags, map("Name","AWS10-GW"))}"
}

## Route 53 Forward Zones
resource "aws_route53_zone" "dmz10" {
  name    = "dmz10.company.com"
  comment = "US-East-1 STG10 Edge"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "app10" {
  name    = "app10.company.com"
  comment = "US-East-1 STG10 App"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "data10" {
  name    = "data10.company.com"
  comment = "US-East-1 STG10 Data"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

## Route 53 Reverse Zones
resource "aws_route53_zone" "AWS10-Edge-AZA" {
  name    = "0.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 DMZ"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-Edge-AZB" {
  name    = "1.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 DMZ"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-Edge-AZC" {
  name    = "2.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 DMZ"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-App-AZA" {
  name    = "16.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 App"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-App-AZB" {
  name    = "17.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 App"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-App-AZC" {
  name    = "18.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 App"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-Data-AZA" {
  name    = "32.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 Data"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-Data-AZB" {
  name    = "33.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 Data"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

resource "aws_route53_zone" "AWS10-Data-AZC" {
  name    = "33.155.10.in-addr.arpa"
  comment = "US-East-1 STG10 Data"
  tags    = "${var.base_env_tags}"

  vpc {
    vpc_id = "${aws_vpc.AWS10.id}"
  }
}

########################
## AWS10 Global Rules ##
# to_port (65535) and from_port (0) must both be 0 to use the the 'all' "-1" protocol!
## Notes: You have to add the 'subnet_ids' arguement in order for any subsequent plans/applys to yield a 'clean' state.  Otherwise, it'll want to delete them and will remain as a change to be made.
########################
resource "aws_default_network_acl" "AWS10-Global-Rules" {
  default_network_acl_id = aws_vpc.AWS10.default_network_acl_id
  subnet_ids = [aws_subnet.AWS10-Edge-AZA.id, aws_subnet.AWS10-Edge-AZB.id, aws_subnet.AWS10-Edge-AZC.id, aws_subnet.AWS10-App-AZA.id, aws_subnet.AWS10-App-AZB.id, aws_subnet.AWS10-App-AZC.id, aws_subnet.AWS10-Data-AZA.id, aws_subnet.AWS10-Data-AZB.id, aws_subnet.AWS10-Data-AZC.id]

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 99
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 23
    to_port    = 23
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "udp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    icmp_type  = 0
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 301
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    icmp_type  = 8
    from_port  = 0
    to_port    = 0
  }

  tags = "${merge(var.base_env_tags, map("Name","AWS10 Global Rules"))}"
}

##  Let's make some subnets and slice the main subnet up

resource "aws_subnet" "AWS10-Edge-AZA" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.0.0/24"
  availability_zone = "us-east-1a"

  tags = "${merge(var.base_env_tags, map("Name","STG10 Edge AZA"))}"
}

resource "aws_subnet" "AWS10-Edge-AZB" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.1.0/24"
  availability_zone = "us-east-1b"

  tags = "${merge(var.base_env_tags, map("Name","STG10 Edge AZB"))}"
}

resource "aws_subnet" "AWS10-Edge-AZC" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.2.0/24"
  availability_zone = "us-east-1c"

  tags = "${merge(var.base_env_tags, map("Name","STG10 Edge AZC"))}"
}

resource "aws_subnet" "AWS10-App-AZA" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.16.0/24"
  availability_zone = "us-east-1a"

  tags = "${merge(var.base_env_tags, map("Name","STG10 App AZA"))}"
}

resource "aws_subnet" "AWS10-App-AZB" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.17.0/24"
  availability_zone = "us-east-1b"

  tags = "${merge(var.base_env_tags, map("Name","STG10 App AZB"))}"
}

resource "aws_subnet" "AWS10-App-AZC" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.18.0/24"
  availability_zone = "us-east-1c"

  tags = "${merge(var.base_env_tags, map("Name","STG10 App AZC"))}"
}

resource "aws_subnet" "AWS10-Data-AZA" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.32.0/24"
  availability_zone = "us-east-1a"

  tags = "${merge(var.base_env_tags, map("Name","STG10 Data AZA"))}"
}

resource "aws_subnet" "AWS10-Data-AZB" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.33.0/24"
  availability_zone = "us-east-1b"

  tags = "${merge(var.base_env_tags, map("Name","STG10 Data AZB"))}"
}

resource "aws_subnet" "AWS10-Data-AZC" {
  vpc_id     = "${aws_vpc.AWS10.id}"
  cidr_block = "10.155.34.0/24"
  availability_zone = "us-east-1c"

  tags = "${merge(var.base_env_tags, map("Name","STG10 Data AZC"))}"
}

##  How about some route tables

resource "aws_default_route_table" "STG10-Edge-Router" {
  default_route_table_id = "${aws_vpc.AWS10.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.AWS10-GW.id}"
  }
  route {
    cidr_block = "10.220.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "pcx-012345678901234567"
  }
  route {
    cidr_block = "10.20.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "${aws_vpc_peering_connection.STG10-to-MGMT0.id}"
  }

  tags = "${merge(var.base_env_tags, map("Name","STG10 Edge Router"))}"
}

resource "aws_route_table" "STG10-Core-Router-AZA" {
  vpc_id = "${aws_vpc.AWS10.id}"

  route {
    cidr_block = "10.220.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "pcx-012345678901234567"
  }
  route {
    cidr_block = "10.20.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "${aws_vpc_peering_connection.STG10-to-MGMT0.id}"
  }
  route {
    cidr_block = "10.150.0.0/16" # Access to/from STG07
    vpc_peering_connection_id = "pcx-012345678901234567"
  }

  tags = "${merge(var.base_env_tags, map("Name","STG10 Core Router AZA"))}"
}

resource "aws_route_table" "STG10-Core-Router-AZB" {
  vpc_id = "${aws_vpc.AWS10.id}"

  route {
    cidr_block = "10.220.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "pcx-012345678901234567"
  }
  route {
    cidr_block = "10.20.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "${aws_vpc_peering_connection.STG10-to-MGMT0.id}"
  }
  route {
    cidr_block = "10.150.0.0/16" # Access to/from STG07
    vpc_peering_connection_id = "pcx-012345678901234567"
  }
  tags = "${merge(var.base_env_tags, map("Name","STG10 Core Router AZB"))}"
}

resource "aws_route_table" "STG10-Core-Router-AZC" {
  vpc_id = "${aws_vpc.AWS10.id}"

  route {
    cidr_block = "10.220.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "pcx-012345678901234567"
  }
  route {
    cidr_block = "10.20.0.0/16" # Access to/from MGMT11
    vpc_peering_connection_id = "${aws_vpc_peering_connection.STG10-to-MGMT0.id}"
  }
  route {
    cidr_block = "10.150.0.0/16" # Access to/from STG07
    vpc_peering_connection_id = "pcx-012345678901234567"
  }
  tags = "${merge(var.base_env_tags, map("Name","STG10 Core Router AZC"))}"
}

##  Now to associate the subnets to the routers

resource "aws_route_table_association" "AWS10-Edge-AZA" {
  subnet_id      = "${aws_subnet.AWS10-Edge-AZA.id}"
  route_table_id = "${aws_default_route_table.STG10-Edge-Router.id}"
}

resource "aws_route_table_association" "AWS10-Edge-AZB" {
  subnet_id      = "${aws_subnet.AWS10-Edge-AZB.id}"
  route_table_id = "${aws_default_route_table.STG10-Edge-Router.id}"
}

resource "aws_route_table_association" "AWS10-Edge-AZC" {
  subnet_id      = "${aws_subnet.AWS10-Edge-AZC.id}"
  route_table_id = "${aws_default_route_table.STG10-Edge-Router.id}"
}

resource "aws_route_table_association" "AWS10-Core-AZA" {
  subnet_id      = "${aws_subnet.AWS10-App-AZA.id}"
  route_table_id = "${aws_route_table.STG10-Core-Router-AZA.id}"
}

resource "aws_route_table_association" "AWS10-Core-AZA-Data" {
  subnet_id      = "${aws_subnet.AWS10-Data-AZA.id}"
  route_table_id = "${aws_route_table.STG10-Core-Router-AZA.id}"
}

resource "aws_route_table_association" "AWS10-Core-AZB" {
  subnet_id      = "${aws_subnet.AWS10-App-AZB.id}"
  route_table_id = "${aws_route_table.STG10-Core-Router-AZB.id}"
}

resource "aws_route_table_association" "AWS10-Core-AZB-Data" {
  subnet_id      = "${aws_subnet.AWS10-Data-AZB.id}"
  route_table_id = "${aws_route_table.STG10-Core-Router-AZB.id}"
}

resource "aws_route_table_association" "AWS10-Core-AZC" {
  subnet_id      = "${aws_subnet.AWS10-App-AZC.id}"
  route_table_id = "${aws_route_table.STG10-Core-Router-AZC.id}"
}

resource "aws_route_table_association" "AWS10-Core-AZC-Data" {
  subnet_id      = "${aws_subnet.AWS10-Data-AZC.id}"
  route_table_id = "${aws_route_table.STG10-Core-Router-AZC.id}"
}
