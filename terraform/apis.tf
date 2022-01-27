variable "gcp_services_list" {
    type = list(string)
    default = [
        "appengineflex.googleapis.com",
        "compute.googleapis.com",
        "vpcaccess.googleapis.com",
        "redis.googleapis.com",
        "servicenetworking.googleapis.com",
        "sqladmin.googleapis.com",
        "serviceusage.googleapis.com"
    ]
}

resource "google_project_service" "compute_engine" {
    for_each = toset(var.gcp_services_list)
    project = google_project.ctf.project_id
    service = each.key
    disable_dependent_services = false
    disable_on_destroy = false
}
