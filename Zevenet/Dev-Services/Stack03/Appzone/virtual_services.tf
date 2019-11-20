#################################################################
#                                                               #
#                      DEVS03 Appzone                           #
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
resource "null_resource" "appzone-vinterface" {
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.az_vint_ip}","netmask":"${var.az_vint_mask}","gateway":"${var.az_vint_gw}","name":"${var.az_vint_name}"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/interfaces/virtual
EOT
  }
}

# Send in the clowns!
resource "null_resource" "killtime" {
  depends_on = ["null_resource.appzone-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# And here's the farm creation
resource "null_resource" "appzone-farm" {
  depends_on = ["null_resource.appzone-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"dev-appzones03","profile":"http","vip":"${var.az_vint_ip}","vport":"443"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we modify the farm - certs, SSL settings, etc...  All in here..
resource "null_resource" "farm-mod" {
  depends_on = ["null_resource.appzone-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"listener":"https","disable_sslv2":"true","disable_sslv3":"true","disable_tlsv1":"true","disable_tlsv1_1":"true","ciphers":"customsecurity","cipherc":"${var.az_ciphers}","httpverb":"extendedHTTP","rewritelocation":"disabled","error414":"Request URI is too long.(ZENLB)","error500":"An internal server error occurred. Please try again later.(ZENLB)","error501":"This method may not be used.(ZENLB)","error503":"The service is not available. Please try again later.(ZENLB)"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-2" {
  depends_on = ["null_resource.farm-mod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# Let's add a cert/key to the farm
resource "null_resource" "appzone-farmcert" {
  depends_on = ["null_resource.farmsvc_restart-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"file":"${var.az_certname}"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/certificates
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-3" {
  depends_on = ["null_resource.appzone-farmcert"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# Clowns!
resource "null_resource" "killtime-2" {
  depends_on = ["null_resource.farmsvc_restart-3"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we'll create a new service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "null_resource" "appzone_service" {
  depends_on = ["null_resource.killtime-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"appzones03-svc"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/services
EOT
  }
}

# Restart things again
resource "null_resource" "farmsvc_restart-4" {
  depends_on = ["null_resource.appzone_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# Let things settle by bringing the clowns back in
resource "null_resource" "killtime-3" {
  depends_on = ["null_resource.farmsvc_restart-4"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we'll modify the farm service - think hostname, persistence, etc..
resource "null_resource" "appzone_svcmod" {
  depends_on = ["null_resource.killtime-3"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.az_vhostname}"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/services/appzones03-svc
EOT
  }
}

# Yep, another restart
resource "null_resource" "farmsvc_restart-5" {
  depends_on = ["null_resource.appzone_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# What did you expect by now?  MOAR CLOWN!
resource "null_resource" "killtime-4" {
  depends_on = ["null_resource.farmsvc_restart-5"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "appzone_bkend1" {
  depends_on = ["null_resource.killtime-4"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.az_bkend1_ip}","port":${var.az_bkend_port},"weight":2,"timeout":15}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/services/appzones03-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-6" {
  depends_on = ["null_resource.appzone_bkend2", "null_resource.appzone_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# Here's the little clown
resource "null_resource" "killtime-5" {
  depends_on = ["null_resource.farmsvc_restart-6"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "appzone_bkend2" {
  depends_on = ["null_resource.appzone_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.az_bkend2_ip}","port":${var.az_bkend_port},"weight":2,"timeout":15}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/services/appzones03-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-7" {
  depends_on = ["null_resource.appzone_bkend2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# Here's the little clown
resource "null_resource" "killtime-6" {
  depends_on = ["null_resource.farmsvc_restart-7"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we create a new farmguardian monitor for appzone
# resource "null_resource" "add-appzone-check" {
#   depends_on = ["null_resource.killtime-6"]
#   provisioner "local-exec" {
#     command = <<EOT
#     curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_appzone","parent":"check_http"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/monitoring/fg
# EOT
#   }
# }

# Now let's modify the new monitor
# resource "null_resource" "mod-appzone-check" {
#   depends_on = ["null_resource.add-appzone-check"]
#   provisioner "local-exec" {
#     command = <<EOT
#     curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"command":"check_http -I HOST -p PORT -w 10 -c 15 -t 15 -u /ws/bs/system/status -R '"'appzone Ready: true'"'"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/monitoring/fg/check_appzone
# EOT
#   }
# }

# Here's where we apply the check to the farm/service
resource "null_resource" "appzone-check" {
  depends_on = ["null_resource.killtime-6"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_appzone"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/services/appzones03-svc/fg
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-8" {
  depends_on = ["null_resource.appzone-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03/actions
EOT
  }
}

# Now we'll make a farm to re-direct the http traffic to https since that's evidently still necessary these days
# And here's the farm creation
resource "null_resource" "appzone-redir-farm" {
  depends_on = ["null_resource.farmsvc_restart-8"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"dev-appzones03-redir","profile":"http","vip":"${var.az_vint_ip}","vport":"80"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we'll create the service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "null_resource" "appzone_redir_service" {
  depends_on = ["null_resource.appzone-redir-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"appzones03-redir-svc"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03-redir/services
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-9" {
  depends_on = ["null_resource.appzone_redir_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03-redir/actions
EOT
  }
}

# Here's where we'll modify the farm service - think hostname, persistence, etc..
resource "null_resource" "appzone__redir_svcmod" {
  depends_on = ["null_resource.farmsvc_restart-9"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.az_vhostname}","redirect":"${var.az_redirurl}","redirecttype":"default"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03-redir/services/appzones03-redir-svc
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-10" {
  depends_on = ["null_resource.appzone__redir_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb01.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/dev-appzones03-redir/actions
EOT
  }
}

# You made it!
output "done" {
  depends_on = ["null_resource.farmsvc_restart-8"]
  value = "Done!  Check your work while you're at it, oh mighty ZEN MASTER!!"
}
