#################################################################
#                                                               #
#                      TestS02 Giftcard                         #
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
resource "null_resource" "gc-vinterface" {
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.gc_vint_ip}","name":"${var.gc_vint_name}"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/interfaces/virtual
EOT
  }
}

# Send in the clowns!
resource "null_resource" "killtime" {
  depends_on = ["null_resource.gc-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# And here's the farm creation
resource "null_resource" "gc-farm" {
  depends_on = ["null_resource.gc-vinterface"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"test-giftcardsvcs02","profile":"http","vip":"${var.gc_vint_ip}","vport":"13010"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we modify the farm - certs, SSL settings, etc...  All in here..
resource "null_resource" "farm-mod" {
  depends_on = ["null_resource.gc-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"listener":"http","httpverb":"extendedHTTP","rewritelocation":"disabled","error414":"Request URI is too long. (ZENLB)","error500":"An internal server error occurred. Please try again later. (ZENLB)","error501":"This method may not be used. (ZENLB)","error503":"The service is not available. Please try again later. (ZENLB)"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02
EOT
  }
}

# Getting the jist of it yet?  Yeah, restarting
resource "null_resource" "farmsvc_restart-2" {
  depends_on = ["null_resource.farm-mod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/actions
EOT
  }
}

# Clowns!
resource "null_resource" "killtime-2" {
  depends_on = ["null_resource.farmsvc_restart-2"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we'll create a new service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "null_resource" "gc_service" {
  depends_on = ["null_resource.killtime-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"giftcardsvcs02-svc"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/services
EOT
  }
}

# Restart things again
resource "null_resource" "farmsvc_restart-4" {
  depends_on = ["null_resource.gc_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/actions
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
resource "null_resource" "gc_svcmod" {
  depends_on = ["null_resource.killtime-3"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.gc_vhostname}","leastresp":"true"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/services/giftcardsvcs02-svc
EOT
  }
}

# Yep, another restart
resource "null_resource" "farmsvc_restart-5" {
  depends_on = ["null_resource.gc_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/actions
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
resource "null_resource" "gc_bkend1" {
  depends_on = ["null_resource.killtime-4"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.gc_bkend1_ip}","port":${var.gc_bkend_port},"weight":2,"timeout":15}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/services/giftcardsvcs02-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-6" {
  depends_on = ["null_resource.gc_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/actions
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
resource "null_resource" "gc_bkend2" {
  depends_on = ["null_resource.killtime-5"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.gc_bkend2_ip}","port":${var.gc_bkend_port},"weight":2,"timeout":15}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/services/giftcardsvcs02-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-7" {
  depends_on = ["null_resource.gc_bkend2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/actions
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
resource "null_resource" "add-gc-check" {
  depends_on = ["null_resource.killtime-6"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_giftcard","copy_from":"check_http"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/monitoring/fg
EOT
  }
}

# Now let's modify the new monitor
resource "null_resource" "mod-gc-check" {
  depends_on = ["null_resource.add-gc-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"command":"check_http -I HOST -p PORT -w 10 -c 15 -t 15 -u / -R \\\"health\\\":\\\"HEALTHY\\\""}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/monitoring/fg/check_giftcard
EOT
  }
}

# Here's where we apply the check to the farm/service
resource "null_resource" "gc-check" {
  depends_on = ["null_resource.mod-gc-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"name":"check_giftcard"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/services/giftcardsvcs02-svc/fg
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-8" {
  depends_on = ["null_resource.gc-check"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.company.com:444/zapi/v4.0/zapi.cgi/farms/test-giftcardsvcs02/actions
EOT
  }
}

# You made it!
output "done" {
  depends_on = ["null_resource.farmsvc_restart-8"]
  value = "Done!  Check your work while you're at it, oh mighty ZEN MASTER!!"
}
