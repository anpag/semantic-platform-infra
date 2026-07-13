# Semantic Platform Infrastructure

This repository contains the Terraform definitions for the infrastructure behind the Semantic Platform.

## Orchestration Overview

The Semantic Platform relies on an event-driven architecture hosted on Google Cloud Platform:

1. **Pub/Sub Topics**:
   - `raw-graph-events`: Ingests initial, unprocessed events regarding the semantic graph.
   - `inferred-graph-events`: Distributes newly derived relations and insights after reasoning.

2. **Cloud Run Service**:
   - Hosts the Semantic Reasoning Engine.
   - Listens to or pulls from the `raw-graph-events` topic.
   - Processes events and publishes newly inferred facts to `inferred-graph-events`.
   - Runs securely under its own dedicated Service Account (`cloud-run-sa`) with strictly scoped IAM privileges.

3. **BigQuery**:
   - A dataset `semantic_graph_data` acts as the analytical warehouse, persisting all semantic events for auditing and deep analysis.

## Infrastructure Setup

### Prerequisites
- Terraform ~> 5.0
- Google Cloud SDK (`gcloud`) authenticated to your project.

### Deployment
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the deployment:
   ```bash
   terraform plan -var="project_id=YOUR_PROJECT_ID"
   ```
3. Apply the configuration:
   ```bash
   terraform apply -var="project_id=YOUR_PROJECT_ID"
   ```
