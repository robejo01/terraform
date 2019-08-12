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
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/aws11/supporting_services/nat_instances"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

variable "nat_ami" {
   type = "string"

   default = "ami-027ba5d3b4fab4bfa"
 }

variable "mgmt11_vpc" {
  type = "string"

  default = "vpc-09baa099acb0fc1df"
}

variable "nata_subnet" {
  type = "string"

  default = "subnet-079bce7f16db68917"
}

variable "natb_subnet" {
  type = "string"

  default = "subnet-0502be5a628032d3f"
}

variable "nat_reverse_zones" {
  type = "list"

  default = ["Z00540592B7ICSSI2KR2R", "Z00539091DGEKV8X59HU2"]
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
  default = "sg-0566ac4ea4414e86e"
}

variable "mgmt-dmz-tier" {
  default = "sg-03421041a87924a8b"
}
