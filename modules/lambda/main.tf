#Create Lambda
resource "aws_lambda_function" "this" {
  function_name                  = var.function_name
  description                    = var.description
  role                           = var.lambda_role
  handler                        = var.package_type != "Zip" ? null : var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.package_type != "Zip" ? null : var.runtime
  layers                         = var.layers
  timeout                        = var.lambda_at_edge ? min(var.timeout, 5) : var.timeout
  publish                        = var.lambda_at_edge ? true : var.publish
  kms_key_arn                    = var.kms_key_arn
  package_type                   = var.package_type
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key != "" ? var.s3_key : "placeholder.zip"


  dynamic "vpc_config" {
    for_each = var.subnet_ids != null && var.security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  dynamic "environment" {
    for_each = length(keys(local.env_vars)) == 0 ? [] : [true]
    content {
      variables = local.env_vars
    }
  }

  dynamic "logging_config" {
    for_each = var.log_format != null ? [true] : []
    content {
      application_log_level = var.application_log_level
      log_format            = var.log_format
      log_group             = var.log_group
      system_log_level      = var.system_log_level
    }
  }

  ## disabled til further notice
  # dynamic "tracing_config" { 
  #     for_each = var.tracing_mode != "" ? [true] : []
  #     content {
  #       mode = var.tracing_mode
  #     }
  #   }


  lifecycle {
    create_before_destroy = true
    ignore_changes        = [s3_key, s3_bucket]
  }

}

resource "aws_cloudwatch_log_group" "lambda" {
  count = var.log_create == true ? 1:0
  name = "/aws/lambda/${var.function_name}"
}
