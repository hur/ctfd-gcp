# App Engine applications cannot be deleted once they're created; 
# you have to delete the entire project to delete the application. 
# Terraform will report the application has been successfully deleted; 
# this is a limitation of Terraform, and will go away in the future. 
# Terraform is not able to delete App Engine applications.
resource "google_app_engine_application" "ctfd" {
    project = google_project.ctf.project_id
    location_id = var.region
}

resource "google_project_iam_member" "gae_api" {
  project = google_project.ctf.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${google_project.ctf.number}@gae-api-prod.google.com.iam.gserviceaccount.com"
}

resource "google_app_engine_flexible_app_version" "ctfd" {
    version_id = "v2"
    project = google_project_iam_member.gae_api.project
    service = "default"
    runtime = "custom"

    deployment {
        files {
            name = google_storage_bucket_object.dockerfile.name
            source_url = "https://storage.googleapis.com/${google_storage_bucket.ctfd_files.name}/${google_storage_bucket_object.dockerfile.name}"
        }
        files {
            name = google_storage_bucket_object.patch.name
            source_url = "https://storage.googleapis.com/${google_storage_bucket.ctfd_files.name}/${google_storage_bucket_object.patch.name}"
        }
    }


    network {
        name = google_compute_network.ctf_vpc.name 
        subnetwork = google_compute_subnetwork.ctf_vpc_subnet1.name
    }

    env_variables = {
        REDIS_URL = "redis://${google_redis_instance.ctfd_cache.host}:6379"
        DATABASE_URL =  "mysql+pymysql://${google_sql_user.db_user.name}:${google_sql_user.db_user.password}@${google_sql_database_instance.ctfd_db.private_ip_address}:3306/ctfd"
        UPLOAD_PROVIDER = "s3"
        AWS_ACCESS_KEY_ID = google_storage_hmac_key.interop_key.access_id
        AWS_SECRET_ACCESS_KEY = google_storage_hmac_key.interop_key.secret
        AWS_S3_BUCKET = google_storage_bucket.challenge_files.name
        AWS_S3_ENDPOINT_URL = "https://storage.googleapis.com"
    }

    readiness_check {
        path = "/themes/core/static/css/main.dev.css" # ctfd 302's before it's setup on all urls except /themes/*, so need to use this url for proper 200 code
    }

    liveness_check {
        path = "/themes/core/static/css/main.dev.css"
    }

    manual_scaling {
        instances = var.ctfd_instances
    }

    delete_service_on_destroy = true
}
