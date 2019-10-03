#############################################
#                                           #
# This is a POC terraform that makes use    #
# of Zen/Zevenet's REST API to create a     #
# load-balanced HTTP farm w/ monitoring     #
#                                           #
#############################################
#                                           #
# Global Variables and Provider/Consul info #
#                                           #
#                                           #
#############################################
terraform {
  backend "consul" {
    address      = "dockerhost02.lab.tsafe.systems:8500"
    scheme       = "http"
    path         = "tf-legacy/state/krkld/infrastructure/zevenet"
    access_token = "fbd54794-4a9d-ab23-e66d-b44b95375555"
  }
}

# We're only using this to create the virtual interface - otherwise, this isn't really usefull for us
provider "restapi" {
  uri                  = "https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi"
  debug                = true
  use_cookies          = true
  write_returns_object = true
  headers              = "${var.headers}"
}

#don't forget to set TF_VAR_zapi_auth_token="token"
variable "headers" {
  type    = map(string)
  default = { "Content-Type" = "application/json", "ZAPI_KEY" = "xFaaqQcAlbQOIRYpdsBgKgp6RSMKPAJU1fYjoOFXQbS4XdOgTSeGtnQ4djXiPL223" }
}
