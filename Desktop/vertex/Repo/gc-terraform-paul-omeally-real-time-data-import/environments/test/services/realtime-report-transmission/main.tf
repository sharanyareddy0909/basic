module "service" {
    source = "../../../../modules/services/real-time-report-transmission"

     environment_type = local.environment_type

    environment = local.environment

     lambda_settings = local.lambda_settings
 

}
