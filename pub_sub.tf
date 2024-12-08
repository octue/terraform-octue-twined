resource "google_pubsub_topic" "services_topic" {
  name = "octue.services"
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}
