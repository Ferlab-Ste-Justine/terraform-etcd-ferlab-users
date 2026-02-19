# About

This repo contains two conveninence modules to store and retrieve a centralised list of ferlab users for a given project.

The module store and retrieves the following information:
- A list of valid roles
- A list of valid environments
- A list of users containing the following property for each entry:
  - username: Main identifier for the user
  - role: Role of the user
  - environments: List of environments the user has access to
  - attributes: A map of custom attributes that can be helpful to store various identifiers the user has in other systems (ex: github user)
  - temporary_grants: A list of user-specific temporary grants that a user may have. Each entry in the list have the following keys...
    - name: Name of the grant
    - scope: Additional context to where the grand applies
    - expires_at: A timestamp in ISO 8601 format (ex: 2026-11-30T00:00:00Z)that indicates when the grant should be pruned from the user's grant list

For example, a users list may look like this:
```
- username: stuard
  role: dev
  attributes:
    github_user: stuartme
  environments: [qa, staging, prod]
- username: clack
  role: analyst
  attributes:
    rstudio_user: "1021"
  environments: [qa, staging]
  temporary_grants:
    - name: read_indices
      scope: postgres_prod
      expires_at: "2026-11-30T00:00:00Z"
    - name: read_logs
      scope: opensearch_ops
      expires_at: "2025-11-30T00:00:00Z"
- username: grom
  role: admin
  environments: [qa, staging, prod]
```

# Modules

The repo has the following two modules:

## upload

Module to upload the users list. It includes some sanity checks to make sure the provided list is consistent with expectations.

### Inputs

The module has the following inputs:
- **etcd_key**: Etcd key where the centralised lists of users, roles and environments will be stored
- **environments**: List of valid environments for the project. Note that the module will return an error if an environment assigned to a user is not found in this list
- **roles**: List of valid roles for the project. Note that the module will return an error if a role assigned to a user is not in this list
- **required_attributes**: Map of required user attributes for various roles (role names as they key and a list of expected attribute keys are the value). Note that the module will return an error if a user with a given role doesn't have all its required attribute keys defined.
- **users**: List of users. Each entry is equivalent to the yaml user structure showed above (ie, if you had the above yaml list as a file, read did in terraform and did yamldecode on it, you could pass the result as an argument here). Note that a sanity check will be performed on the grants expiry timestamps to be sure they are in a format that terraform can process.

## download

Module to download the lists of users, roles and environments from etcd that were passed to the upload module.

Some extra convenience processing is done to automatically trim expired grands as determined by the local time of the machine and provide maps of users, filtered by role and environment.

## Inputs

The module has the following inputs:
- **etcd_key**: Etcd key where the centralised lists of users, roles and environments is stored

## Outputs

The module has the following outputs:
- **roles**: List of roles
- **environments**: List of environments
- **users**: List of users whose format is the same as the users for the **upload** modules (but with expired grants trimmed out)
- **users_raw**: List of users without pruning expired temporary grants
- **users_by_role**: Filtered map of users, with roles being the input key of the map which gives a list of users with the given role
- **users_by_environment**: Filtered map of users, with environments being the input key of the map which gives a list of users with access to the given environment as value
