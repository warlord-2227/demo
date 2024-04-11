variable "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  default     = "my-project-6242-308916"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  default     = "mast-bucket-che-abc-abc" # Ensure this is globally unique
}

variable "bucket_location" {
  description = "The location for the Google Cloud Storage bucket"
  default     = "us-central1"
}

variable "source_code_dir" {
  description = "The directory of the source code for the function"
  default     = "${path.module}/../services/ad_score/src/functions"
}

variable "output_zip_path" {
  description = "The output path for the zipped source code"
  default     = "${path.module}/function.zip"
}

variable "function_code_object_name" {
  description = "The object name for the function code in the bucket"
  default     = "functions"
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
  source_dir  = var.source_code_dir
  output_path = var.output_zip_path
}

resource "google_storage_bucket_object" "function_code" {
  name   = var.function_code_object_name
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}
