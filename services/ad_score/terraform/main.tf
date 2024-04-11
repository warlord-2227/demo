variable "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  default     = "my-project-6242-308916"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  default     = "mast-bucket-che-abc-abcd"  # Ensure this is globally unique
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