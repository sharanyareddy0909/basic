module "invoice-data-import" {
    source = "../../../../modules/services/invoice-data-import"
    environment_type = local.environment_type

}
