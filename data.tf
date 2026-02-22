# Resolve the admin sub-space for this environment.
data "spacelift_space_by_path" "admin" {
  space_path = "root/${var.environment_name}/admin"
}

# Resolve environment root space for downstream role attachments.
data "spacelift_space_by_path" "env_root" {
  space_path = "root/${var.environment_name}"
}

# Resolve role slugs referenced by role profiles.
data "spacelift_role" "role_by_slug" {
  for_each = toset(values(var.role_profile_role_slugs))
  slug     = each.key
}
