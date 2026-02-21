# Dynamic Creation of Management Stacks
resource "spacelift_stack" "management" {
  for_each = var.child_management_stacks

  name                 = each.key
  space_id             = var.admin_space_id
  repository           = each.value.repository
  branch               = each.value.branch
  administrative       = true
  enable_local_preview = true

  # Removed explicit VCS integration ID to use default GitHub integration
}

# --- Automated Configuration Injection ---
locals {
  # List of variables to replicate into all children
  replicated_vars = {
    "TF_VAR_vcs_integration_id"       = var.vcs_integration_id
    "TF_VAR_admin_space_id"           = var.admin_space_id
    "TF_VAR_spacelift_api_key_id"     = var.spacelift_api_key_id
    "TF_VAR_spacelift_api_key_secret" = var.spacelift_api_key_secret
  }

  # Flattened map for for_each: stack_name.var_name
  stack_vars = merge([
    for stack_key, stack in spacelift_stack.management : {
      for var_key, var_val in locals.replicated_vars : "${stack_key}.${var_key}" => {
        stack_id = stack.id
        name     = var_key
        value    = var_val
        secret   = can(regex("secret|key", var_key))
      }
    }
  ]...)
}

resource "spacelift_environment_variable" "child_vars" {
  for_each = locals.stack_vars

  stack_id   = each.value.stack_id
  name       = each.value.name
  value      = each.value.value
  write_only = each.value.secret
}
