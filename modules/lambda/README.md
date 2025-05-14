# AWS Lambda Function that creates .Net Lambdas

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.19 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_log_level"></a> [application\_log\_level](#input\_application\_log\_level) | JSON structured logs, choose the detail level of the logs your application sends to CloudWatch | `string` | `null` | no |
| <a name="input_dead_letter_target_arn"></a> [dead\_letter\_target\_arn](#input\_dead\_letter\_target\_arn) | The ARN of an SNS topic or SQS queue to notify when an invocation fails. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of your Lambda Function (or Layer) | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A map that defines environment variables for the Lambda Function. | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | A unique name for your Lambda Function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function entrypoint in your code | `string` | n/a | yes |
| <a name="input_image_config_command"></a> [image\_config\_command](#input\_image\_config\_command) | The CMD for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_entry_point"></a> [image\_config\_entry\_point](#input\_image\_config\_entry\_point) | The ENTRYPOINT for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_working_directory"></a> [image\_config\_working\_directory](#input\_image\_config\_working\_directory) | The working directory for the docker image | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of KMS key to use by your Lambda Function | `string` | `""` | no |
| <a name="input_lambda_at_edge"></a> [lambda\_at\_edge](#input\_lambda\_at\_edge) | Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function | `bool` | `false` | no |
| <a name="input_lambda_role"></a> [lambda\_role](#input\_lambda\_role) | IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details. | `string` | n/a | yes |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. | `list(string)` | `[]` | no |
| <a name="input_log_create"></a> [log\_create](#input\_log\_create) | Create CloudWatch log group for your function | `bool` | `true` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | select between Text and structured JSON format for your function's logs | `string` | `"Text"` | no |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | the CloudWatch log group your function sends logs to | `string` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 3008 MB, in 64 MB increments. | `number` | n/a | yes |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | The Lambda deployment package type. Valid options: Zip or Image | `string` | `"Zip"` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Function runtime | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The S3 bucket location containing the function's deployment package. | `string` | n/a | yes |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | The S3 key path containing the function's deployment package. | `string` | `""` | no |
| <a name="input_s3_object_tags"></a> [s3\_object\_tags](#input\_s3\_object\_tags) | A map of tags to assign to S3 bucket object. | `map(string)` | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of Security group IDs. | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs. | `list(string)` | `[]` | no |
| <a name="input_system_log_level"></a> [system\_log\_level](#input\_system\_log\_level) | JSON structured logs, choose the detail level of the Lambda platform event logs sent to CloudWatch | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `3` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_lambda_function_arn"></a> [this\_lambda\_function\_arn](#output\_this\_lambda\_function\_arn) | The ARN of the Lambda Function |
| <a name="output_this_lambda_function_invoke_arn"></a> [this\_lambda\_function\_invoke\_arn](#output\_this\_lambda\_function\_invoke\_arn) | The Invoke ARN of the Lambda Function |
| <a name="output_this_lambda_function_kms_key_arn"></a> [this\_lambda\_function\_kms\_key\_arn](#output\_this\_lambda\_function\_kms\_key\_arn) | The ARN for the KMS encryption key of Lambda Function |
| <a name="output_this_lambda_function_last_modified"></a> [this\_lambda\_function\_last\_modified](#output\_this\_lambda\_function\_last\_modified) | The date Lambda Function resource was last modified |
| <a name="output_this_lambda_function_name"></a> [this\_lambda\_function\_name](#output\_this\_lambda\_function\_name) | The name of the Lambda Function |
| <a name="output_this_lambda_function_qualified_arn"></a> [this\_lambda\_function\_qualified\_arn](#output\_this\_lambda\_function\_qualified\_arn) | The ARN identifying your Lambda Function Version |
| <a name="output_this_lambda_function_source_code_hash"></a> [this\_lambda\_function\_source\_code\_hash](#output\_this\_lambda\_function\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_this_lambda_function_source_code_size"></a> [this\_lambda\_function\_source\_code\_size](#output\_this\_lambda\_function\_source\_code\_size) | The size in bytes of the function .zip file |
| <a name="output_this_lambda_function_version"></a> [this\_lambda\_function\_version](#output\_this\_lambda\_function\_version) | Latest published version of Lambda Function |
<!-- END_TF_DOCS -->