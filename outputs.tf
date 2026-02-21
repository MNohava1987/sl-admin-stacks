output "orchestrated_stacks" {
  description = "The IDs of the regional tools created by this orchestrator."
  value       = [for s in spacelift_stack.tooling : s.id]
}

output "admin_space_id" {
  description = "The dynamically resolved ID of the admin sub-space."
  value       = data.spacelift_space_by_path.admin.id
}

output "env_root_id" {
  description = "The ID of the parent environment container."
  value       = data.spacelift_space_by_path.env_root.id
}
