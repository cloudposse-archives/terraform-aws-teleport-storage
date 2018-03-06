variable "region" {
  type = "string"
}

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
  default = ""
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
