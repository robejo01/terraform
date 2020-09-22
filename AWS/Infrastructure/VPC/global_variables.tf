# This assumes you have your aws configuration file set up with profiles for each AWS account
provider "aws" {
  version = "~> 2.0"
  profile = "Prod02"

  # Hard code the region since this plan is for 06 only
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

variable "base_env_tags" {
  default = {
    Env = "STG"
    EnvID = "10"
    Group = "Infra-Networking"
  }
}

variable "stg07_to_stg10_peer" {
  type = string

  default = "aws-account-number"
}

variable "stg07_to_stg10_vpcID" {
  type = string

  default = "vpc-abcd1234"
}

variable "stg07_to_stg10_ownerID" {
  type = string

  default = "aws-account-number"
}

variable "stg07_vpcID" {
  type = string

  default = "vpc-abcd1234"
}

variable "mgmt0_to_stg10_peer" {
  type = string

  default = "aws-account-number"
}

variable "mgmt0_to_stg10_vpcID" {
  type = string

  default = "vpc-abcd1234"
}

variable "mgmt0_to_stg10_ownerID" {
  type = string

  default = "aws-account-number"
}

variable "mgmt0_vpcID" {
  type = string

  default = "vpc-abcd1234"
}
