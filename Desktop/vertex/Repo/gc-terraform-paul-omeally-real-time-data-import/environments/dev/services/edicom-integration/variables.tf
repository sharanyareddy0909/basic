variable "vpc_name" {
  description = "Set the Name Tag used for filtering specific VPC and Security Groups"
  default = "LowerEnvironment-VPC"
}

#TODO : This should be dynamic..But based on what?
variable "environment" {
    description = "Standard tag value for Environment (e.g. Development, Test, Stage, etc.)"
    default = "Development"
}

# EDICOM Specific Vars
#-------------------------------------------------------------------------------------------------------------
# 02/07 - Bumping to t3.small to get the extra GB of ram - bonus 1 core too
variable "instance_type" {
  description = "EC2 Instance Type for EDICOM Host"
  default ="t3.small"
}

variable "volume_type" {
  description = "The type of volume. Can be standard gp2 or io1 or sc1st1"
  default = "standard"
}

variable "volume_size" {
  description = "size of the ebs volume needed"
  default = "30"
}
variable "edicom_outbound_security_group_name" {
  description = "Security Group name to be used to support EDICOM outbound traffic"
  default = "gc-edicom-adapter-outbound"
}

variable "edicom_host_server_name" {
  description ="Edicom Host EC2 Name"
  default ="gc-edicom-adpater-host"
}

variable "key_name" {
  description = "name part given to the keys"
  default = "edicom-host-ec2"
}
