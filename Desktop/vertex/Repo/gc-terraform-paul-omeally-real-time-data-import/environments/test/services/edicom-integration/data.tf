data "aws_vpc" "selected" {
  tags = {
    Name = "${var.vpc_name}"
  }
}
data "aws_ami" "ami" {
  most_recent      = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["gc-edicom-host-ec2"]   # "Windows_Server-2019-English-Full-Base-2019.01.10"
  }
}

#-- Get Subnet List (we only need the first one though)
#TODO:  Be specific as to which public subnet it needs to be
#TODO:  Other criteria besides being dependent on tags for query/filter..might get complicated...What is the determining factor
data "aws_subnet_ids" "selected" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Network = "Private"
  }
}

data "aws_security_group" "selected_sg_inbound" {
  tags = {
    Name = "gc-rdp-access-via-vpn"
  }
  vpc_id = "${data.aws_vpc.selected.id}"
}


# The below is syntatically correct, but the "gc_edicom_adapter_outbound" sg is appearently cursed.  I am able to return
# multiple groups using the below, but just not gc_edicom_adapter_outbound". Probably the *underscores*, but not sure.
# Tried putting in a variable first - didn't help.  Putting the wild-card '*' in front found the correct one, but that
# is also mystifying.
#data "aws_security_groups" "select_test" {
#  filter {
#    name = "vpc-id"
#   values = ["${data.aws_vpc.selected.id}"]
#  }
#  filter {
#    name = "group-name"
#    values = ["gc-rdp-access-via-vpn", "*gc_edicom_adapter_outbound"]
#  }
#}