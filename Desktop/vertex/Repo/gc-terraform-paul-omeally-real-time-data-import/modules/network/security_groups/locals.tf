locals {
  service = basename(dirname(path.module))
}

locals {
  all_traffic_cidr = "0.0.0.0/0"
}

locals {
  intra_vpc_resources_cidr = "10.0.0.0/16"
}

#
#
#--- S E C U R I T Y   G R O U P S ---#

locals {
  security_groups = [
    {
      name = "gc-intra-vpc-resources-access-sg"
      description = "Allow access to resources within the vpc."
      vpc_id = var.vpc_id

      inbound_rules = []

      outbound_rules = [{
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [local.intra_vpc_resources_cidr]
      }]
    },
    {
      name = "gc-vertex-cloud-access-sg"
      description = "Allow access to external Vertex Cloud endpoints."
      vpc_id = var.vpc_id

      inbound_rules = []

      outbound_rules = [{
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [
          var.vertex_cloud_cidrs.client_profile_endpoint_cidr,
          var.vertex_cloud_cidrs.client_profile_endpoint_cidr_failover
        ]
      }]
    }
    ]
}