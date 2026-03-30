variable "etcd_key" {
  description = "Etcd key where to store the users"
  type        = string
}

variable "execution_time" {
  description = "A timestamp in ISO 8601 format (ex: 2026-11-30T00:00:00Z) indicating the current execution time"
  type        = string
  default     = ""
}

variable "compute" {
  description = "Parameter to define what processed output to compute"
  type = object({
    users_by_username = optional(bool, true)
    users_by_role = optional(bool, false)
    usernames_by_role = optional(bool, true)
    users_by_environment = optional(bool, false)
    usernames_by_environment = optional(bool, true)
    users_by_environment_role = optional(bool, false)
    usernames_by_environment_role = optional(bool, true)
  })
  default = {
    users_by_username = true
    users_by_role = false
    usernames_by_role = true
    users_by_environment = false
    usernames_by_environment = true
    users_by_environment_role = false
    usernames_by_environment_role = true
  }
}
