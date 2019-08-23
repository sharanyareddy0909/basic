locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Owner       = "VAT Compliance"
    Project     = "VAT Compliance"
    Project_Id  = "VAT Compliance"
    Environment = "${var.environment}"
  }
}