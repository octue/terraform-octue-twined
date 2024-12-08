resource "google_artifact_registry_repository" "service_docker_images" {
  repository_id = "${var.twined_service_namespace}-octue-twined-services"
  description   = "Docker image repository for Octue Twined services"
  format        = "DOCKER"
  location      = var.google_cloud_region
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}
