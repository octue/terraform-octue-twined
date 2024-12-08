variable "google_cloud_project_id" {
  type = string
}

variable "google_cloud_project_number" {
  type = string
}

variable "google_cloud_region" {
  type = string
}

variable "github_organisation" {
  type = string
}

variable "twined_service_namespace" {
  type = string
}

variable "service_account_names" {
  type = set(string)
}

variable "google_cloud_credentials_file" {
  type    = string
  default = "gcp-credentials.json"
}

variable "maximum_event_handler_instances" {
  type    = number
  default = 100
}

variable "deletion_protection" {
  type    = bool
  default = true
  description = "Apply deletion protection to the event store."
}
