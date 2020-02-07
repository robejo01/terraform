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
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/aws01/infrastructure/tdc/appzone-alb"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

locals {

  # We can't use the AZ data source because we aren't starting from AZ A or using all AZs
  azs = ["us-west-2a", "us-west-2b", "us-west-2c"]

  pretty_az_ids = {
    "us-west-2a" = "A"
    "us-west-2b" = "B"
    "us-west-2c" = "C"
  }

  appzone_tags = {
    "Env"   = "Staging"
    "EnvID" = "01"
  }

}
