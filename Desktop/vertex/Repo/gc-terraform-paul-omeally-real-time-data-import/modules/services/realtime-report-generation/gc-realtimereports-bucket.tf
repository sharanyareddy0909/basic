resource "aws_s3_bucket" "s3_bucket" {

  bucket = local.bucket.name
  acl    = local.bucket.acl
  force_destroy = local.bucket.force_destroy
  region = local.bucket.region

  tags = module.bucket_tags.tags
}