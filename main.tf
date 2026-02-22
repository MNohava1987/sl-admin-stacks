# Tier-2 administrative tooling stacks for one environment.
resource "spacelift_stack" "tooling" {
  for_each = local.tools

  name        = "${each.value.name}-orchestrator"
  description = "${each.value.description} for the ${var.environment_name} environment"

  # Deterministic lowercase slug avoids account-level collisions.
  slug = lower("${var.environment_name}-${each.value.name}")

  space_id   = data.spacelift_space_by_path.admin.id
  repository = each.value.repository
  branch     = var.branch_main

  autodeploy           = var.enable_auto_deploy
  enable_local_preview = true
  # DANGER: If false, these management stacks can be deleted.
  # Keep true for normal operations.
  protect_from_deletion = var.enable_deletion_protection

  # Governance labels used by policy controls.
  labels = [
    "stack-type:management",
    "assurance:${each.value.assurance_tier}",
    "environment:${lower(var.environment_name)}",
    "governance:env-guard"
  ]
}

# Attach tool stack role to the environment root space.
resource "spacelift_role_attachment" "tooling_admin" {
  for_each = local.tools

  stack_id = spacelift_stack.tooling[each.key].id
  role_id  = local.role_profile_to_role_id[each.value.role_profile]
  space_id = data.spacelift_space_by_path.env_root.id
}

# Inject inherited context into every child tooling stack.
resource "spacelift_environment_variable" "child_vars" {
  for_each = local.stack_vars

  stack_id   = each.value.stack_id
  name       = each.value.name
  value      = each.value.value
  write_only = false
}
