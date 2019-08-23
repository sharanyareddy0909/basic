locals {
  service = basename(dirname(path.module))
}

locals {
  private_count = min(2,length(data.aws_availability_zones.availability_zones.names))
}

locals {
  private_route_count = var.az_ngw_count
}

locals {
  subnet_type = "private"
}