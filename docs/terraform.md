## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| autoscale_max_read_capacity | - | string | `100` | no |
| autoscale_max_write_capacity | - | string | `100` | no |
| autoscale_min_read_capacity | - | string | `10` | no |
| autoscale_min_write_capacity | - | string | `10` | no |
| autoscale_read_target | - | string | `50` | no |
| autoscale_write_target | - | string | `50` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| expiration_days | Number of days after which to expunge the objects | string | `90` | no |
| glacier_transition_days | Number of days after which to move the data to the glacier storage tier | string | `60` | no |
| iam_role_max_session_duration | The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours | string | `3600` | no |
| name | Name  (e.g. `bastion` or `db`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| prefix | S3 bucket prefix | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| standard_transition_days | Number of days to persist in the standard storage tier before moving to the glacier tier | string | `30` | no |
| tags | Additional tags (e.g. map('BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb_audit_table_arn | - |
| dynamodb_audit_table_id | - |
| dynamodb_state_table_arn | - |
| dynamodb_state_table_id | - |
| s3_bucket_arn | - |
| s3_bucket_domain_name | - |
| s3_bucket_id | - |

