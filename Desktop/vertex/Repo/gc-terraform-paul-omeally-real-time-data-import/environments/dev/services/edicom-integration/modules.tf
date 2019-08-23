module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  namespace             = "key"
  stage                 = "dev"
  name                  = "${var.key_name}"
  ssh_public_key_path   = "${path.module}/secret"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = ""
}
