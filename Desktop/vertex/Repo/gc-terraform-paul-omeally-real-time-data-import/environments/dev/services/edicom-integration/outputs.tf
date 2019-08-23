
output "environment" { value ="${var.environment}"}
output "vpc_id" {  value = "${data.aws_vpc.selected.id}" } 

#EC Instance
output "ami_id" { value = "${data.aws_ami.ami.image_id}" } 
output "instance_type" { value = "${var.instance_type}" } 
output "key_name" {  value = "${var.key_name}" } 
output "subnets" {  value = "${data.aws_subnet_ids.selected.ids}" } 
output "outbound_security_groups" { value ="${var.edicom_outbound_security_group_name}"}
output "inbound_security_groups" { value ="${data.aws_security_group.selected_sg_inbound.id}"}
#output "Security Groups" { value ="${data.aws_security_groups.select_test.ids}"}
output "secret_path_module" {value="${path.module}"}
output "module_key_name" {value="${module.ssh_key_pair.key_name}"}