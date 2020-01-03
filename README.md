## aws-dynamodb
Creates a dynamodb table with autoscaling

## Usage

```hcl
module "dynamodb_table" {
  source = "github.com/globeandmail/aws-dynamodb?ref=1.0"

  table_name               = table-name
  hash_key           = hash-key
  hash_key_type   = hash_key_type
  tags = {
    Environment = var.environment
  }
  autoscaling_role_arn = role-arn
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| table\_name | name of the dynamodb table | string | n/a | yes |
| billing\_mode | DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST, only working with PROVISIONED | string | "PROVISIONED" | no
| hash\_key | DynamoDB table Hash Key | string | n/a | yes |
| hash\_key\_type | Type of the primary key which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | 'S' | yes |
| range\_key | DynamoDB table Range Key | string | "" | no |
| range\_key\_type | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | 'S' | no |
| ttl_attribute | DynamoDB table TTL attribute | string | "" | no |
| autoscale\_write\_target | The target value (in %) for DynamoDB write autoscaling | number | 70 | no |
| autoscale_read_target | The target value (in %) for DynamoDB read autoscaling | number | 70 | no |
| write_capacity | Initial write capacity for DynamoDB table | number | 5 | no |
| read_capacity | Initial read capacity for DynamoDB table | number | 5 | no |
| write_max_capacity | Maximum write capacity for autoscaling | number | 1000 | no |
| read_max_capacity | Maximum read capacity for autoscaling | number | 4000 | no |
| write_min_capacity | Minimum write capacity for autoscaling | number | 5 | no |
| read_min_capacity | Minimum read capacity for autoscaling | number | 5 | no |
| tags | A mapping of tags to assign to the resource | map | `{}` | no |
| autoscaling_role_arn | default role arn for dynamodb autoscaling | string | n/a | yes


## Outputs

| Name | Description |
|------|-------------|
| table\_name |  |
| table\_id |  |
| table\_arn |  |
