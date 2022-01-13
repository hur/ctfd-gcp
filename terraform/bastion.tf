# NO PUBLIC IP ADDRESS, ACCESS THROUGH IAP E.G. VIA gcloud compute ssh
/*
resource "google_compute_instance" "bastion" {
    name = "bastion"
    project = google_project.ctf.project_id
    machine_type = "f1-micro"
    zone = var.zone

    boot_disk {
        initialize_params {
          image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
        }
    }

    network_interface {
      subnetwork = google_compute_subnetwork.ctf_vpc_subnet1.self_link
    }

    metadata = {
        enable-oslogin = "TRUE"
    }

    tags = ["iap-access"]
    deletion_protection = false

    service_account {
      email = google_service_account.bastion_service_acct.email
      scopes = ["cloud-platform"]
    }
}

resource "google_service_account" "bastion_service_acct" {
  account_id = "bastion-serviceacct"
}

resource "google_project_iam_member" "bastion_serviceacct_sql" {
  project = google_project.ctf.project_id
  role = "roles/cloudsql.editor"
  member = "serviceAccount:${google_service_account.bastion_service_acct.email}"
}
*/