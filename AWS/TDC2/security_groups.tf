# AWS01 TDC2 RPT SVCS Security Group S2S
# It was discovered that TCP communications over port 3306 to the STG01 Databases weren't working.  It was then discovered/realized that there had not yet been a need for instances in the Prod02 acct to access databases under the Prod01 acct.  So, this is new.
# It was also discovered that what appears to have been a rule to have this actually work, never did as it wasn't configured correctly. So, we'll just fix that up! =)
###################################
# # # US-West-2 AWS01 STG  # # # ##
# # #    Security Groups      # # #
###################################

###################################
############# App Tier ############
###################################

resource "aws_security_group" "stg-app-tier" {
  name        = "App_Tier"
  description = "Application layer security group"
  vpc_id      = "vpc-abcd1234"

  ingress {
    # All Traffic
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["10.20.1.4/32", "10.20.1.6/32", "20.20.0.0/16"]
    # Here we are allowing the STG App Tier SG that's under the Prod02 account access to all things AWS01's App Tier
    security_groups = ["012345687624/sg-0012345677369a51fa"]
  }

  ingress {
    # SSH rule
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH access"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["10.20.12.38/32"]
  }

  ingress {
    # AV Logging
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    description = "AV Logging"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["10.20.12.38/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name", "App Tier"))}"
  # Don't destroy this SG before creating a new one.
  lifecycle {
    create_before_destroy = true
  }
}

########################################
############# Data Tier ################
########################################

resource "aws_security_group" "stg-data-tier" {
  name        = "Data_Tier"
  description = "Data layer security group"
  vpc_id      = "vpc-defg1234"

  ingress {
    from_port = 0
    to_port   = 0
    self      = true
    protocol  = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.1.4/32"]
    description = "Allow all inbound traffic from this address (TF managed desc.)"
  }

  ingress {
    # SSH rule
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["10.20.12.38/32"]
    description = "Allow ssh from Alienvault (TF managed desc.)"
  }

  ingress {
    # MYSQL rule
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    cidr_blocks = ["172.20.128.0/24", "172.20.129.0/24", "172.22.128.0/24", "172.22.129.0/24"]
    # Here we are allowing the STG RPTSVC_S2S SG that's under the Prod02 account access to MYSQL under the Prod01 acct.
    security_groups = ["012345678904/sg-0123456cc1bcd39fb"]
    description     = "Allow MYSQL communications (TF managed desc.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name", "Data Tier"))}"

  # Don't destroy this SG before creating a new one.
  lifecycle {
    create_before_destroy = true
  }
}

########################################
########  Staging Mail_Stack01 #########
########################################

resource "aws_security_group" "stg-mail-stack01" {
  name        = "Staging Mail_Stack01"
  description = "Staging Mail_Stack01"
  vpc_id      = "vpc-9d7960f9"

  ingress {
    # Mail rule
    from_port = 587
    to_port   = 587
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # While these could be pretty variables, I like to have the IPs in front of me when creating these rules.
    # Here we are allowing the STG RPTSVC_S2S SG that's under the Prod02 account access to SMTP under the Prod01 acct.
    security_groups = ["012345677624/sg-01234567890cd39fb", "sg-hijk1234", "sg-lmno1234", "sg-pqrs1234"]
    description     = "Allow SMTP communications (TF managed desc.)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.base_env_tags, map("Name", "Mail_Stack01"))}"

  # Don't destroy this SG before creating a new one.
  lifecycle {
    create_before_destroy = true
  }
}
