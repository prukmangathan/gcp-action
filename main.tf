# Cloud function service account
resource "google_service_account" "functions" {
  project      = "dazzling-matrix-361211"
  account_id   = "cfsa-7482"
  display_name = "cfsa-7482"
}

# Pub/Sub for Cloud Scheduler
# Pub/Sub Topic
resource "google_pubsub_topic" "cloud_scheduler_topic" {
  name = "cloud_scheduler_topic"
}

# Pub/Sub Subscription
resource "google_pubsub_subscription" "cloud_scheduler_sub" {
  name  = "cloud_scheduler_subscription"
  topic = google_pubsub_topic.cloud_scheduler_topic.name
}

# Cloud Scheduler
resource "google_cloud_scheduler_job" "trigger_cloud_function" {
  name     = "trigger_cloud_function"
  schedule = "*/10 * * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.cloud_scheduler_topic.id
    data       = base64encode("{\"function_name\":\"sample_function\", \"table_name\":\"names_2014\"}")
  }
}

# Cloud function source code bucket
resource "google_storage_bucket" "cloud_function_code_backup" {
  name     = "gcp-cloud-functions-code-7482"
  location = "US"
}

# Uploading the code
resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.cloud_function_code_backup.name
  source = "${path.module}/data/code/index.zip"
}

# Cloud function
resource "google_cloudfunctions_function" "function" {
  name                  = "sample_function"
  runtime               = "python37"
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.cloud_function_code_backup.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = "hello_gcp"
  ingress_settings      = "ALLOW_ALL"
  service_account_email = google_service_account.functions.email
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.cloud_scheduler_topic.id
  }
  depends_on = [google_cloud_scheduler_job.trigger_cloud_function]
}
