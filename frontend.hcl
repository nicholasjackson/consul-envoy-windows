service {
  name = "frontend"
  id = "frontend-1"
  port = 8500
  tags = ["v1"]

  connect { 
    sidecar_service {
      proxy {
        upstreams {
          destination_name = "backend"
          local_bind_address = "127.0.0.1"
          local_bind_port = 9091
        }
      }
    }
  }
}