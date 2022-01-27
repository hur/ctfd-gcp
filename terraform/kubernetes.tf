resource "google_container_cluster" "ctf_cluster" {
    name = "ctf-cluster"
    location = var.location
    project = google_project.ctf.project_id
    
    # We can't create a cluster with no node pool defined, but we want to only use
    # separately managed node pools. So we create the smallest possible default
    # node pool and immediately delete it.
    remove_default_node_pool = true
    initial_node_count       = 1
}

resource "google_container_node_pool" "node_pool" {
    name = "ctf-node-pool"
    location = var.location
    cluster = google_container_cluster.ctf_cluster.name

    node_count = 1
}
