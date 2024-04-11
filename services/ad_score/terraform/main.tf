variable "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  default     = "my-project-6242-308916"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  default     = "mast-bucket-che-abc-abc"  # Ensure this is globally unique
}

variable "bucket_location" {
  description = "The location for the Google Cloud Storage bucket"
  default     = "us-central1"
}

locals {
  source_code_dir  = "${path.module}/../services/ad_score/src/functions"
  output_zip_path  = "${path.module}/function.zip"
  function_code_object_name = "functions"
}

resource "google_storage_bucket" "bucket" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.bucket_location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = local.source_code_dir
  output_path = local.output_zip_path
}

resource "google_storage_bucket_object" "function_code" {
  name   = local.function_code_object_name
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}
