<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_glue_registry.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry) | resource |
| [aws_glue_schema.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema) | resource |
| [aws_msk_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_msk_scram_secret_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association) | resource |
| [aws_mskconnect_custom_plugin.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_custom_plugin) | resource |
| [aws_mskconnect_worker_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_worker_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_broker_node_client_subnets"></a> [broker\_node\_client\_subnets](#input\_broker\_node\_client\_subnets) | A list of subnets to connect to in client VPC ([documentation](https://docs.aws.amazon.com/msk/1.0/apireference/clusters.html#clusters-prop-brokernodegroupinfo-clientsubnets)) | `list(string)` | `[]` | no |
| <a name="input_broker_node_ebs_volume_size"></a> [broker\_node\_ebs\_volume\_size](#input\_broker\_node\_ebs\_volume\_size) | The size in GiB of the EBS volume for the data drive on each broker node | `number` | `null` | no |
| <a name="input_broker_node_instance_type"></a> [broker\_node\_instance\_type](#input\_broker\_node\_instance\_type) | Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large. ([Pricing info](https://aws.amazon.com/msk/pricing/)) | `string` | `null` | no |
| <a name="input_broker_node_security_groups"></a> [broker\_node\_security\_groups](#input\_broker\_node\_security\_groups) | A list of the security groups to associate with the elastic network interfaces to control who can communicate with the cluster | `list(string)` | `[]` | no |
| <a name="input_client_allow_unauthenticated"></a> [client\_allow\_unauthenticated](#input\_client\_allow\_unauthenticated) | Enables unauthenticated access. | `bool` | `false` | no |
| <a name="input_client_authentication_sasl_iam"></a> [client\_authentication\_sasl\_iam](#input\_client\_authentication\_sasl\_iam) | Enables IAM client authentication | `bool` | `false` | no |
| <a name="input_client_authentication_sasl_scram"></a> [client\_authentication\_sasl\_scram](#input\_client\_authentication\_sasl\_scram) | Enables SCRAM client authentication via AWS Secrets Manager | `bool` | `false` | no |
| <a name="input_client_authentication_tls_certificate_authority_arns"></a> [client\_authentication\_tls\_certificate\_authority\_arns](#input\_client\_authentication\_tls\_certificate\_authority\_arns) | List of ACM Certificate Authority Amazon Resource Names (ARNs) | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Name of the Cloudwatch Log Group to deliver logs to | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the log group | `number` | `0` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs | `bool` | `false` | no |
| <a name="input_configuration_description"></a> [configuration\_description](#input\_configuration\_description) | Description of the configuration | `string` | `null` | no |
| <a name="input_configuration_name"></a> [configuration\_name](#input\_configuration\_name) | Name of the configuration | `string` | `null` | no |
| <a name="input_configuration_server_properties"></a> [configuration\_server\_properties](#input\_configuration\_server\_properties) | Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html) | `map(string)` | `{}` | no |
| <a name="input_connect_custom_plugin_timeouts"></a> [connect\_custom\_plugin\_timeouts](#input\_connect\_custom\_plugin\_timeouts) | Timeout configurations for the connect custom plugins | `map(string)` | <pre>{<br>  "create": null<br>}</pre> | no |
| <a name="input_connect_custom_plugins"></a> [connect\_custom\_plugins](#input\_connect\_custom\_plugins) | Map of custom plugin configuration details (map of maps) | `any` | `{}` | no |
| <a name="input_connect_worker_config_description"></a> [connect\_worker\_config\_description](#input\_connect\_worker\_config\_description) | A summary description of the worker configuration | `string` | `null` | no |
| <a name="input_connect_worker_config_name"></a> [connect\_worker\_config\_name](#input\_connect\_worker\_config\_name) | The name of the worker configuration | `string` | `null` | no |
| <a name="input_connect_worker_config_properties_file_content"></a> [connect\_worker\_config\_properties\_file\_content](#input\_connect\_worker\_config\_properties\_file\_content) | Contents of connect-distributed.properties file. The value can be either base64 encoded or in raw format | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether cluster resources will be created | `bool` | `true` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Determines whether to create a CloudWatch log group | `bool` | `true` | no |
| <a name="input_create_connect_worker_configuration"></a> [create\_connect\_worker\_configuration](#input\_create\_connect\_worker\_configuration) | Determines whether to create connect worker configuration | `bool` | `false` | no |
| <a name="input_create_schema_registry"></a> [create\_schema\_registry](#input\_create\_schema\_registry) | Determines whether to create a Glue schema registry for managing Avro schemas for the cluster | `bool` | `true` | no |
| <a name="input_create_scram_secret_association"></a> [create\_scram\_secret\_association](#input\_create\_scram\_secret\_association) | Determines whether to create SASL/SCRAM secret association | `bool` | `false` | no |
| <a name="input_encryption_at_rest_kms_key_arn"></a> [encryption\_at\_rest\_kms\_key\_arn](#input\_encryption\_at\_rest\_kms\_key\_arn) | You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest | `string` | `null` | no |
| <a name="input_encryption_in_transit_client_broker"></a> [encryption\_in\_transit\_client\_broker](#input\_encryption\_in\_transit\_client\_broker) | Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`. Default value is `TLS` | `string` | `null` | no |
| <a name="input_encryption_in_transit_in_cluster"></a> [encryption\_in\_transit\_in\_cluster](#input\_encryption\_in\_transit\_in\_cluster) | Whether data communication among broker nodes is encrypted. Default value: `true` | `bool` | `null` | no |
| <a name="input_enhanced_monitoring"></a> [enhanced\_monitoring](#input\_enhanced\_monitoring) | Specify the desired enhanced MSK CloudWatch monitoring level. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html) | `string` | `null` | no |
| <a name="input_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#input\_firehose\_delivery\_stream) | Name of the Kinesis Data Firehose delivery stream to deliver logs to | `string` | `null` | no |
| <a name="input_firehose_logs_enabled"></a> [firehose\_logs\_enabled](#input\_firehose\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose | `bool` | `false` | no |
| <a name="input_jmx_exporter_enabled"></a> [jmx\_exporter\_enabled](#input\_jmx\_exporter\_enabled) | Indicates whether you want to enable or disable the JMX Exporter | `bool` | `false` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Specify the desired Kafka software version | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the MSK cluster | `string` | `"msk"` | no |
| <a name="input_node_exporter_enabled"></a> [node\_exporter\_enabled](#input\_node\_exporter\_enabled) | Indicates whether you want to enable or disable the Node Exporter | `bool` | `false` | no |
| <a name="input_number_of_broker_nodes"></a> [number\_of\_broker\_nodes](#input\_number\_of\_broker\_nodes) | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets | `number` | `null` | no |
| <a name="input_s3_logs_bucket"></a> [s3\_logs\_bucket](#input\_s3\_logs\_bucket) | Name of the S3 bucket to deliver logs to | `string` | `null` | no |
| <a name="input_s3_logs_enabled"></a> [s3\_logs\_enabled](#input\_s3\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to S3 | `bool` | `false` | no |
| <a name="input_s3_logs_prefix"></a> [s3\_logs\_prefix](#input\_s3\_logs\_prefix) | Prefix to append to the folder name | `string` | `null` | no |
| <a name="input_scaling_max_capacity"></a> [scaling\_max\_capacity](#input\_scaling\_max\_capacity) | Max storage capacity for Kafka broker autoscaling | `number` | `250` | no |
| <a name="input_scaling_role_arn"></a> [scaling\_role\_arn](#input\_scaling\_role\_arn) | The ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf. This defaults to an IAM Service-Linked Role | `string` | `null` | no |
| <a name="input_scaling_target_value"></a> [scaling\_target\_value](#input\_scaling\_target\_value) | The Kafka broker storage utilization at which scaling is initiated | `number` | `70` | no |
| <a name="input_schema_registries"></a> [schema\_registries](#input\_schema\_registries) | A map of schema registries to be created | `map(any)` | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | A map schemas to be created within the schema registry | `map(any)` | `{}` | no |
| <a name="input_scram_secret_association_secret_arn_list"></a> [scram\_secret\_association\_secret\_arn\_list](#input\_scram\_secret\_association\_secret\_arn\_list) | List of AWS Secrets Manager secret ARNs to associate with SCRAM | `list(string)` | `[]` | no |
| <a name="input_stamps_aws_region"></a> [stamps\_aws\_region](#input\_stamps\_aws\_region) | AWS Region | `string` | `"us-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources created | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeout configurations for the cluster | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appautoscaling_policy_arn"></a> [appautoscaling\_policy\_arn](#output\_appautoscaling\_policy\_arn) | The ARN assigned by AWS to the scaling policy |
| <a name="output_appautoscaling_policy_name"></a> [appautoscaling\_policy\_name](#output\_appautoscaling\_policy\_name) | The scaling policy's name |
| <a name="output_appautoscaling_policy_policy_type"></a> [appautoscaling\_policy\_policy\_type](#output\_appautoscaling\_policy\_policy\_type) | The scaling policy's type |
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_plaintext"></a> [bootstrap\_brokers\_plaintext](#output\_bootstrap\_brokers\_plaintext) | Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT` |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | One or more DNS names (or IP addresses) and SASL IAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_iam` is set to `true` |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | One or more DNS names (or IP addresses) and SASL SCRAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_scram` is set to `true` |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | One or more DNS names (or IP addresses) and TLS port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` |
| <a name="output_configuration_arn"></a> [configuration\_arn](#output\_configuration\_arn) | Amazon Resource Name (ARN) of the configuration |
| <a name="output_configuration_latest_revision"></a> [configuration\_latest\_revision](#output\_configuration\_latest\_revision) | Latest revision of the configuration |
| <a name="output_connect_custom_plugins"></a> [connect\_custom\_plugins](#output\_connect\_custom\_plugins) | A map of output attributes for the connect custom plugins created |
| <a name="output_connect_worker_configuration_arn"></a> [connect\_worker\_configuration\_arn](#output\_connect\_worker\_configuration\_arn) | The Amazon Resource Name (ARN) of the worker configuration |
| <a name="output_connect_worker_configuration_latest_revision"></a> [connect\_worker\_configuration\_latest\_revision](#output\_connect\_worker\_configuration\_latest\_revision) | An ID of the latest successfully created revision of the worker configuration |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH` |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The Amazon Resource Name (ARN) specifying the log group |
| <a name="output_schema_registries"></a> [schema\_registries](#output\_schema\_registries) | A map of output attributes for the schema registries created |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | A map of output attributes for the schemas created |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphabetically |
| <a name="output_zookeeper_connect_string_tls"></a> [zookeeper\_connect\_string\_tls](#output\_zookeeper\_connect\_string\_tls) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. The returned values are sorted alphabetically |
<!-- END_TF_DOCS -->