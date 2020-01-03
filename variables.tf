variable "table_name" {
  type = "string"
  description = "table name"
}

variable "billing_mode" {
  type = "string"
  description = "DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST"
  default = "PROVISIONED"
}

variable "hash_key" {
  type        = string
  description = "DynamoDB table Hash Key"
}

variable "hash_key_type" {
  type        = string
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "range_key" {
  type        = string
  default     = ""
  description = "DynamoDB table Range Key"
}

variable "range_key_type" {
  type        = string
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "ttl_attribute" {
  type        = string
  default     = ""
  description = "DynamoDB table TTL attribute"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "autoscale_write_target" {
  type        = number
  default     = 70
  description = "The target value (in %) for DynamoDB write autoscaling"
}

variable "autoscale_read_target" {
  type        = number
  default     = 70
  description = "The target value (in %) for DynamoDB read autoscaling"
}

variable "write_capacity" {
  type = number
  description = "Initial write capacity for DynamoDB table"
  default = 5
}

variable "read_capacity" {
  type = number
  description = "Initial read capacity for DynamoDB table"
  default = 5
}

variable "write_max_capacity" {
  type = number
  description = "Maximum write capacity for autoscaling"
  default = 1000
}

variable "write_min_capacity" {
  type = number
  description = "Minimum write capacity for autoscaling"
  default = 5
}

variable "read_max_capacity" {
  type = number
  description = "Maximum read capacity for autoscaling"
  default = 4000
}

variable "read_min_capacity" {
  type = number
  description = "Minimum read capacity for autoscaling"
  default = 5
}