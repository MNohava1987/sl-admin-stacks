locals {
  # These variables are replicated into all child stacks to ensure 
  # they have the credentials and context needed to manage their own sub-resources.
  replicated_vars = {
    "TF_VAR_vcs_integration_id"       = var.vcs_integration_id
    "TF_VAR_environment_name"         = var.environment_name
    "TF_VAR_spacelift_api_key_id"     = var.spacelift_api_key_id
    "TF_VAR_spacelift_api_key_secret" = var.spacelift_api_key_secret
  }

  # Flattens the nested map for use in a single resource block.
  # Key format: stack_name.variable_name
  stack_vars = merge([
    for stack_key, stack in spacelift_stack.management : {
      for var_key, var_val in local.replicated_vars : "${stack_key}.${var_key}" => {
        stack_id = stack.id
        name     = var_key
        value    = var_val
        secret   = can(regex("secret|key", var_key))
      }
    }
  ]...)
}
