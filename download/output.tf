locals {
  data      = yamldecode(data.etcd_key.users.value)
  users_raw = local.data.users
  now       = timestamp()

  users = var.prune_expired_grants ? [
    for user in local.data.users: merge(user, {
      temporary_grants = [
        for grant in try(user.temporary_grants, []) : grant
        if timecmp(grant.expires_at, local.now) >= 0
      ]
    })
  ] : local.users_raw

  users_by_role = {for role in local.data.roles: role => [for user in local.users: user if user.role == role]}
  users_by_environment = {for env in local.data.environments: env => [for user in local.users: user if contains(user.environments, env)]}
}

output "roles" {
  description = "List of roles."
  value       = local.data.roles
}

output "environments" {
  description = "List of environments."
  value       = local.data.environments
}

output "users" {
  description = "List of users."
  value       = local.users
}

output "users_raw" {
  description = "List of users without pruning expired temporary grants."
  value       = local.users_raw
}

output "users_by_role" {
  description = "Map of filtered users lists with the roles as key."
  value       = local.users_by_role
}

output "users_by_environment" {
  description = "Map of filtered users lists with the environments as key."
  value       = local.users_by_environment
}
