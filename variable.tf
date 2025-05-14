variable "gcp_credentials_file" {
  description = "Path to the GCP service account key JSON file"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "machine_type" {
  description = "GCE instance machine type"
  type        = string
  default     = "e2-medium"
}

variable "source_image" {
  description = "Source image for the instance template"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "instance_count" {
  description = "Number of instances in MIG"
  type        = number
  default     = 2
}
