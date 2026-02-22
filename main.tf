# Tier-2 administrative tooling stacks for one environment.
resource "spacelift_stack" "tooling" {
  for_each = local.tools

  name        = local.tool_stack_names[each.key]
  description = "${each.value.description} for the ${var.environment_name} environment"

  # Deterministic canonical slug avoids account-level collisions.
  slug = local.tool_stack_slugs[each.key]

  space_id     = data.spacelift_space_by_path.admin.id
  repository   = each.value.repository
  branch       = each.value.branch
  project_root = each.value.project_root

  autodeploy           = each.value.autodeploy
  enable_local_preview = true
  # DANGER: If false, these management stacks can be deleted.
  # Keep true for normal operations.
  protect_from_deletion = each.value.protect

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

# Execute in-stack destroys before deleting Tier-2 tooling stacks during repave.
resource "spacelift_stack_destructor" "tooling" {
  for_each = spacelift_stack.tooling

  stack_id = each.value.id

  discard_runs = true
  deactivated  = !var.repave_mode

  depends_on = [
    spacelift_role_attachment.tooling_admin,
    spacelift_environment_variable.child_vars
  ]
}
