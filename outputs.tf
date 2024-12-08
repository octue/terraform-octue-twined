# - SRUID for each service revision (or just SUID?)

output "event_store" {
  description = "The full ID of the BigQuery table acting as the Twined services event store."
  value       = google_bigquery_table.service_event_table.table_id
}
