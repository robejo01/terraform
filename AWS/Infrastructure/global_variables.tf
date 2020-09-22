# This assumes you have your aws configuration file set up with profiles for each AWS account
provider "aws" {
  version = "~> 2.7"
  profile = "Prod01"

  # Hard code the region since this plan is for 06 only
  # This also provides safety in causing hard failures later in the plan if resources in the
  # wrong region are specified. Do not change this unless you know what you're doing.
  region = "us-west-2"
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
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "pretty_az_ids" {
  type = "map"

  default = {
    us-west-2a = "A"
    us-west-2b = "B"
    us-west-2c = "C"
  }
}

variable "stg-allow-all-sg" {
  type = "string"

  default = "sg-f609808f"
}

variable "dmz_tier_subnets" {
  type    = "list"
  default = ["subnet-abcd1234", "subnet-efgh5678"]
}

variable "stg_vpcid" {
  type    = "string"
  default = "vpc-abcd1234"
}

variable "base_env_tags" {
  default = {
    Env   = "STG"
    EnvID = "01"
    Group = "Infra-Networking"
  }
}

variable "as_grp_name" {
  default = "STG-BWAF-CF-AS-BWAFAutoScalingGroup-ABCDEF123456"
}
