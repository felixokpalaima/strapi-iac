resource "google_project_service" "cloudresourcemanager_api" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "serviceusage_api" {
  project = var.project_id
  service = "serviceusage.googleapis.com"
  depends_on = [google_project_service.cloudresourcemanager_api]
}

resource "google_project_service" "secretmanager_api" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
}

resource "google_project_service" "cloudbuild_api" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
}

resource "google_project_service" "servicenetworking_api" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
}

resource "google_project_service" "cloudsql_admin_api" {
  project   = var.project_id
  service   = "sqladmin.googleapis.com"
  depends_on = [google_project_service.cloudresourcemanager_api]
}

resource "google_project_service" "compute_engine_api" {
  project = var.project_id
  service = "compute.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
}

resource "google_project_service" "cloudlogging_api" {
  project = var.project_id
  service = "logging.googleapis.com"

  disable_dependent_services = true
#   depends_on = [
#     google_project_service.cloudresourcemanager_api
#   ]
}

resource "google_project_service" "cloudrun_admin_api" {
  project = var.project_id
  service = "cloudrun.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
}

resource "google_project_service" "iam_api" {
  project = var.project_id
  service = "iam.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
}

resource "google_project_service" "cloud_sql" {
  provider                   = google-beta
  project                    = var.project_id
  service                    = "sql-component.googleapis.com"
  depends_on = [
    google_project_service.cloudresourcemanager_api
  ]
  disable_dependent_services = true
}
