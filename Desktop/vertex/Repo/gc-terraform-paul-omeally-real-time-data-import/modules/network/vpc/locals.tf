locals {
  # By convention, name of service matches the name of the service (module's) root directory.
  service = basename(dirname(path.module))
}

locals {
  vpc_name = "${title(var.environment_type)} Environment VPC"
}
