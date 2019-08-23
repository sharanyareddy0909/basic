#S3
variable "region" {
  default = "us-east-1"
}
variable "bucketName" {
    default = "vitr-dev-sftp"
}

variable "acl" {
  default = "private"
}

variable "versioning" {
  default ="true"
}

variable "environment" {
  default = "DEV"
}


#SFTP
variable "aws-transfer-server-name" {
  default = "sftp-vitr-dev2"
}

variable "IAM-role-name-for-sftp" {
  default = "sftp-dev-role"
}

variable "s3-access-policy-name" {
  default = "dev-sftp-dev-scope-down"
}

#variable "s3-policy-file-location" {
#}

variable "sftp-user-name" {
  default = "devuser"
}

variable "sftp-s3-bucket-name" {
  type = "string"
  default = "/vitr-dev-sftp"
}

#variable "ssh-public-key-file-location" {
#}