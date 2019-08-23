locals {
  service = basename(dirname(path.module))
}

locals {
  public_count = min(2,length(data.aws_availability_zones.availability_zones.names))
}

locals {
  public_nat_gateways_count = var.nat_gateway_enabled == "true" ? local.public_count : 0
}


locals {
  subnet_type = "public"
}