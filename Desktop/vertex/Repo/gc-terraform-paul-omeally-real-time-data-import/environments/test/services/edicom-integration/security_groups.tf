 # Security Groups to support EDICOM adapter functionality
 resource "aws_security_group" "edicom-outbound-security-group" {

  vpc_id = "${data.aws_vpc.selected.id}"
  name = "${var.edicom_outbound_security_group_name}"
  description = "Global Compliance EDICOM Adapter Port Rules (see ASP/EDI Framework documentation)"
  # No inbound/ingress rules required
  #ingress {
  #  from_port       = 5985
  #  to_port         = 5986
  #  protocol        = "tcp"
  #  cidr_blocks     = ["${var.vpc_cidr}"]
  #}

  # Automatic EDICOM adapater updating
  egress {
    description = "Automatic EDICOM adapater updating"
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # EDICOM Safe Document Transfer
  egress {
    description = "EDICOM Safe Document Transfer"
    from_port       = 9020
    to_port         = 9020
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Alarm e-mail in case of error in the execution of EDICOM scripts
  egress {
    description = "Alarm e-mail in case of error in the execution of EDICOM scripts"
    from_port       = 25
    to_port         = 25
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  # Safe WEB browsing through https for EDICOM
  egress {
    description = "Safe WEB browsing through https for EDICOM"
    from_port       = 443
    to_port         = 443
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = "${merge(map("Name","${var.edicom_outbound_security_group_name}"), 
                  map("Description", "Global Compliance EDICOM Adapter Port Rules (see ASP/EDI Framework documentation)"),
                  map("Tier","Security Group"), 
                  local.common_tags)}" 
}

