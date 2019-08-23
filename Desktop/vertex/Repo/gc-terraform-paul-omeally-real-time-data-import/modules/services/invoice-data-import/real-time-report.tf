
module "role_tags" {
  source = "../../utility/tags"

  environment_type = "${var.environment_type}"
  service = "${local.service}"
  resource_type = "role"
  resource_name = "${local.api_role_name}"
}

/*
module "api_config" {
  source = "../../utility/api/assume_role_policy"
  role_name = "${local.api_role_name}"
  tags = "${module.role_tags.tags}"
}
*/

#--- A P I ---#
resource "aws_api_gateway_rest_api" "gc-real-time-invoice-reporting-api" {
  name        = "${local.api_name}"
  description = "${local.description}"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  binary_media_types  = ["text/csv", "text/plain"]

  api_key_source = "AUTHORIZER"
}


#--- R E S O U R C E ---#
resource "aws_api_gateway_resource" "invoice-data-file-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.root_resource_id}"
  path_part   = "{file}"
}


#--- M E T H O D S ---#
resource "aws_api_gateway_method" "invoice-data-file-resource-put-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id   = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method   = "${local.http_method}"
  authorization = "${local.authorization}"
  authorizer_id = "${aws_api_gateway_authorizer.gc-token-authorizer.id}"
  
  
  # https://stackoverflow.com/questions/39040739/in-terraform-how-do-you-specify-an-api-gateway-endpoint-with-a-variable-in-the
  request_parameters =  {
    "method.request.path.file" = true
  }
  

}


#--- I N T E G R A T I O N S ---#
resource "aws_api_gateway_integration" "invoice-data-file-resource-put-method-integration" {
  rest_api_id          = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id          = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method          = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  integration_http_method = "${local.integration_http_method}"
  type                 = "AWS"  
  uri= "arn:aws:apigateway:${var.region}:s3:path/${data.aws_s3_bucket.gc-invoicedata-bucket.bucket}/real-time-invoice-data/{clientId}/{requestId}/{object}"

  credentials = "${aws_iam_role.iam_role.arn}"

 # content_handling     = ""
 # passthrough_behavior = ""
  timeout_milliseconds = 29000

  request_parameters = {
    "integration.request.path.object" = "method.request.path.file"
    "integration.request.path.requestId" = "context.requestId"
    "integration.request.path.clientId" = "context.authorizer.principalId"
  }  
}


#--- A U T H O R I Z E R ---#
resource "aws_api_gateway_authorizer" "gc-token-authorizer" {
  name                   = "gc-token-authorizer"
  rest_api_id            = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  authorizer_uri         = "${data.aws_lambda_function.gc-token-authorizer-function.invoke_arn}"
  authorizer_credentials = "${aws_iam_role.iam_role.arn}"
}




#--- R E S P O N S E S ---#
#--- 2 x x ---#
resource "aws_api_gateway_method_response" "invoice-data-file-resource-put-method-202-response" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  status_code = "202"
}

resource "aws_api_gateway_integration_response" "invoice-data-file-resource-put-method-202-integration-response" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  status_code = "${aws_api_gateway_method_response.invoice-data-file-resource-put-method-202-response.status_code}"
  #selection_pattern = "2\\d{2}"
  selection_pattern = "-"

  response_templates = {
"application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
  "referenceId":"$context.requestId",
  "message":"An error occurred during submission of data.",
  "timestamp":"$context.requestTime"
}
EOF
  }
}

#--- 4 x x ---#
resource "aws_api_gateway_method_response" "invoice-data-file-resource-put-method-400-response" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  status_code = "400"
}

resource "aws_api_gateway_integration_response" "invoice-data-file-resource-put-method-400-integration-response" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  status_code = "${aws_api_gateway_method_response.invoice-data-file-resource-put-method-400-response.status_code}"
  selection_pattern = "4\\d{2}"

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
  "referenceId":"$context.requestId",
  "message":"An error occurred during submission of data.",
  "timestamp":"$context.requestTime"
}
EOF
  }
}

#--- 5 x x ---#
resource "aws_api_gateway_method_response" "invoice-data-file-resource-put-method-500-response" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  status_code = "500"
}

resource "aws_api_gateway_integration_response" "invoice-data-file-resource-put-method-500-integration-response" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  resource_id = "${aws_api_gateway_resource.invoice-data-file-resource.id}"
  http_method = "${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  status_code = "${aws_api_gateway_method_response.invoice-data-file-resource-put-method-500-response.status_code}"
  selection_pattern = "5\\d{2}"

response_templates = {
  "application/json"  = <<EOF
#set($inputRoot = $input.path('$'))
{
  "referenceId":"$context.requestId",
  "message":"An error occurred during submission of data. Please contact support with reference number: $context.requestId",
  "timestamp":"$context.requestTime"
}
EOF
  }
}


#--- M O D E L S ---#
resource "aws_api_gateway_model" "response-model" {
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  name         = "${local.model_name}"
  description  = "${local.model_description}"
  content_type = "${local.content_type}"


schema =<<EOF
  {
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Standard schema for invoice-data api response.",
  "type" : "object",
  "properties" : {
    "referenceId": { "type": "string" },
    "message": { "type": "string" },
    "timestamp": { "type": "string" }
  }
}
EOF


}

#--- D E P L O Y M E N T S ---#
resource "aws_api_gateway_deployment" "dev-deployment" {
  depends_on  = ["aws_api_gateway_integration.invoice-data-file-resource-put-method-integration"]
  rest_api_id = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"

  # As per: https://github.com/terraform-providers/terraform-provider-aws/issues/2918
  # Will be fixed in PR#6459 https://github.com/terraform-providers/terraform-provider-aws/pull/6459
  stage_name  = ""
}

#--- S T A G E S ---#
resource "aws_api_gateway_stage" "stage" {
  stage_name    = "${var.stage}"
  rest_api_id   = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  deployment_id = "${aws_api_gateway_deployment.dev-deployment.id}"
}

resource "aws_api_gateway_method_settings" "dev-stage-method-settings" {
  rest_api_id   = "${aws_api_gateway_rest_api.gc-real-time-invoice-reporting-api.id}"
  stage_name  = "${aws_api_gateway_stage.stage.stage_name}"
  # method_path = "${aws_api_gateway_resource.invoice-data-file-resource.path_part}/${aws_api_gateway_method.invoice-data-file-resource-put-method.http_method}"
  method_path = "*/*"

  settings {
    #metrics_enabled = true
    data_trace_enabled = true
    logging_level   = "INFO"    
  }
   
}


#--- P E R M I S S I O N S ---#
resource "aws_iam_role" "iam_role" {
  name = "${var.role_name}"
#  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "gc-write-invoicedata-to-s3-role-policy" {
  name = "gc-write-invoicedata-to-s3-role-policy"
  role = "${aws_iam_role.iam_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "${data.aws_s3_bucket.gc-invoicedata-bucket.arn}/*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy" "gc-token-authorizer-invocation-role-policy" {
  name = "gc-token-authorizer-invocation-role-policy"
  role = "${aws_iam_role.iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${data.aws_lambda_function.gc-token-authorizer-function.arn}"
    }
  ]
}
EOF
}
