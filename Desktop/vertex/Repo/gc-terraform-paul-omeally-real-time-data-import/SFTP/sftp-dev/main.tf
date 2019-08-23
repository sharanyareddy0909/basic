
module "s3" {
   source = "../modules/s3"

   region = "${var.region}"
   bucketName = "${var.bucketName}"
   acl= "${var.acl}"
   versioning = "${var.versioning}"
   environment = "${var.environment}"

}


#THIS MODULE WILL create the SFTP service with a sample user with publick key for testing purposes for testing
module "sftp" {
    source = "../modules/sftp"

    region = "${var.region}"
    aws-transfer-server-name = "${var.aws-transfer-server-name}"
    IAM-role-name-for-sftp = "${var.IAM-role-name-for-sftp}"
    s3-access-policy-name = "${var.s3-access-policy-name}"
    sftp-user-name = "${var.sftp-user-name}"
    sftp-s3-bucket-name = "${var.sftp-s3-bucket-name}"
    s3-policy-file-location = "${file("../modules/sftp/dev-scope-down-policy.json")}"
    ssh-public-key-file-location = "${file("../modules/sftp/dev-user-test-key.pub")}"

    
}