provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "google_compute_instance_template" "web_template" {
  name_prefix = "apache-template-"
  machine_type = var.machine_type
  zone   = var.zone

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {} # for external IP
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt update
    sudo apt install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "Hello from MIG instance" > /var/www/html/index.html
  EOT

  tags = ["web"]
}

resource "google_compute_instance_group_manager" "web_mig" {
  name               = "apache-mig"
  base_instance_name = "apache-instance"
  region             = var.region
  version {
    instance_template = google_compute_instance_template.web_template.self_link
  }
  target_size = var.instance_count
}

resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
