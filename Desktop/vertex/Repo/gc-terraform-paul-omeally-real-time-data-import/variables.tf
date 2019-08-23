variable "vpc_name" {
  description = "Set the Name Tag used for filtering specific VPC and Security Groups"
  default = "LowerEnvironment-VPC"
}


# TAG VALUES
#-------------------------------------------------------------------------------------------------------------
# TODO: Would love to figure out how to merge maps or augment maps for the puposes of tagging.
#       The below works fantastically (e.g. tags = "${var.tags}"), but I don't know how to add to/amend the map
# TODO: Does it make sense to pull something like Environment from the VPC for which the resource is placed?
/*  variable "tags" {
      type = "map"
      default = { 
        Owner = "VAT Compliance",
        Project = "VAT Compliance",
        Project_id = "VAT Compliance"
        Environment = "Development"
      }
    }
*/
variable "tag_owner" {
    description = "Standard tag value for Owner"
    default = "VAT Compliance"
}

variable "tag_project" {
    description = "Standard tag value for Project"
    default = "VAT Compliance"
}

variable "tag_project_id" {
    description = "Standard tag value for Project_Id"
    default = "VAT Compliance"
}

#TODO : This should be dynamic..But based on what?
variable "tag_environment" {
    description = "Standard tag value for Environment"
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