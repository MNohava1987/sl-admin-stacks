# Data lookup for the Admin space by its consistent human-readable path.
# This prevents hardcoding random IDs that change during repave cycles.
data "spacelift_space_by_path" "admin" {
  space_path = "root/Admin"
}
