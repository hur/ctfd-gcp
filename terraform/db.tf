# https://cloud.google.com/sql/docs/mysql/private-ip
# VPC peering network 
# To use Cloud SQL instances in a VPC network with private IP, 
# you need to allocate IP address ranges to set up private services access for this VPC. 
resource "google_compute_global_address" "private_ip_address" {
    provider = google-beta
  
    name          = "private-ip-address"
    purpose       = "VPC_PEERING"
    address_type  = "INTERNAL"
    prefix_length = 16
    network       = google_compute_network.ctf_vpc.id
    depends_on = [google_compute_subnetwork.ctf_vpc_subnet1, google_vpc_access_connector.connector]
}

# Private service connection
resource "google_service_networking_connection" "private_vpc_connection" {
    provider = google-beta
    network = google_compute_network.ctf_vpc.id
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# mysql for ctfd
resource "google_sql_database" "ctfd_db" {
    name = "ctfd"
    instance = google_sql_database_instance.ctfd_db.name
    project = google_project.ctf.project_id

    charset = "utf8mb4" # CTFd uses this charset
}

resource "google_sql_database_instance" "ctfd_db" {
    provider = google-beta
    name = "ctfd-db-${random_id.db_name_suffix.hex}" # After a name is used, it cannot be reused for a week. This makes terraform destroy -> apply work better
    region = var.region
    database_version = "MYSQL_8_0"
    depends_on = [google_service_networking_connection.private_vpc_connection]
    settings {
        tier = "db-f1-micro" # TODO: pick tier
        disk_size = "10" # GB
        disk_type = "PD_SSD" # TODO: PD_SSD

        ip_configuration {
            ipv4_enabled = false # disable public ipv4 address
            private_network = google_compute_network.ctf_vpc.id # still has a private ipv4 address
        }
    }
}

resource "random_password" "db_user_password" {
  length           = 16
  special          = true
  override_special = "_%@!"
}

resource "google_sql_user" "db_user" {
    name = var.db_user_name
    project = google_project.ctf.project_id
    instance = google_sql_database_instance.ctfd_db.name
    password = random_password.db_user_password.result
}
