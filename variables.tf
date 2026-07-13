variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  default     = "semantic-reasoning-engine"
}

variable "bq_dataset_name" {
  description = "The name of the BigQuery dataset"
  type        = string
  default     = "semantic_graph_data"
}
