terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "5.8.0"
    }
    railway = {
        source  = "terraform-community-providers/railway"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

variable "grafana_cloud_key" {
  type = string
}

variable "grafana_loki_username" {
  type = string
}

variable "grafana_prometheus_username" {
  type = string
}
