## compute zones
data "google_compute_zones" "available_zones" {
  project = var.project
  region  = var.region
}

resource "google_container_cluster" "workload_cluster" {
  name               = "terragoat-${var.environment}-cluster"
  logging_service    = "none"
  location           = var.region
  initial_node_count = 1
  enable_legacy_abac       = true
  monitoring_service       = "none"
  remove_default_node_pool = true
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.public-subnetwork.name
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
    }
  }
}


resource "google_container_node_pool" "custom_node_pool" {
  cluster  = google_container_cluster.workload_cluster.name
  location = var.region
  node_config {
#  image_type = "Ubuntu"
  machine_type = "e2-small"
  tags         = ["gke-node", "${var.environment}-gke"]
  metadata = {
      disable-legacy-endpoints = "true"
    }  
  oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

