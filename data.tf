# Dynamic lookup for the Admin space based on the environment name.
# Path format: root/<environment_name>/Admin
data "spacelift_space_by_path" "admin" {
  space_path = "root/${var.environment_name}/Admin"
}

# Lookup for the Environment Root (to pass down to children)
data "spacelift_space_by_path" "env_root" {
  space_path = "root/${var.environment_name}"
}
