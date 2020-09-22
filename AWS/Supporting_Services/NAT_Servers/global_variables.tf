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
    address      = "address.to.consul.server"
    scheme       = "http"
    path         = "path/to/project"
    access_token = "YOUR-TOKEN-HERE"
  }
}

variable "nat_ami" {
   type = "string"

   default = "ami-0123456789fab4bfa"
 }

variable "mgmt11_vpc" {
  type = "string"

  default = "vpc-0123456789b0fc1df"
}

variable "nata_subnet" {
  type = "string"

  default = "subnet-0123456789db68917"
}

variable "natb_subnet" {
  type = "string"

  default = "subnet-01234567898032d3f"
}

variable "nat_reverse_zones" {
  type = "list"

  default = ["Z01234567897ICSSI2KR2R", "Z0123456789EKV8X59HU2"]
}

variable "nat01a_ips" {
  default = "10.220.0.7"
}

variable "nat01b_ips" {
  default = "10.220.1.7"
}


variable "nat02a_ips" {
  default ="10.220.0.14"
}

variable "nat02b_ips" {
  default = "10.220.1.14"
}

variable "nat_tags" {
  default = {
    Env = "MGMT"
    Group = "Infra-Networking"
    Infra-Category = "NAT-Servers-MGMT"
    Service = "egress"
  }
}

variable "base_env_tags" {
  default = {
    Env = "AWS11 - MGMT"
    Group = "Infra-Networking"
  }
}

variable "mgmt-allow-all" {
  default = "sg-0123456789414e86e"
}

variable "mgmt-dmz-tier" {
  default = "sg-01234567897924a8b"
}
