resource "google_compute_network" "ctf_vpc" {
    name = "ctf-vpc"
    project = google_project.ctf.project_id
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ctf_vpc_subnet1" {
    name = "ctf-vpc-subnet1"
    ip_cidr_range = var.main_subnet_cidr
    region = var.region
    network = google_compute_network.ctf_vpc.id
    private_ip_google_access = true
}

resource "google_vpc_access_connector" "connector" {
    provider = google-beta
    region = var.region
    project = google_project.ctf.name
    name = "vpcconn"
    network = google_compute_network.ctf_vpc.name
    ip_cidr_range = var.access_connector_cidr
}

### FIREWALL RULES 

#resource "google_compute_firewall" "ctf_vpc_fw_allow_ssh" {
#    project = google_project.ctf.name
#    name = "${google_compute_network.ctf_vpc.name}-allow-ssh"
#    network = google_compute_network.ctf_vpc.name
#    description = "Allow SSH connections to machines in the VPC"
#
#    allow {
#        protocol = "tcp"
#        ports = ["22"]
#    }
#
#    source_ranges = ["0.0.0.0/0"]
#}

#resource "google_compute_firewall" "ctf_vpc_fw_allow_icmp" {
#    project = google_project.ctf.name
#    name = "${google_compute_network.ctf_vpc.name}-allow-icmp"
#    network = google_compute_network.ctf_vpc.name
#    description = "Allow ICMP packets to machines in the VPC"
#
#   allow {
#        protocol = "icmp"
#    }
#
#    source_ranges = ["0.0.0.0/0"]
#}

/*
resource "google_compute_firewall" "ctf_vpc_fw_allow_iap_ssh_ingress" {
    project = google_project.ctf.name
    name = "${google_compute_network.ctf_vpc.name}-allow-iap-ssh-ingress"
    network = google_compute_network.ctf_vpc.name
    
    direction = "INGRESS"
    source_ranges = ["35.235.240.0/20"]
    #target_tags = ["iap-access"]
    
    allow {
        protocol = "tcp"
        ports = ["22"]
    }
}
*/