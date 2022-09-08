terraform {
  backend "gcs" {
    bucket  = "terraform-state-file-7482"
    prefix  = "github/gcp-action"
  }
}

provider "google" {
  credentials = file("credentials.json")
  region      = "us-central1"
  project     = var.project
}

variable "project" {}