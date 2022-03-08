# S3-like bucket for hosting chall files
resource "google_storage_bucket" "challenge_files" {
    name = "${google_project.ctf.name}-chall-files"
    project = google_project.ctf.project_id
    location = var.bucket_location
    force_destroy = true
}

# Enable access key and secret to use with CTFd
resource "google_service_account" "interop_account" {
    account_id = "interop"
    project = google_project.ctf.project_id
}

resource "google_storage_hmac_key" "interop_key" {
    service_account_email = google_service_account.interop_account.email
}

resource "google_storage_bucket_iam_member" "interop_iam" {
    bucket = google_storage_bucket.challenge_files.name
    role = "roles/storage.objectAdmin"
    member = "serviceAccount:${google_service_account.interop_account.email}"
}


#resource "google_storage_bucket_iam_member" "public" {
#    bucket = google_storage_bucket.challenge_files.name
#    role = "roles/storage.legacyObjectReader"
#    member = "allUsers"
#}

# S3-like bucket for ctfd deployment
resource "google_storage_bucket" "ctfd_files" {
    name = "${google_project.ctf.name}-ctfd-files"
    project = google_project.ctf.project_id
    location = var.bucket_location
    force_destroy = true
}

#resource "google_storage_bucket_object" "app_yaml" {
#    name = "app.yaml"
#    bucket = google_storage_bucket.ctfd_files.name
#    source = "../app_engine/app.yaml"
#}

resource "google_storage_bucket_object" "dockerfile" {
    name = "Dockerfile"
    bucket = google_storage_bucket.ctfd_files.name
    source = "../app_engine/Dockerfile"
}

resource "google_storage_bucket_object" "patch" {
    name = "patch.txt"
    bucket = google_storage_bucket.ctfd_files.name
    source = "../app_engine/patch.txt"
}