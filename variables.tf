variable "name" {
  type = "string"
}

variable "namespace" {
  type = "string"
}

variable "stage" {
  type = "string"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "prefix" {
  description = "S3 bucket prefix"
  default     = ""
}

variable "standard_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier"
  default     = "30"
}

variable "glacier_transition_days" {
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = "60"
}

variable "expiration_days" {
  description = "Number of days after which to expunge the objects"
  default     = "90"
}

variable "dynamodb_table_name" {
  type        = "string"
  description = "DynamoDB table name"
}
