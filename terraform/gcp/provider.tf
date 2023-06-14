provider "google" {
  credentials = file(var.credentials_path)
  project = var.project
  region  = var.region
}


terraform {
  backend "gcs" {
    credentials = var.credentials_path
    prefix      = "terragoat/${var.environment}"
  }
}

 
#module "bridgecrew-read" {
#    source = "bridgecrewio/bridgecrew-gcp-read-only/google"
#    org_name = "infracloud4446"
#    bridgecrew_token = "88647a83-7a55-4a50-867d-45843c1ac4c6"
#}
