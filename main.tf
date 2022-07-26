terraform {
  backend "gcs" {}
}

provider "google" {
  #credentials = file("model-hexagon-351804-6b3b6f158f1e.json")
  region      = "us-central1"
  project     = var.project
}

resource "google_storage_bucket" "static-site" {
  name          = "test-my-testing-bucket-for-testing"
  location      = "US"
  force_destroy = true
}

resource "google_compute_disk" "default" {
  name  = "test-disk"
  zone  = "us-central1-a"
  size  = 10
}

variable "project" {
  type = string
  default = ""
}