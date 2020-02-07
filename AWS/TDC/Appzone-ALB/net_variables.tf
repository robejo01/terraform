variable "az_tg_arn" {
  type    = "string"
  default = "arn:aws:elasticloadbalancing:us-west-2:441514930411:targetgroup/StageS01-App/347f8517ea946694"
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
  default = ["i-080249da18eb17281, i-06b9e62c868045a51, i-08173cd9638ac0594"]
}

variable "sg_id" {
  type    = "string"
  default = "sg-f609808f"
}

variable "subnets" {
  type    = "list"
  default = ["subnet-f3090f97, subnet-71d08907, subnet-b28112ea"]
}

variable "cert_arn" {
  type    = "string"
  default = "arn:aws:acm:us-west-2:441514930411:certificate/6e8117c9-763a-4b7a-a047-41e75269406c"
}
