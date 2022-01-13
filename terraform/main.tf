terraform {
    required_providers {
      google = {
           version = "3.84.0" # Pin to 3.84.0 until the following issue is fixed: https://github.com/hashicorp/terraform-provider-google/issues/10185
      }
      google-beta = {
           version = "3.84.0" # Pin to 3.84.0 until the following issue is fixed: https://github.com/hashicorp/terraform-provider-google/issues/10185
      }
    }
}

provider "google" {
    project = var.project_name
    region  = var.region
    zone    = var.zone
}

provider "google-beta" {
    project = var.project_name
    region = var.region
    zone = var.zone
}

data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open = true
}

resource "google_project" "pwned" {
    name = var.project_name
    project_id = var.project_id

    billing_account = data.google_billing_account.acct.id

    auto_create_network = "false"
}

