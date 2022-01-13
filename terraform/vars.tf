variable db_user_password {
    type = string
    sensitive = true
}

variable db_user_name {
    type = string
    default = "ctfd"
}

variable region {
    type = string
    default = "europe-west2"
}

variable zone {
    type = string
    default = "europe-west2-a"
}

variable project_name {
    type = string
}

variable project_id {
    type = string
}

variable bucket_location {
    type = string
    default = "EU"
}

variable main_subnet_cidr {
    type = string
}

variable access_connector_cidr {
    type = string
}

variable ctfd_instances {
    type = number
}
