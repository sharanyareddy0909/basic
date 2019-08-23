resource "aws_instance" "edicom_host" {
  
  ami                  = "${data.aws_ami.ami.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${module.ssh_key_pair.key_name}"
  subnet_id            = "${data.aws_subnet_ids.selected.ids[01]}"
  # NOTE: If you are creating instances in a VPC, use vpc_security_group_ids instead (https://www.terraform.io/docs/providers/aws/r/instance.html)
  #       After switching, to vpc_security_group_ids it also removed the issue of force re-creation of EC2 instances with more that one security
  #       group - which was, let's say, very undesirable
  vpc_security_group_ids = ["${data.aws_security_group.selected_sg_inbound.id}", "${aws_security_group.edicom-outbound-security-group.id}"] 
  get_password_data    = "false"
  disable_api_termination = "false"
  iam_instance_profile = "${aws_iam_instance_profile.gc-edicom-host-role-instance-profile.name}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "true"
  }

  timeouts {
    create = "5m"
  }
  
  tags = "${merge(map("Name","${var.edicom_host_server_name}"), 
                  map("Description", "EC2 Instances for the hosting of multiple clients and EDICOM adapters"),
                  map("AutoStartStop","VAT-mon-7am-fri-530pm"),
                  map("Tier","EC2"), 
                  local.common_tags)}" 

  # tags = "${merge({"Name"="${var.edicom_host_server_name}", 
  #                  "Description"="EC2 Instances for the hosting of multiple clients and EDICOM adapters",
  #                  "AutoStartStop"="VAT-mon-7am-fri-530pm",
  #                  "Tier"="EC2"},
  #                 local.common_tags)}" 
}
