terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# IAM Service Accounts
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
  description  = "Service account for Cloud Run semantic engine"
}

resource "google_service_account" "pubsub_sa" {
  account_id   = "pubsub-sa"
  display_name = "Pub/Sub Service Account"
  description  = "Service account for Pub/Sub publishing/subscribing"
}

# Grant Cloud Run SA permissions
resource "google_project_iam_member" "cloud_run_bq_data_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_project_iam_member" "cloud_run_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Pub/Sub Topics
resource "google_pubsub_topic" "raw_graph_events" {
  name = "raw-graph-events"
}

resource "google_pubsub_topic" "inferred_graph_events" {
  name = "inferred-graph-events"
}

# BigQuery Dataset
resource "google_bigquery_dataset" "semantic_graph_data" {
  dataset_id                  = var.bq_dataset_name
  friendly_name               = "Semantic Graph Data"
  description                 = "Dataset for storing semantic graph events"
  location                    = "US"
  delete_contents_on_destroy  = false
}

# Cloud Run Service (Boilerplate)
resource "google_cloud_run_v2_service" "semantic_engine" {
  name     = var.cloud_run_service_name
  location = var.region
  
  template {
    service_account = google_service_account.cloud_run_sa.email
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # Placeholder image
      
      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "RAW_TOPIC"
        value = google_pubsub_topic.raw_graph_events.name
      }
      env {
        name  = "INFERRED_TOPIC"
        value = google_pubsub_topic.inferred_graph_events.name
      }
      env {
        name  = "BQ_DATASET"
        value = google_bigquery_dataset.semantic_graph_data.dataset_id
      }
    }
  }
}
