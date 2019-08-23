

resource "aws_s3_bucket" "sftpBucket"{
   bucket = "${var.bucketName}"
   region =  "${var.region}"
    acl = "${var.acl}"

    versioning {
       enabled = "${var.versioning}"
    }

    tags {
       name = "${var.environment}"
    }

}


