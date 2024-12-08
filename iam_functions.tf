resource "google_cloud_run_service_iam_member" "function_invoker" {
  service    = google_cloudfunctions2_function.event_handler.name
  location   = google_cloudfunctions2_function.event_handler.location
  role       = "roles/run.invoker"
  member     = "allUsers"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
