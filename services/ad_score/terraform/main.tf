variable "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  default     = "my-project-6242-308916"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  default     = "mast-bucket-che-abc-abcd"  
}

variable "bucket_location" {
  description = "The location for the Google Cloud Storage bucket"
  default     = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.bucket_location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}


resource "google_storage_bucket_object" "function_code" {
  name   = "function.zip"
  bucket = google_storage_bucket.bucket.name
  # Assuming the function.zip file is already created and available at the root of the Terraform directory
  source = "function.zip"
}

# Pub/Sub Topics
resource "google_pubsub_topic" "trigger_topic" {
  name = "pubsub-trigger-topic"
}

resource "google_pubsub_topic" "result_topic" {
  name = "pubsub-result-topic"
}

# Google Cloud Function
resource "google_cloudfunctions_function" "cloud_function" {
  name                  = "ad-score-function"
  description           = "A function triggered by Pub/Sub to process ad scores"
  runtime               = "python310"  
  available_memory_mb   = 1024
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_code.name
  entry_point           = "hello_pubsub"
  environment = "gen2"  

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.trigger_topic.id
  }

  environment_variables = {
    RESULT_TOPIC = google_pubsub_topic.result_topic.id
    BUCKET_NAME  = google_storage_bucket.bucket.name
  }

  project = var.project_id
  region  = var.bucket_location
}