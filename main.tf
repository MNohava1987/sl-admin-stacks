# Primary Orchestration Resources

# 1. Dynamically create the administrative management stacks
resource "spacelift_stack" "management" {
  for_each = var.child_management_stacks

  name                 = each.key
  space_id             = data.spacelift_space_by_path.admin.id
  repository           = each.value.repository
  branch               = each.value.branch
  autodeploy           = var.enable_auto_deploy
  administrative       = true
  enable_local_preview = true

  # Uses default GitHub integration linked to the Spacelift account
}

# 2. Automatically inject foundational configuration into all children
resource "spacelift_environment_variable" "child_vars" {
  for_each = local.stack_vars

  stack_id   = each.value.stack_id
  name       = each.value.name
  value      = each.value.value
  write_only = each.value.secret
}
