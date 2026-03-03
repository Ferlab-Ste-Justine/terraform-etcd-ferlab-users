variable "etcd_key" {
  description = "Etcd key where to store the users"
  type        = string
}

variable "execution_time" {
  description = "A timestamp in ISO 8601 format (ex: 2026-11-30T00:00:00Z) indicating the current execution time"
  type        = string
  default     = ""
}
