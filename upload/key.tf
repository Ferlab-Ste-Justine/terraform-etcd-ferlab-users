resource "etcd_key" "users" {
  key   = var.etcd_key
  value = yamlencode({
    users = var.users
    roles = var.roles
    environments = var.environments
  })

  lifecycle {
    precondition {
      condition     = local.users_roles_valid && local.users_environments_valid && local.users_have_required_attributes
      error_message = "Either a user role is invalid, a user's environment is invalid or a user is missing required attributes for their roles"
    }
  }
}