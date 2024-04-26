resource "fastly_service_vcl" "mwebler_railway_test" { 
 name = "mwebler-railway-test"

  domain {
    name = "mwebler-railway-test4.global.ssl.fastly.net"
  }

  backend {
    name     = "app-1 backend"
    
    address = railway_service_domain.app1.domain
    port = 443
    use_ssl = true
    ssl_cert_hostname = railway_service_domain.app1.domain
    override_host = railway_service_domain.app1.domain
    
    auto_loadbalance = true
    weight = 50
    
    healthcheck = "app1-healthcheck"
  }

  backend {
    name     = "app-2 backend"
    
    address = railway_service_domain.app2.domain
    port = 443
    use_ssl = true
    ssl_cert_hostname = railway_service_domain.app2.domain
    override_host = railway_service_domain.app2.domain

    auto_loadbalance = true
    weight = 50

    healthcheck = "app2-healthcheck"
  }

  cache_setting {
    name = "cache-specific-route"
    action = "cache"
    ttl = 60
    cache_condition = "cache-specific-route" 
  }

  condition {
    name = "cache-specific-route"
    statement = "beresp.status == 200 && req.url == \"/cache-this\""
    type = "CACHE"
  }

  cache_setting {
    name = "no-cache"
    action = "pass"
    ttl = 0
    cache_condition = "no-cache" 
  }

  condition {
    name = "no-cache"
    statement = "req.url != \"/cache-this\""
    type = "CACHE"
  }

  healthcheck {
    name = "app1-healthcheck"
    method = "GET"
    host = railway_service_domain.app1.domain
    path = "/status"
    expected_response = 200
    initial = 5
    threshold = 3
    check_interval = 5000
  }

  healthcheck {
    name = "app2-healthcheck"
    method = "GET"
    host = railway_service_domain.app2.domain
    path = "/status"
    expected_response = 200
    initial = 5
    threshold = 3
    check_interval = 5000 //ms
  }

  force_destroy = true
  depends_on = [ railway_service_domain.app1, railway_service_domain.app2 ]
}

output "active" {
  value = fastly_service_vcl.mwebler_railway_test.active_version
}