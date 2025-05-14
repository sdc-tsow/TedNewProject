// Local Variables
locals {
    env_vars = merge({SSL_CERT_FILE="/opt/certs/ca.cer"}, var.environment_variables)
}

###########
# Function
###########

variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}

variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "s3_bucket" {
  description = "The S3 bucket location containing the function's deployment package."
  type        = string
}

variable "s3_key" {
  description = "The S3 key path containing the function's deployment package."
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of Security group IDs."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs."
  type        = list(string)
  default     = []
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string

  #  validation {
  #    condition     = can(var.create && contains(["nodejs10.x", "nodejs12.x", "java8", "java11", "python2.7", " python3.6", "python3.7", "python3.8", "dotnetcore2.1", "dotnetcore3.1", "go1.x", "ruby2.5", "ruby2.7", "provided"], var.runtime))
  #    error_message = "The runtime value must be one of supported by AWS Lambda."
  #  }
}

variable "lambda_role" {
  description = " IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details."
  type        = string
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "The ARN of KMS key to use by your Lambda Function"
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 3008 MB, in 64 MB increments."
  type        = number
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  type        = number
  default     = -1
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "dead_letter_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "tracing_mode" {
  description = "Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "s3_object_tags" {
  description = "A map of tags to assign to S3 bucket object."
  type        = map(string)
  default     = {}
}

variable "package_type" {
  description = "The Lambda deployment package type. Valid options: Zip or Image"
  type        = string
  default     = "Zip"
}

variable "image_config_entry_point" {
  description = "The ENTRYPOINT for the docker image"
  type        = list(string)
  default     = []

}
variable "image_config_command" {
  description = "The CMD for the docker image"
  type        = list(string)
  default     = []
}

variable "image_config_working_directory" {
  description = "The working directory for the docker image"
  type        = string
  default     = ""
}

variable "application_log_level" {
  description = " JSON structured logs, choose the detail level of the logs your application sends to CloudWatch"
  type        = string
  default     = null
}

variable "log_format" {
  description = "select between Text and structured JSON format for your function's logs"
  type        = string
  default     = "Text"
}

variable "log_group" {
  description = "the CloudWatch log group your function sends logs to"
  type        = string
  default     = null
}

variable "system_log_level" {
  description = "JSON structured logs, choose the detail level of the Lambda platform event logs sent to CloudWatch"
  type        = string
  default     = null
}

variable "log_create" {
  description = "Create CloudWatch log group for your function"
  type        = bool
  default     = true
}