output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "sql_instance_name" {
  value = google_sql_database_instance.db_instance.name
}
