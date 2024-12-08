resource "google_bigquery_dataset" "service_event_dataset" {
  dataset_id  = "${var.twined_service_namespace}_octue_twined"
  description = "A dataset for storing Octue Twined service events."
  location    = var.google_cloud_region
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}

resource "google_bigquery_table" "service_event_table" {
  table_id   = "service-events"
  dataset_id = google_bigquery_dataset.service_event_dataset.dataset_id
  clustering = ["sender", "question_uuid"]
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
  deletion_protection = var.deletion_protection

  schema = <<EOF
[
  {
    "name": "datetime",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "uuid",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "kind",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "event",
    "type": "JSON",
    "mode": "REQUIRED"
  },
  {
    "name": "other_attributes",
    "type": "JSON",
    "mode": "REQUIRED"
  },
  {
    "name": "originator",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "parent",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "sender",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "sender_type",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "sender_sdk_version",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "recipient",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "originator_question_uuid",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "parent_question_uuid",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "question_uuid",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "backend",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "backend_metadata",
    "type": "JSON",
    "mode": "REQUIRED"
  }
]
EOF
}
