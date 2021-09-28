
resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  read_capacity  = var.autoscaling_min_read_capacity
  write_capacity = var.autoscaling_min_write_capacity

  hash_key = var.table_hash_key


  attribute {
    name = var.table_hash_key
    type = var.table_hash_key_type
  }

  dynamic "attribute" {
    for_each = var.global_secondary_indexes
    iterator = index

    content {
      name = index.key
      type = index.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    iterator = index

    content {
      name            = index.key
      hash_key        = index.key
      projection_type = "ALL"
      read_capacity   = var.autoscaling_min_read_capacity
      write_capacity  = var.autoscaling_min_write_capacity
    }
  }
}

resource "aws_appautoscaling_target" "table_read_autoscaling_target" {
  min_capacity       = var.autoscaling_min_read_capacity
  max_capacity       = var.autoscaling_max_read_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.table]
}

resource "aws_appautoscaling_target" "table_write_autoscaling_target" {
  min_capacity       = var.autoscaling_min_write_capacity
  max_capacity       = var.autoscaling_max_write_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.table]
}

resource "aws_appautoscaling_policy" "table_entity_read_policy" {
  name               = "TableEntityRead:${aws_appautoscaling_target.table_read_autoscaling_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.table_read_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = var.autoscaling_read_capacity_utilization_target
  }

  depends_on = [aws_dynamodb_table.table]
}

resource "aws_appautoscaling_policy" "table_entity_write_policy" {
  name               = "TableEntityRead:${aws_appautoscaling_target.table_write_autoscaling_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.table_write_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = var.autoscaling_write_capacity_utilization_target
  }

  depends_on = [aws_dynamodb_table.table]
}