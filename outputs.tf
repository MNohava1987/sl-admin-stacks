output "orchestrated_stacks" {
  description = "The IDs of the management stacks created by this orchestrator."
  value       = [for s in spacelift_stack.management : s.id]
}

output "target_space_id" {
  description = "The dynamically resolved ID of the Admin space."
  value       = data.spacelift_space_by_path.admin.id
}
