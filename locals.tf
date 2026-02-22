locals {
  tool_data = yamldecode(file("${path.module}/manifests/tooling.yaml"))

  # Raw lookup for strict contract checks.
  # No default means we can detect true key absence.
  raw_tools_key = lookup(local.tool_data, "tools", "MISSING_KEY")

  cfg_enable_component           = try(local.tool_data.settings.enable_component, true)
  cfg_enable_auto_deploy         = try(local.tool_data.settings.enable_auto_deploy, var.enable_auto_deploy)
  cfg_enable_deletion_protection = try(local.tool_data.settings.enable_deletion_protection, var.enable_deletion_protection)
  cfg_repave_mode                = try(local.tool_data.settings.repave_mode, var.repave_mode)

  # Safe fallbacks for generation paths.
  raw_tools = try(
    [for t in local.tool_data.tools : t],
    []
  )
  enabled_raw_tools = [
    for t in local.raw_tools : t
    if try(t.enabled, true)
  ]

  # Helper values used by checks.
  tool_names           = [for t in local.enabled_raw_tools : try(t.name, "unnamed")]
  tool_names_lower     = [for n in local.tool_names : lower(n)]
  tool_repositories    = [for t in local.enabled_raw_tools : try(t.repository, "")]
  tool_assurance_tiers = [for t in local.enabled_raw_tools : try(t.assurance_tier, "")]
  tool_role_profiles   = [for t in local.enabled_raw_tools : try(t.role_profile, "")]

  # Resource input map. Skip unnamed entries.
  tools = {
    for t in local.enabled_raw_tools : t.name => merge(t, {
      role_profile = try(t.role_profile, "")
      branch       = try(t.branch, var.branch_main)
      project_root = try(t.project_root, var.default_tool_project_root)
      autodeploy   = try(t.autodeploy, local.cfg_enable_auto_deploy)
      protect      = try(t.protect_from_deletion, local.cfg_enable_deletion_protection)
    })
    if local.cfg_enable_component && try(t.name, "") != ""
  }

  role_profile_to_role_id = {
    for profile, slug in var.role_profile_role_slugs : profile => data.spacelift_role.role_by_slug[slug].id
  }

  # Variables propagated to child stacks.
  replicated_vars = {
    "TF_VAR_environment_name"                  = var.environment_name
    "TF_VAR_assurance_tier"                    = var.assurance_tier
    "TF_VAR_naming_org"                        = var.naming_org
    "TF_VAR_naming_domain"                     = var.naming_domain
    "TF_VAR_naming_function_env_root_space"    = var.naming_function_env_root_space
    "TF_VAR_admin_sub_space_name"              = var.admin_sub_space_name
    "TF_VAR_naming_function_tool_orchestrator" = var.naming_function_tool_orchestrator
    "TF_VAR_repave_mode"                       = tostring(local.cfg_repave_mode)
    "TF_VAR_enable_deletion_protection"        = tostring(local.cfg_enable_deletion_protection)
  }

  tool_function_tokens = [
    for name in local.tool_names_lower :
    "${name}-${var.naming_function_tool_orchestrator}"
  ]

  tool_stack_names = {
    for name, _ in local.tools :
    name => "${var.naming_org}-${lower(var.environment_name)}-${var.naming_domain}-${lower(name)}-${var.naming_function_tool_orchestrator}"
  }

  tool_stack_slugs = {
    for name, _ in local.tools :
    name => lower(local.tool_stack_names[name])
  }

  tool_dependency_pairs = flatten([
    for t in local.enabled_raw_tools : [
      for dep in try(t.depends_on_tools, []) : {
        stack      = t.name
        depends_on = dep
      }
    ] if try(t.name, "") != ""
  ])

  tool_dependency_edges = {
    for dep in local.tool_dependency_pairs : "${dep.stack}->${dep.depends_on}" => dep
    if local.cfg_enable_component && dep.stack != dep.depends_on && contains(keys(local.tools), dep.stack) && contains(keys(local.tools), dep.depends_on)
  }

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
