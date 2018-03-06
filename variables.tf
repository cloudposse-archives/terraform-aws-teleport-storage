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

variable "sessions_prefix" {
  default = ""
}

variable "logs_prefix" {
  default = ""
}

variable "logs_standard_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier"
  default     = "30"
}

variable "logs_glacier_transition_days" {
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = "60"
}

variable "logs_expiration_days" {
  description = "Number of days after which to expunge the objects"
  default     = "90"
}

variable "noncurrent_version_transition_days" {
  default = "30"
}

variable "noncurrent_version_expiration_days" {
  default = "90"
}
