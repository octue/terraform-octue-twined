locals {
  apis = toset(
    [
      "artifactregistry.googleapis.com",      # Artifact Registry is used to store docker images of the Twined services.
      "bigquery.googleapis.com",              # BigQuery provides the event store for Twined service events (questions, results, log messages etc.).
      "cloudbuild.googleapis.com",
      "cloudfunctions.googleapis.com",        # Cloud Functions runs the event handler that directs Twined service events to the event store.
      "eventarc.googleapis.com",              # Eventarc is used to communicate with the Cloud Function via Pub/Sub.
      "iam.googleapis.com",                   # IAM provides fine-grained authentication and authorisation to use and access the Twined services and input/output data.
      "pubsub.googleapis.com",                # Pub/Sub is the transport mechanism for Twined service events.
      "run.googleapis.com"                    # Cloud Run runs the Twined services as docker containers.
    ]
  )
}


resource "google_project_service" "google_apis" {
  for_each = local.apis
  service = each.key
  disable_dependent_services = true
  project = var.google_cloud_project_id
}


resource "time_sleep" "wait_for_google_apis_to_enable" {
  depends_on = [google_project_service.google_apis]
  create_duration = "1m"
}
