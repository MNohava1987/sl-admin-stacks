locals {
  env_root_space_name = "${var.naming_org}-${lower(var.environment_name)}-${var.naming_domain}-${var.naming_function_env_root_space}"
}

# Resolve the admin sub-space for this environment.
data "spacelift_space_by_path" "admin" {
  space_path = "root/${local.env_root_space_name}/${var.admin_sub_space_name}"
}

# Resolve environment root space for downstream role attachments.
data "spacelift_space_by_path" "env_root" {
  space_path = "root/${local.env_root_space_name}"
}

# Resolve role slugs referenced by role profiles.
data "spacelift_role" "role_by_slug" {
  for_each = toset(values(var.role_profile_role_slugs))
  slug     = each.key
}
