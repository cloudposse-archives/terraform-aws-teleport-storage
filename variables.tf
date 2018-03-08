variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (e.g. `bastion` or `db`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}

variable "region" {
  type        = "string"
  description = "AWS Region"
}

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

variable "hash_key" {
  type    = "string"
  default = "HashKey"
}

variable "range_key" {
  type    = "string"
  default = "FullPath"
}

variable "ttl_attribute" {
  type    = "string"
  default = "Expires"
}

variable "autoscale_write_target" {
  default = 50
}

variable "autoscale_read_target" {
  default = 50
}

variable "autoscale_min_read_capacity" {
  default = 10
}

variable "autoscale_max_read_capacity" {
  default = 100
}

variable "autoscale_min_write_capacity" {
  default = 10
}

variable "autoscale_max_write_capacity" {
  default = 100
}
