provider "railway" {}

resource "railway_project" "mwebler" {
  name = "mwebler"
}

resource "railway_service" "app1" {
  name       = "app-1"
  project_id = railway_project.mwebler.id

  config_path = "/infrastructure/runtimes/app-1/railway.json"
  
  root_directory = "/app"
  source_repo = "mwebler/railway-test"
  source_repo_branch = "main"
}

resource "railway_service" "app2" {
  name       = "app-2"
  project_id = railway_project.mwebler.id

  config_path = "/infrastructure/runtimes/app-2/railway.json"
  
  root_directory = "/app"
  source_repo = "mwebler/railway-test"
  source_repo_branch = "main"
}

resource "railway_service_domain" "app1" {
  subdomain      = "mwebler-app1"
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app1.id
}

resource "railway_service_domain" "app2" {
  subdomain      = "mwebler-app2"
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app2.id
}

resource "railway_variable" "grafana_cloud_key1" {
  name           = "GRAFANA_CLOUD_KEY"
  value          = var.grafana_cloud_key
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app1.id
}

resource "railway_variable" "grafana_prometheus_username1" {
  name           = "GRAFANA_PROMETHEUS_USERNAME"
  value          = var.grafana_prometheus_username
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app1.id
}

resource "railway_variable" "grafana_loki_username1" {
  name           = "GRAFANA_LOKI_USERNAME"
  value          = var.grafana_loki_username
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app1.id
}

resource "railway_variable" "grafana_cloud_key2" {
  name           = "GRAFANA_CLOUD_KEY"
  value          = var.grafana_cloud_key
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app2.id
}

resource "railway_variable" "grafana_prometheus_username2" {
  name           = "GRAFANA_PROMETHEUS_USERNAME"
  value          = var.grafana_prometheus_username
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app2.id
}

resource "railway_variable" "grafana_loki_username2" {
  name           = "GRAFANA_LOKI_USERNAME"
  value          = var.grafana_loki_username
  environment_id = railway_project.mwebler.default_environment.id
  service_id     = railway_service.app2.id
}

