variable "prefix" {
  type        = "string"
  description = "S3 bucket prefix"
  default     = ""
}

variable "standard_transition_days" {
  type        = "string"
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier"
  default     = "30"
}

variable "glacier_transition_days" {
  type        = "string"
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = "60"
}

variable "expiration_days" {
  type        = "string"
  description = "Number of days after which to expunge the objects"
  default     = "90"
}

variable "autoscale_write_target" {
  default     = 50
  description = "DynamoDB autoscale write target"
}

variable "autoscale_read_target" {
  default     = 50
  description = "DynamoDB autoscale read target"
}

variable "autoscale_min_read_capacity" {
  default     = 10
  description = "DynamoDB autoscale read min capacity"
}

variable "autoscale_max_read_capacity" {
  default     = 100
  description = "DynamoDB autoscale read max capacity"
}

variable "autoscale_min_write_capacity" {
  default     = 10
  description = "DynamoDB autoscale write min capacity"
}

variable "autoscale_max_write_capacity" {
  default     = 100
  description = "DynamoDB autoscale write max capacity"
}

variable "iam_role_max_session_duration" {
  default     = 3600
  description = "The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours"
}
