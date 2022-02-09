# cache for ctfd
resource "google_redis_instance" "ctfd_cache" {
    name = "ctfd-cache"
    tier = "BASIC"
    memory_size_gb = 1
    region = var.region

    connect_mode = "DIRECT_PEERING"
    authorized_network = google_compute_network.ctf_vpc.id
}
