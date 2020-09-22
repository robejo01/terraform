#############################################
#                                           #
# This is a POC terraform that makes use    #
# of Zen/Zevenet's REST API to create a     #
# load-balanced HTTP farm w/ monitoring     #
#                                           #
#############################################
#                                           #
# Author: Robert Jones                      #
# Date: 9-26-19                             #
#                                           #
#############################################
##
# Here's where we create a virtual interface!
resource "restapi_object" "virt_interface" {
  path = "/interfaces/virtual"
  data = "{ \"id\":\"eth0.1000:15\",\"name\":\"eth0.1000:15\",\"ip\":\"192.168.15.15\",\"netmask\":\"255.255.255.0\",\"gateway\":\"192.168.15.1\"}"
}

# And here's the farm creation
resource "null_resource" "farms" {
  depends_on = ["restapi_object.virt_interface"]
  provisioner "local-exec" {
    command = <<EOT
  curl -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"farmname":"thefarmTerraformCreated","profile":"http","vip":"192.168.15.15","vport":"80"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# We should restart the farm to continue to be able to make modifications to it
resource "null_resource" "farmsvc_restart-1" {
  depends_on = ["null_resource.farms"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/actions
EOT
  }
}

# Send in the clowns!
resource "null_resource" "killtime" {
  depends_on = ["null_resource.farmsvc_restart-1"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 10
EOT
  }
}

# Here's where we modify the farm - certs, SSL settings, etc...  All in here..
resource "null_resource" "farm-mod" {
  depends_on = ["null_resource.killtime"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"httpverb":"standardHTTP","rewritelocation":"enabled"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-2" {
  depends_on = ["null_resource.farm-mod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/actions
EOT
  }
}

# Clowns!
resource "null_resource" "killtime-1" {
  depends_on = ["null_resource.farmsvc_restart-2"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 10
EOT
  }
}

# Here's where we'll create a new service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "restapi_object" "farm_service" {
  depends_on = ["null_resource.killtime-1"]
  path       = "/farms/thefarmTerraformCreated/services"
  data       = "{ \"id\":\"blarf\"}"
}

# Restart things again
resource "null_resource" "farmsvc_restart-3" {
  depends_on = ["restapi_object.farm_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/actions
EOT
  }
}

# Let things settle by bringing the clowns back in
resource "null_resource" "killtime-2" {
  depends_on = ["null_resource.farmsvc_restart-3"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 10
EOT
  }
}

# Here's where we'll modify the farm service - think hostname, persistence, etc..
resource "null_resource" "farm_svcmod" {
  depends_on = ["null_resource.farmsvc_restart-3", "null_resource.killtime-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"vhost":"blarf.lab.company.com","persistence":"IP"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/services/blarf
EOT
  }
}

# Yep, another restart
resource "null_resource" "farmsvc_restart-4" {
  depends_on = ["null_resource.farm_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/actions
EOT
  }
}

# What did you expect by now?  MOAR CLOWN!
resource "null_resource" "killtime-3" {
  depends_on = ["null_resource.farmsvc_restart-4"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 10
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "farmsvc_bkend" {
  depends_on = ["null_resource.killtime-3"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"ip":"192.168.15.17","port":"80"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/services/blarf/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-5" {
  depends_on = ["null_resource.farmsvc_bkend"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/actions
EOT
  }
}

# Here's the little clown
resource "null_resource" "killtime-4" {
  depends_on = ["null_resource.farmsvc_restart-5"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 10
EOT
  }
}

# Here's where we create a farmguardian monitor
resource "null_resource" "farmguardians" {
  depends_on = ["null_resource.killtime-4"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"name":"check_tcp-cut_conns"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/services/blarf/fg
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-6" {
  depends_on = ["null_resource.farmguardians"]
  provisioner "local-exec" {
    command = <<EOT
    curl -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: API-KEY-HERE" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/thefarmTerraformCreated/actions
EOT
  }
}

# You made it!
output "done" {
  depends_on = ["null_resource.farmsvc_restart-6"]
  value      = "Done!  Now restart the farm manually once again because even this rest API ain't perfect!  Oh!  Check your work while you're at it, oh mighty ZEN MASTER!!"
}
