locals {
  apis = toset(
    [
      "artifactregistry.googleapis.com",  # Artifact Registry is used to store docker images of the Twined services.
      "bigquery.googleapis.com",          # BigQuery provides the event store for Twined service events (questions, results, log messages etc.).
      "cloudfunctions.googleapis.com",    # Cloud Functions runs the event handler that directs Twined service events to the event store.
      "run.googleapis.com",               # Cloud Run runs the Twined services as docker containers.
      "iam.googleapis.com",               # IAM provides fine-grained authentication and authorisation to use and access the Twined services and input/output data.
      "pubsub.googleapis.com"             # Pub/Sub is the transport mechanism for Twined service events.
    ]
  )
}


resource "google_project_service" "google_apis" {
  for_each = local.apis
  service = each.key
  project = var.google_cloud_project_id
  disable_dependent_services = True
}
