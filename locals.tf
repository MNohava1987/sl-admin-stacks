locals {
  tool_data = yamldecode(file("${path.module}/manifests/tooling.yaml"))
  tools     = { for t in try(local.tool_data.tools, []) : t.name => t }

  # These variables are replicated into all child tools to ensure 
  # they have the regional context needed to manage their own sub-resources.
  replicated_vars = {
    "TF_VAR_environment_name" = var.environment_name
    "TF_VAR_assurance_tier"   = var.assurance_tier
  }

  # Flattens the nested map for use in a single resource block.
  # Key format: tool_name.variable_name
  stack_vars = merge([
    for tool_key, tool in spacelift_stack.tooling : {
      for var_key, var_val in local.replicated_vars : "${tool_key}.${var_key}" => {
        stack_id = tool.id
        name     = var_key
        value    = var_val
      }
    }
  ]...)
}
