locals {
  environment_type = basename(dirname(dirname(path.cwd)))
}

locals {
 # The AWS region to deploy to (e.g. us-east-1)
  region     = "us-east-1"
}

locals {
  vpc_name = "${title(local.environment_type)} Environment VPC"
}

locals {
  # DEVELOPER'S NOTE:
  # While one can argue that these settings should be sourced
  # at the service level, it is also true that because they
  # influence billing/cost they may need to vary per environment.
  lambda_settings = {
    memory_size = "256"
    timeout = "30"
    reserved_concurrent_executions = "3"
  }
}

locals {
  # The number of seconds Amazon SQS retains a message.
  # Integer representing seconds, from 60 (1 minute) to 1209600 (14 days).
  # The default for this attribute is 345600 (4 days).
  queue_settings = {
    message_retention_seconds_in_queue = "86400" # 1 day
    additional_message_retention_seconds_in_dlq = "86400" # 1 day
    maxReceiveCount = 1
  }
}

locals {

    environment = {
        variables = {
        ClientMetadataUri = "https://testapi.vertexsmb.com/site/globalcompliance/clientprofile",
        NotificationsFromAddress = "amoses@anexinet.com",
        UndeliverableNotificationsRecipient = "TCummings@anexinet.com,JColadonato@vertexinc.com,amoses@vertexinc.com"
        }
    }
}