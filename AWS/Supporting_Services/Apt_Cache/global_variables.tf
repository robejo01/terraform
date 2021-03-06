# This assumes you have your aws configuration file set up with profiles for each AWS account
provider "aws" {
  version = "~> 2.0"
  profile = "Prod02"

  # Hard code the region since this plan is for 11 only
  # This also provides safety in causing hard failures later in the plan if resources in the
  # wrong region are specified. Do not change this unless you know what you're doing.
  region = "us-east-1"
}

terraform {
  backend "consul" {
    address      = "address.of.consul.server"
    scheme       = "http"
    path         = "path/to/project"
    access_token = "YOUR-TOKEN-HERE"
  }
}

# Apt Cache AMI ID
variable "ac_ami" {
  type = "string"

  default = "ami-1234567890b33df22"
}

# We can't use the AZ data source because we aren't starting from AZ A or using all AZs
variable "azs" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "pretty_az_ids" {
  type = "map"

  default = {
    us-east-1a = "A"
    us-east-1b = "B"
    us-east-1c = "C"
  }
}


variable "ac_subnets" {
  type = "list"

  default = ["subnet-012345678909d1858d", "subnet-1234567890b0285f2"]
}

variable "ac_ips" {
  type = "list"

  default = ["10.220.16.250", "10.220.17.250"]
}

variable "mgmt_vpc" {
  type = "string"

  default = "vpc-abcdefg12345679acb0fc1df"
}

variable "ac_reverse_zones" {
  type = "list"

  default = ["Z01234567890TRJ3E30O", "Z12345678WASLR"]
}

variable "ac_tags" {
  default = {
    Env = "MGMT"
    Group = "Infra-Networking"
    Infra-Category = "Apt-Cache-Servers-MGMT"
    Service = "apt-cache"
  }
}

variable "base_env_tags" {
  default = {
    Env = "AWS11 - MGMT"
    Group = "Infra-Networking"
  }
}

variable "mgmt-app-tier" {
  default = "sg-01234567891055e65"
}
