variable "etcd_key" {
  description = "Etcd key where to store the users"
  type        = string
}

variable "prune_expired_grants" {
  description = "When true, remove temporary grants with expires_at in the past."
  type        = bool
  default     = true
}
