locals {
  http_method = "POST"
}

locals {
  authorization ="CUSTOM"
}

locals {
  integration_http_method  = "PUT"
}

locals {
  api_name = "gc-real-time-invoice-reporting-api"
}
locals {
  description = "Secured, public-facing api for importing data for real-time invoice reporting."
}

locals {
  model_description = "Standard schema for invoice-data api response."
}
locals {
 content_type =  "application/json"
}

locals {
  model_name = "ResponseModel"

}


locals {
  api_role_name = "gc-api-gateway-role"
}

locals {
  # By convention, name of service matches the name of the service (module's) root directory.
  service = "${basename(path.root)}"
}
