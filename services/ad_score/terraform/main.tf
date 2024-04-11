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

locals {
  source_code_dir  = "../src/functions"
  output_zip_path  = "function.zip"
  function_code_object_name = "functions"
}

resource "google_storage_bucket" "bucket" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.bucket_location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "null_resource" "list_directory" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      ls -la 
      cd ..
      ls -la
    EOT
  }
}


