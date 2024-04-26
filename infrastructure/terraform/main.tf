terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "5.8.0"
    }
    railway = {
        source  = "terraform-community-providers/railway"
    }
  }
}
