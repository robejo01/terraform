#############################
## VPC Peering Connections ##
##         AWS10           ##
#############################
## Notes: 2 Step Process!!!
## Notes:  You will need to manually modify the peering connections at BOTH ends to enable DNS resolution as per this mess: https://github.com/terraform-providers/terraform-provider-aws/issues/3069
## Notes: You will also need to accept the connection on the "other" side in order to keep the apply process moving.  Once you accept it, do another apply to finish your deploy.
## Notes: It seems that TF doesn't have the approperiate permissions to actually make any changes once you've accepted the connection request on the 'other side' since it continuously attempts to apply the tags.
############################################
### Inter-Region Peering Connection ###
## STG10 to  - STG07  ################
############################################
# Requester's side of the connection.
resource "aws_vpc_peering_connection" "STG10-to-STG07" {
  vpc_id        = "${aws_vpc.AWS10.id}"
  peer_vpc_id   = "${var.stg07_to_stg10_vpcID}"   #STG07 VPC ID
  peer_owner_id = "${var.stg07_to_stg10_ownerID}" #STG07 ACCT ID
  peer_region   = "us-west-2"                 #STG07 Region
  auto_accept   = false

  tags = "${merge(var.base_env_tags, map("Name","STG07 to STG10"))}"
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "STG10-to-STG07" {
  vpc_peering_connection_id = aws_vpc_peering_connection.STG10-to-STG07.id
  auto_accept               = true

  tags = "${merge(var.base_env_tags, map("Name","STG07 to STG10"))}"
}

############################################
### Inter-Acct/Region Peering Connection ###
## STG10 to  - MGMT0  ################
############################################
# Requester's side of the connection.
resource "aws_vpc_peering_connection" "STG10-to-MGMT0" {
  vpc_id        = "${aws_vpc.AWS10.id}"
  peer_vpc_id   = "${var.mgmt0_to_stg10_vpcID}"   #MGMT0 VPC ID
  peer_owner_id = "${var.mgmt0_to_stg10_ownerID}" #MGMT0 ACCT ID
  peer_region   = "us-west-2"                 #MGMT0 Region
  auto_accept   = false

  tags = "${merge(var.base_env_tags, map("Name","MGMT0 to STG10"))}"
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "STG10-to-MGMT0" {
  vpc_peering_connection_id = aws_vpc_peering_connection.STG10-to-MGMT0.id
  auto_accept               = true

  tags = "${merge(var.base_env_tags, map("Name","MGMT0 to STG10"))}"
}
