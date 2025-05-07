locals {
  project_id = "my-playground-458212"
  location   = "asia-northeast1"
}

module "artifact_registry" {
  source  = "GoogleCloudPlatform/artifact-registry/google"
  version = "~> 0.3"

  project_id    = local.project_id
  location      = local.location
  format        = "DOCKER"
  repository_id = "docker-image-repo"
}

module "workload_identity" {
  source            = "../module/workload_identity"
  project_id        = local.project_id
  github_repo_owner = "yamaguchi-milkcocholate"
}
