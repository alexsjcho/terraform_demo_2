# Create VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.subnet_region
  network       = google_compute_network.vpc.id
}

# Create Firewall Rules
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = var.allowed_cidrs
}

# Create Compute Instance
resource "google_compute_instance" "vm" {
  name         = "${var.network_name}-vm"
  machine_type = var.machine_type
  zone         = "${var.subnet_region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/${var.image_family}"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      // Ephemeral public IP
    }
  }

  labels = {
    "environment" = "demo"
    "managed-by"  = "terraform"
    "project"     = "terraform-multicloud"
  }
} 