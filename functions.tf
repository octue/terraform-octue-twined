resource "google_cloudfunctions2_function" "event_handler" {
  name        = "${var.twined_service_namespace}-octue-twined-service-event-handler"
  description = "A function for handling events from Octue Twined services."
  location    = var.google_cloud_region

  build_config {
    runtime     = "python312"
    entry_point = "store_pub_sub_event_in_bigquery"
    source {
      storage_source {
        bucket = "twined-gcp"
        object = "event_handler/0.6.1.zip"
      }
    }
  }

  service_config {
    max_instance_count = var.maximum_event_handler_instances
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      BIGQUERY_EVENTS_TABLE = "${google_bigquery_dataset.service_event_dataset.dataset_id}.${google_bigquery_table.service_event_table.table_id}"
    }
  }

  event_trigger {
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.services_topic.id
    trigger_region = var.google_cloud_region
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}
