#################################################################
#                                                               #
#                   DEVS01 Victoria's Station                   #
# These commands fly by so fast, it's super difficult to        #
# watch/debug.  So, I've thrown in some basic sleep commands    #
# to help with that and allow for replication to take place.    #
#                                                               #
#                                                               #
##                                                             ##
# Eventhough you can successfully upload the cert via a curl    #
# command/API call, the call doesn't seem to add a "common name"#
# to the file.  So, later when the file is attempted to be      #
# referenced, it fails as do subsequent commands that follow.   #
##                                                             ##
#         SO MAKE SURE YOU UPLOAD A CERT FIRST!!!!!!!           #
#################################################################
##
# Here's where we create a virtual interface!
resource "null_resource" "vs-vinterface" {
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.vs_vint_ip}","netmask":"${var.vs_vint_mask}","gateway":"${var.vs_vint_gw}","name":"${var.vs_vint_name}"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/interfaces/virtual
EOT
  }
}

# Send in the clowns!
resource "null_resource" "killtime" {
  depends_on = ["null_resource.vs-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# And here's the farm creation
resource "null_resource" "vs-farm" {
  depends_on = ["null_resource.vs-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"dev-vssvcs01","profile":"http","vip":"${var.vs_vint_ip}","vport":"13010"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we modify the farm - certs, SSL settings, etc...  All in here..
resource "null_resource" "farm-mod" {
  depends_on = ["null_resource.vs-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"listener":"http","httpverb":"extendedHTTP","rewritelocation":"disabled","error414":"Request URI is too long.(ZENLB)","error500":"An internal server error occurred. Please try again later.(ZENLB)","error501":"This method may not be used.(ZENLB)","error503":"The service is not available. Please try again later.(ZENLB)"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-1" {
  depends_on = ["null_resource.farm-mod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/actions
EOT
  }
}

# Clowns!
resource "null_resource" "killtime-2" {
  depends_on = ["null_resource.farmsvc_restart-1"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we'll create a new service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "null_resource" "vs_service" {
  depends_on = ["null_resource.killtime-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"vssvcs01-svc"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/services
EOT
  }
}

# Restart things again
resource "null_resource" "farmsvc_restart-2" {
  depends_on = ["null_resource.vs_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/actions
EOT
  }
}

# Let things settle by bringing the clowns back in
resource "null_resource" "killtime-3" {
  depends_on = ["null_resource.farmsvc_restart-2"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we'll modify the farm service - think hostname, persistence, etc..
resource "null_resource" "vs_svcmod" {
  depends_on = ["null_resource.killtime-3"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.vs_vhostname}"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/services/vssvcs01-svc
EOT
  }
}

# Yep, another restart
resource "null_resource" "farmsvc_restart-3" {
  depends_on = ["null_resource.vs_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/actions
EOT
  }
}

# What did you expect by now?  MOAR CLOWN!
resource "null_resource" "killtime-4" {
  depends_on = ["null_resource.farmsvc_restart-3"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "vs_bkend1" {
  depends_on = ["null_resource.killtime-4"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.vs_bkend1_ip}","port":${var.vs_bkend_port},"weight":2,"timeout":15}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/services/vssvcs01-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-4" {
  depends_on = ["null_resource.vs_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/actions
EOT
  }
}

# Here's the little clown
resource "null_resource" "killtime-5" {
  depends_on = ["null_resource.farmsvc_restart-4"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "vs_bkend2" {
  depends_on = ["null_resource.killtime-5"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.vs_bkend2_ip}","port":${var.vs_bkend_port},"weight":2,"timeout":15}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/services/vssvcs01-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-5" {
  depends_on = ["null_resource.vs_bkend2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/actions
EOT
  }
}

# Here's the little clown
resource "null_resource" "killtime-6" {
  depends_on = ["null_resource.farmsvc_restart-5"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we create a new farmguardian monitor for appzone
resource "null_resource" "add-vstation-check" {
  depends_on = ["null_resource.killtime-6"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_vstation","parent":"check_http"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/monitoring/fg
EOT
  }
}

# Now let's modify the new monitor
resource "null_resource" "mod-vstation-check" {
  depends_on = ["null_resource.add-vstation-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"command":"check_http -I HOST -p PORT -w 10 -c 15 -t 15 -u / -R \\\"health\\\":\\\"HEALTHY\\\""}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/monitoring/fg/check_vstation
EOT
  }
}

# Here's where we apply the check to the farm/service
resource "null_resource" "vstation-check" {
  depends_on = ["null_resource.mod-vstation-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_vstation"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/services/vssvcs01-svc/fg
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-6" {
  depends_on = ["null_resource.vstation-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/dev-vssvcs01/actions
EOT
  }
}

# You made it!
output "done" {
  depends_on = ["null_resource.farmsvc_restart-6"]
  value      = "Done!  Check your work while you're at it, oh mighty ZEN MASTER!!"
}
