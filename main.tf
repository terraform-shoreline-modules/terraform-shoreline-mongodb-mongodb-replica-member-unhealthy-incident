terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mongodb_replica_member_unhealthy_incident" {
  source    = "./modules/mongodb_replica_member_unhealthy_incident"

  providers = {
    shoreline = shoreline
  }
}