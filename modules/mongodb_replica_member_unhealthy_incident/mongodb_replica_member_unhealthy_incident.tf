resource "shoreline_notebook" "mongodb_replica_member_unhealthy_incident" {
  name       = "mongodb_replica_member_unhealthy_incident"
  data       = file("${path.module}/data/mongodb_replica_member_unhealthy_incident.json")
  depends_on = [shoreline_action.invoke_config_script,shoreline_action.invoke_mongodb_network_check,shoreline_action.invoke_config_replica_set,shoreline_action.invoke_restart_replica_set_members]
}

resource "shoreline_file" "config_script" {
  name             = "config_script"
  input_file       = "${path.module}/data/config_script.sh"
  md5              = filemd5("${path.module}/data/config_script.sh")
  description      = "Define the IP addresses of the MongoDB replica members"
  destination_path = "/agent/scripts/config_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mongodb_network_check" {
  name             = "mongodb_network_check"
  input_file       = "${path.module}/data/mongodb_network_check.sh"
  md5              = filemd5("${path.module}/data/mongodb_network_check.sh")
  description      = "Check the network connectivity between MongoDB replica members"
  destination_path = "/agent/scripts/mongodb_network_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_replica_set" {
  name             = "config_replica_set"
  input_file       = "${path.module}/data/config_replica_set.sh"
  md5              = filemd5("${path.module}/data/config_replica_set.sh")
  description      = "Verify the MongoDB configuration file for replica set configuration and ensure that it has correct replica set name, members list, and priority settings."
  destination_path = "/agent/scripts/config_replica_set.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_replica_set_members" {
  name             = "restart_replica_set_members"
  input_file       = "${path.module}/data/restart_replica_set_members.sh"
  md5              = filemd5("${path.module}/data/restart_replica_set_members.sh")
  description      = "Restart the MongoDB replica set members one by one to ensure that the latest data is replicated to all members and the issue is resolved."
  destination_path = "/agent/scripts/restart_replica_set_members.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_config_script" {
  name        = "invoke_config_script"
  description = "Define the IP addresses of the MongoDB replica members"
  command     = "`chmod +x /agent/scripts/config_script.sh && /agent/scripts/config_script.sh`"
  params      = []
  file_deps   = ["config_script"]
  enabled     = true
  depends_on  = [shoreline_file.config_script]
}

resource "shoreline_action" "invoke_mongodb_network_check" {
  name        = "invoke_mongodb_network_check"
  description = "Check the network connectivity between MongoDB replica members"
  command     = "`chmod +x /agent/scripts/mongodb_network_check.sh && /agent/scripts/mongodb_network_check.sh`"
  params      = []
  file_deps   = ["mongodb_network_check"]
  enabled     = true
  depends_on  = [shoreline_file.mongodb_network_check]
}

resource "shoreline_action" "invoke_config_replica_set" {
  name        = "invoke_config_replica_set"
  description = "Verify the MongoDB configuration file for replica set configuration and ensure that it has correct replica set name, members list, and priority settings."
  command     = "`chmod +x /agent/scripts/config_replica_set.sh && /agent/scripts/config_replica_set.sh`"
  params      = ["REPLICA_SET_MEMBERS","REPLICA_SET_NAME","REPLICA_SET_PRIORITIES"]
  file_deps   = ["config_replica_set"]
  enabled     = true
  depends_on  = [shoreline_file.config_replica_set]
}

resource "shoreline_action" "invoke_restart_replica_set_members" {
  name        = "invoke_restart_replica_set_members"
  description = "Restart the MongoDB replica set members one by one to ensure that the latest data is replicated to all members and the issue is resolved."
  command     = "`chmod +x /agent/scripts/restart_replica_set_members.sh && /agent/scripts/restart_replica_set_members.sh`"
  params      = []
  file_deps   = ["restart_replica_set_members"]
  enabled     = true
  depends_on  = [shoreline_file.restart_replica_set_members]
}

