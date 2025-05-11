output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "instance_name" {
  description = "The name of the compute instance"
  value       = google_compute_instance.vm.name
}

output "instance_external_ip" {
  description = "The external IP address of the compute instance"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
} 