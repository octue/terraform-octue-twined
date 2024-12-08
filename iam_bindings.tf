locals {
  admin_service_account_emails = [
    for account in google_service_account.admin_accounts : "serviceAccount:${account.email}"
  ]

  all_service_account_emails = concat(
    ["serviceAccount:${google_service_account.github_actions_service_account.email}"],
    local.admin_service_account_emails
  )

  roles_all = toset(
    [
      "roles/iam.serviceAccountUser",
      "roles/pubsub.editor",
      "roles/errorreporting.writer"
    ]
  )

  roles_github_actions = toset(
    [
      # Allows the GHA to call "namespaces get" for Cloud Run to determine the resulting run URLs of the services.
      # This should also allow a service to get its own name by using:
      #   https://stackoverflow.com/questions/65628822/google-cloud-run-can-a-service-know-its-own-url/65634104#65634104
      "roles/run.developer",
      "roles/artifactregistry.writer",
      "roles/storage.objectAdmin"
    ]
  )

  roles_admin_accounts = toset(
    [
      "roles/bigquery.dataViewer",
      "roles/bigquery.jobUser",
      "roles/bigquery.readSessionUser",
    ]
  )
}


resource "google_project_iam_binding" "iam_all" {
  for_each = local.roles_all
  project = var.google_cloud_project_id
  role    = each.key
  members = local.all_service_account_emails
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "iam_admin_accounts" {
  for_each = local.roles_admin_accounts
  project    = var.google_cloud_project_id
  role       = each.key
  members    = local.admin_service_account_emails
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "iam_github_actions" {
  for_each = local.roles_github_actions
  project = var.google_cloud_project_id
  role    = each.key
  members = ["serviceAccount:${google_service_account.github_actions_service_account.email}"]
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "bigquery_dataeditor" {
  project = var.google_cloud_project_id
  role    = "roles/bigquery.dataEditor"
  members = [
    "serviceAccount:service-${var.google_cloud_project_number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
