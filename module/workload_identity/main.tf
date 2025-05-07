# github-actionsからDockerイメージをpushするためのサービスアカウント
resource "google_service_account" "main" {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
  description  = "GitHub Actions 用 Service Account"
  project      = var.project_id
}

# サービスアカウントにArtifact Registoryの書き込み権限を付与
resource "google_project_iam_member" "artifact_registry_access" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:github-actions-sa@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_iam_workload_identity_pool" "main" {
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "GitHub Actions 用 Workload Identity Pool"
  disabled                  = false
  project                   = var.project_id
}

resource "google_iam_workload_identity_pool_provider" "main" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-pool-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "GitHub Actions 用 Workload Identity Poolプロバイダ"
  disabled                           = false
  attribute_condition                = "assertion.repository_owner == \"${var.github_repo_owner}\""
  attribute_mapping = {
    "google.subject" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  project = var.project_id
}

