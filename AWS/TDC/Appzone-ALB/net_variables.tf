variable "az_tg_arn" {
  type    = "string"
  default = "arn:aws:elasticloadbalancing:us-west-2:123456730411:targetgroup/StageS01-App/1234567ea946694"
}

variable "az_tg_name" {
  type    = "string"
  default = "StageS01-App"
}

variable "stg_vpc" {
  type    = "string"
  default = "vpc-9d7960f9"
}

variable "az_instances" {
  type    = "list"
  default = ["i-0123456789eb17281, i-01234567898045a51, i-01234567898ac0594"]
}

variable "sg_id" {
  type    = "string"
  default = "sg-abcd1234"
}

variable "subnets" {
  type    = "list"
  default = ["subnet-abcd1234, subnet-abcd1234, subnet-abcd1234"]
}

variable "cert_arn" {
  type    = "string"
  default = "arn:aws:acm:us-west-2:012345678901:certificate/6e8117c9-763a-4b7a-a047-41e75269406c"
}
