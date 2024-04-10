resource "google_storage_bucket" "bucket" {
  #name                        = "mast-${var.service}-meta-${var.environment}" # Every bucket name must be globally unique
  name = "mast-bucket-che-abc"
  project = "my-project-6242-308916"
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}


