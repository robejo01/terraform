#################################################################
#                                                               #
#                      TESTS02 UDX                              #
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
resource "null_resource" "udx-vinterface" {
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.udx_vint_ip}","name":"${var.udx_vint_name}"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/interfaces/virtual
EOT
  }
}

# Send in the clowns!
resource "null_resource" "killtime" {
  depends_on = ["null_resource.udx-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# And here's the farm creation
resource "null_resource" "udx-farm" {
  depends_on = ["null_resource.udx-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"test-portals02","profile":"http","vip":"${var.udx_vint_ip}","vport":"10443"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we modify the farm - certs, SSL settings, etc...  All in here..
resource "null_resource" "farm-mod" {
  depends_on = ["null_resource.udx-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"listener":"https","vport":443,"disable_sslv2":"true","disable_sslv3":"true","disable_tlsv1":"true","disable_tlsv1_1":"true","ciphers":"customsecurity","cipherc":"${var.udx_ciphers}","httpverb":"extendedHTTP","rewritelocation":"disabled","error414":"Request URI is too long.(ZENLB)","error500":"An internal server error occurred. Please try again later.(ZENLB)","error501":"This method may not be used.(ZENLB)","error503":"The service is not available. Please try again later.(ZENLB)"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-2" {
  depends_on = ["null_resource.farm-mod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
EOT
  }
}

# Let's add a cert/key to the farm
resource "null_resource" "udx-farmcert" {
  depends_on = ["null_resource.farmsvc_restart-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"file":"${var.udx_certname}"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/certificates
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-3" {
  depends_on = ["null_resource.udx-farmcert"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
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
resource "null_resource" "udx_service" {
  depends_on = ["null_resource.killtime-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"portals02-svc"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/services
EOT
  }
}

# Restart things again
resource "null_resource" "farmsvc_restart-4" {
  depends_on = ["null_resource.udx_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
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
resource "null_resource" "udx_svcmod" {
  depends_on = ["null_resource.killtime-3"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.udx_vhostname}","leastresp":"true"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/services/portals02-svc
EOT
  }
}

# Yep, another restart
resource "null_resource" "farmsvc_restart-5" {
  depends_on = ["null_resource.udx_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
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
resource "null_resource" "udx_bkend1" {
  depends_on = ["null_resource.killtime-4"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.udx_bkend1_ip}","port":${var.udx_bkend_port},"weight":2,"timeout":5}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/services/portals02-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-6" {
  depends_on = ["null_resource.udx_bkend2", "null_resource.udx_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
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
resource "null_resource" "udx_bkend2" {
  depends_on = ["null_resource.udx_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.udx_bkend2_ip}","port":${var.udx_bkend_port},"weight":2,"timeout":5}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/services/portals02-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-7" {
  depends_on = ["null_resource.udx_bkend2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
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

# Here's where we create a new farmguardian monitor for udx
resource "null_resource" "add-udx-check" {
  depends_on = ["null_resource.killtime-6"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_udx","copy_from":"check_http"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/monitoring/fg
EOT
  }
}

# Now let's modify the new monitor
resource "null_resource" "mod-udx-check" {
  depends_on = ["null_resource.add-udx-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"command":"check_http -I HOST -p PORT -w 10 -c 15 -t 15 -u /system/status -R '"'ready: true'"'"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/monitoring/fg/check_udx
EOT
  }
}

# Here's where we apply the check to the farm/service
resource "null_resource" "udx-check" {
  depends_on = ["null_resource.mod-udx-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_udx"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/services/portals02-svc/fg
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-8" {
  depends_on = ["null_resource.udx-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02/actions
EOT
  }
}

# Now we'll make a farm to re-direct the http traffic to https since that's evidently still necessary these days
# And here's the farm creation
resource "null_resource" "udx-redir-farm" {
  depends_on = ["null_resource.farmsvc_restart-8"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"test-portals02-redir","profile":"http","vip":"${var.udx_vint_ip}","vport":"80"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we'll create the service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "null_resource" "udx_redir_service" {
  depends_on = ["null_resource.udx-redir-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"portals02-redir-svc"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02-redir/services
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-9" {
  depends_on = ["null_resource.udx_redir_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02-redir/actions
EOT
  }
}

# Here's where we'll modify the farm service - think hostname, persistence, etc..
resource "null_resource" "udx_redir_svcmod" {
  depends_on = ["null_resource.farmsvc_restart-9"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.udx_vhostname}","redirect":"${var.udx_redirurl}","redirecttype":"default","leastresp":"true"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02-redir/services/portals02-redir-svc
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-10" {
  depends_on = ["null_resource.udx_redir_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-portals02-redir/actions
EOT
  }
}

# You made it!
output "done" {
  depends_on = ["null_resource.farmsvc_restart-10"]
  value = "Done!  Check your work while you're at it, oh mighty ZEN MASTER!!"
}
