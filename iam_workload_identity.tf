resource "google_iam_workload_identity_pool" "github_actions_pool" {
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "github-actions-pool"
  project                   = var.google_cloud_project_id
  depends_on                = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_iam_workload_identity_pool_provider" "github_actions_provider" {
  workload_identity_pool_id          = "github-actions-pool"
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "Github Actions Provider"
  project                            = var.google_cloud_project_number
  depends_on                         = [time_sleep.wait_for_google_apis_to_enable]

  attribute_condition = "attribute.repository_owner==\"${var.github_organisation}\""

  attribute_mapping = {
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "google.subject"             = "assertion.sub"
  }

  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}


data "google_iam_policy" "workload_identity_pool_policy" {
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = [
      "principalSet://iam.googleapis.com/projects/${var.google_cloud_project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id}/attribute.repository_owner/${var.github_organisation}"
    ]
  }
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


# Allow a machine under Workload Identity Federation to act as the given service account.
resource "google_service_account_iam_policy" "workload_identity_service_account_policy" {
  policy_data        = data.google_iam_policy.workload_identity_pool_policy.policy_data
  service_account_id = google_service_account.github_actions_service_account.name
  depends_on         = [time_sleep.wait_for_google_apis_to_enable]
}
