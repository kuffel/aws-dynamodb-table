
variable "table_name" {
  description = "Name of the Dynamo DB table that will be created (e.g. entity)"
}

variable "table_hash_key" {
  description = "Name of the Hash Key for the table (e.g. uuid)"
}

variable "table_hash_key_type" {
  description = "Type of the Hash Key for the table (e.g. S)"
}

variable "global_secondary_indexes" {
  description = "List of global_secondary_indexes attributes"
  default     = {}
}

variable "autoscaling_min_read_capacity" {
  description = "The minimal read capacity that the autoscaling should ensure for the table"
  default     = 1
}

variable "autoscaling_max_read_capacity" {
  description = "The maximal read capacity that the autoscaling should allow for the table"
  default     = 10
}

variable "autoscaling_read_capacity_utilization_target" {
  description = "The utilization target for the autoscaling read capacity for the table"
  default     = 70
}

variable "autoscaling_min_write_capacity" {
  description = "The minimal write capacity that the autoscaling should ensure for the table"
  default     = 1
}

variable "autoscaling_max_write_capacity" {
  description = "The maximal write capacity that the autoscaling should allow for the table"
  default     = 10
}

variable "autoscaling_write_capacity_utilization_target" {
  description = "The utilization target for the autoscaling write capacity for the table"
  default     = 70
}