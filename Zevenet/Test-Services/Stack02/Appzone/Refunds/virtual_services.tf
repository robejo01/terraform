#################################################################
#                                                               #
#                      TestS02 Appzone Refunds                  #
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
# And here's the farm creation
resource "null_resource" "appzone-refund-farm" {
  #  depends_on = ["null_resource.farmsvc_restart-8"]
  provisioner "local-exec" {
    command = <<EOT
  curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"farmname":"test-appzones02-refund","profile":"http","vip":"${var.az_vint_ip}","vport":"10080"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms
EOT
  }
}

# Here's where we'll create the service for the farm - you can only name it here - more specifics for the service down below - but you know, only after we kill more time = )
resource "null_resource" "appzone_refund_service" {
  depends_on = ["null_resource.appzone-refund-farm"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"id":"appzones02-refund-svc"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/services
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-1" {
  depends_on = ["null_resource.appzone_refund_service"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-redir/actions
EOT
  }
}

# Here's where we'll modify the farm service - think hostname, persistence, etc..
resource "null_resource" "appzone__refund_svcmod" {
  depends_on = ["null_resource.farmsvc_restart-1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"vhost":"${var.az_vhostname}"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/services/appzones02-refund-svc
EOT
  }
}

# Restart the farm
resource "null_resource" "farmsvc_restart-2" {
  depends_on = ["null_resource.appzone__refund_svcmod"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/actions
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "appzone_bkend1" {
  depends_on = ["null_resource.farmsvc_restart-2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.az_bkend1_ip}","port":${var.az_bkend_port},"weight":2,"timeout":15}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/services/appzones02-refund-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-3" {
  depends_on = ["null_resource.appzone_bkend1"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/actions
EOT
  }
}

# Here's the little clown
resource "null_resource" "killtime-3" {
  depends_on = ["null_resource.farmsvc_restart-3"]
  provisioner "local-exec" {
    command = <<EOT
    echo -e "\e[5m\e[92m\\e[1mKilling-Time-For-Replication" && sleep 5
EOT
  }
}

# Here's where we add in the backend servers/ports/weights/timeouts
resource "null_resource" "appzone_bkend2" {
  depends_on = ["null_resource.killtime-3"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X POST -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"ip":"${var.az_bkend2_ip}","port":${var.az_bkend_port},"weight":2,"timeout":15}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/services/appzones02-refund-svc/backends
EOT
  }
}

# Restart things
resource "null_resource" "farmsvc_restart-4" {
  depends_on = ["null_resource.appzone_bkend2"]
  provisioner "local-exec" {
    command = <<EOT
    curl -s -i -k -X PUT -H 'Content-Type: application/json' -H "ZAPI_KEY: "${var.api_key}"" -d '{"action":"restart"}' https://zenlb03.mgmt.tsafe.systems:444/zapi/v4.0/zapi.cgi/farms/test-appzones02-refund/actions
EOT
  }
}

# You made it!
output "done" {
  depends_on = ["null_resource.farmsvc_restart-4"]
  value      = "Done!  Check your work while you're at it, oh mighty ZEN MASTER!!"
}
