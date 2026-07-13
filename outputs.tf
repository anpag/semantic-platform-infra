output "cloud_run_service_url" {
  description = "The URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.semantic_engine.uri
}

output "raw_graph_events_topic" {
  description = "The Pub/Sub topic for raw graph events"
  value       = google_pubsub_topic.raw_graph_events.id
}

output "inferred_graph_events_topic" {
  description = "The Pub/Sub topic for inferred graph events"
  value       = google_pubsub_topic.inferred_graph_events.id
}

output "bigquery_dataset_id" {
  description = "The BigQuery dataset ID"
  value       = google_bigquery_dataset.semantic_graph_data.id
}
