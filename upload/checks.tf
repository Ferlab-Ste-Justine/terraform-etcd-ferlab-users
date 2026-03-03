locals {
  users_roles_valid = alltrue([
    for user in var.users : alltrue([for role in user.roles : contains(var.roles, role)])
  ])
  users_environments_valid = alltrue([
    for user in var.users : alltrue([for env in user.environments : contains(var.environments, env)])
  ])
  users_have_required_attributes = alltrue(flatten([
    for role, req_attrs in var.required_attributes : [
      for user in var.users : 
        length(setintersection(keys(user.attributes), req_attrs)) == length(req_attrs)
        if contains(user.roles, role)
    ]
  ]))
}

check "users_roles_valid" {
  assert {
    condition = local.users_roles_valid
    error_message = "Each user's roles must be in var.roles."
  }
}

check "users_environments_valid" {
  assert {
    condition = local.users_environments_valid
    error_message = "Each entry in each user's environments must be in var.environments."
  }
}

check "users_have_required_attributes" {
  assert {
    condition = local.users_have_required_attributes
    error_message = "Some role-specific required attributes are missing for some users."
  }
}
