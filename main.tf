resource "google_sql_database_instance" "db_instance" {
  name             = "strapi"
  region           = "europe-west4"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-custom-2-8192"
    availability_type = "ZONAL"

    disk_autoresize = true
    disk_size       = 10
    disk_type       = "PD_SSD"

    backup_configuration {
      enabled    = true
      start_time = "02:00"
    }
    maintenance_window {
      day  = 1
      hour = 2
    }
    location_preference {
      zone = "europe-west4-a"
    }

    database_flags {
      name  = "max_connections"
      value = "500"
    }
  }
  deletion_protection = false

  depends_on = [google_project_service.cloudsql_admin_api]
}

resource "google_sql_database" "database" {
  name     = "strapi"
  instance = google_sql_database_instance.db_instance.name
}

resource "google_sql_user" "user" {
  name     = "strapi"
  instance = google_sql_database_instance.db_instance.name
  password = var.database_password
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-strapi"
  location = "EU"

  uniform_bucket_level_access = true
}

resource "google_cloud_run_v2_service" "cloudrun" {
  name     = "strapi-cloudrun"
  location = "us-central1"

  template {
    containers {
      image = "gcr.io/${var.project_id}/strapi-image:latest"
    }

    service_account = "serviceAccount@${var.project_id}.iam.gserviceaccount.com"
  }
}

resource "google_storage_bucket_iam_binding" "default_service_account_admin" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${var.project_id}-compute@developer.gserviceaccount.com"
  ]
  depends_on = [google_cloud_run_v2_service.cloudrun]
}

resource "google_storage_bucket_iam_binding" "default_service_account_writer" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${var.project_id}-compute@developer.gserviceaccount.com"
  ]
  depends_on = [google_cloud_run_v2_service.cloudrun]
}

resource "google_service_account" "default" {
  account_id   = "default"
  display_name = "Default Service Account"
  depends_on   = [google_cloud_run_v2_service.cloudrun]
}

resource "google_project_iam_binding" "default" {
  project = var.project_id
  role    = "roles/editor"
  members = [
    "serviceAccount:${var.project_id}-compute@developer.gserviceaccount.com",
  ]
  depends_on = [google_cloud_run_v2_service.cloudrun]
}

resource "google_project_iam_binding" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${var.project_id}-compute@developer.gserviceaccount.com",
  ]
  depends_on = [google_cloud_run_v2_service.cloudrun]
}
