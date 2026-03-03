variable "etcd_key" {
  description = "Etcd key where to store the users, the list of roles and the list of environments"
  type        = string
}

variable "environments" {
  description = "List of valid environments"
  type        = list(string)
}

variable "roles" {
  description = "List of valid roles"
  type        = list(string)
}

variable "required_attributes" {
  description = "List of required attributes by role"
  type        = map(list(string))
  default     = {}
}

variable "users" {
  description = "List of users"
  type        = list(object({
    username         = string
    roles            = list(string)
    environments     = list(string)
    attributes       = optional(map(string), {})
    temporary_grants = optional(list(object({
      name       = string
      scope      = string
      expires_at = string
    })), [])
  }))

  validation {
    condition = alltrue([
      for user in var.users : user.username != ""
    ])
    error_message = "Each user's username should not be empty."
  }

  validation {
    condition = alltrue([
      for user in var.users : alltrue([
            for grant in user.temporary_grants : grant.name != "" && grant.scope != ""
        ])
    ])
    error_message = "Each entry in each user's temporary_grants must have non-empty name and scope fields."
  }

  validation {
    condition = alltrue(flatten([
      for user in var.users : [
            for grant in user.temporary_grants : can(formatdate("",grant.expires_at))
        ]
    ]))
    error_message = "Each entry in each user's temporary_grants must have a valid timestamp for its expires_at field."
  }
}