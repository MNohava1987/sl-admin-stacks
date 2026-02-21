# Dynamic lookup for the admin space where these tools will reside.
# Path format: root/<environment_name>/admin
data "spacelift_space_by_path" "admin" {
  space_path = "root/${var.environment_name}/admin"
}

# Lookup for the Environment Root (to pass down to children)
# Child tools like platform-spaces need this to manage team sub-spaces.
data "spacelift_space_by_path" "env_root" {
  space_path = "root/${var.environment_name}"
}

# Resolve the Space Admin role ID for permission granting
data "spacelift_role" "space_admin" {
  slug = "space-admin"
}
