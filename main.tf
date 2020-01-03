data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_region = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  attributes = concat(
    [
      {
        name = var.range_key
        type = var.range_key_type
      },
      {
        name = var.hash_key
        type = var.hash_key_type
      }
    ]
  )

  # Use the `slice` pattern (instead of `conditional`) to remove the first map from the list if no `range_key` is provided
  from_index = length(var.range_key) > 0 ? 0 : 1

  attributes_final = slice(local.attributes, local.from_index, length(local.attributes))
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name = var.table_name
  billing_mode = var.billing_mode
  hash_key = var.hash_key
  range_key = var.range_key
  write_capacity = var.write_capacity
  read_capacity = var.read_capacity

  dynamic "attribute" {
    for_each = local.attributes_final
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      "read_capacity",
      "write_capacity"]
    #We want this ignored so that we can use app autoscaling
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.ttl_attribute != "" ? true : false
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count = var.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity = var.read_max_capacity
  min_capacity = var.read_min_capacity
  resource_id = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  role_arn = var.autoscaling_role_arn
  service_namespace = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count              = var.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.autoscale_read_target
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count = var.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity = var.write_max_capacity
  min_capacity = var.write_min_capacity
  resource_id = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  role_arn = var.autoscaling_role_arn
  service_namespace = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count              = var.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.autoscale_write_target
  }
}
