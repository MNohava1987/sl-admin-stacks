# Regional Tooling Orchestration

# 1. Dynamically create the administrative management stacks (Tier 2)
resource "spacelift_stack" "tooling" {
  for_each = local.tools

  name        = "${each.value.name}-orchestrator"
  slug        = "${lower(var.environment_name)}-${each.value.name}"
  description = "${each.value.description} for the ${var.environment_name} environment"
  
  space_id   = data.spacelift_space_by_path.admin.id
  repository = each.value.repository
  branch     = var.branch_main

  autodeploy            = var.enable_auto_deploy
  enable_local_preview  = true
  protect_from_deletion = var.enable_deletion_protection

  # High Assurance Governance Labels
  labels = [
    "stack-type:management",
    "assurance:${each.value.assurance_tier}",
    "environment:${lower(var.environment_name)}",
    "governance:env-guard"
  ]
}

# 2. Modern RBAC: Grant Tools power over the environment root
resource "spacelift_role_attachment" "tooling_admin" {
  for_each = local.tools

  stack_id = spacelift_stack.tooling[each.key].id
  role_id  = data.spacelift_role.space_admin.id
  space_id = data.spacelift_space_by_path.env_root.id
}

# 3. Automatically inject foundational configuration into all children
resource "spacelift_environment_variable" "child_vars" {
  for_each = local.stack_vars

  stack_id   = each.value.stack_id
  name       = each.value.name
  value      = each.value.value
  write_only = false
}

# --- 4) HIGH ASSURANCE VALIDATION ---

check "tooling_governance" {
  assert {
    condition     = alltrue([for s in spacelift_stack.tooling : contains(s.labels, "stack-type:management")])
    error_message = "All administrative tools MUST be labeled as 'stack-type:management'."
  }
}
