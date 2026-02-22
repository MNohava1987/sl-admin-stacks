# --- Manifest Contracts ---

check "manifest_structure" {
  assert {
    condition     = local.raw_tools_key != "MISSING_KEY" && can(tolist(local.raw_tools_key))
    error_message = "The 'tools' key is missing from tooling.yaml or is not a valid list."
  }
}

check "manifest_version_support" {
  assert {
    # Validate raw value so missing keys fail clearly.
    condition     = contains(var.supported_manifest_versions, try(local.tool_data.manifest_version, "missing"))
    error_message = "The manifest_version defined in tooling.yaml is not supported or missing. Expected: ${join(", ", var.supported_manifest_versions)}"
  }
}

check "manifest_settings_flags_boolean" {
  assert {
    condition = alltrue([
      can(tobool(local.cfg_enable_component)),
      can(tobool(local.cfg_enable_auto_deploy)),
      can(tobool(local.cfg_enable_deletion_protection)),
      can(tobool(local.cfg_repave_mode))
    ])
    error_message = "tooling.yaml settings flags (enable_component, enable_auto_deploy, enable_deletion_protection, repave_mode) must be boolean."
  }
}

check "tool_name_uniqueness_case_insensitive" {
  assert {
    condition     = length(distinct(local.tool_names_lower)) == length(local.enabled_raw_tools)
    error_message = "Duplicate tool names (case-insensitive) detected in tooling.yaml. Names must be unique regardless of casing."
  }
}

check "tool_names_lowercase" {
  assert {
    condition     = !var.enforce_lowercase_tool_names || alltrue([for n in local.tool_names : n == lower(n)])
    error_message = "One or more tool names in tooling.yaml contain uppercase characters. Lowercase naming is enforced."
  }
}

check "tool_assurance_tier_validity" {
  assert {
    condition     = alltrue([for t in local.tool_assurance_tiers : contains(var.allowed_assurance_tiers, t)])
    error_message = "One or more tools carry an invalid 'assurance_tier'. Allowed: ${join(", ", var.allowed_assurance_tiers)}"
  }
}

check "tool_role_profile_validity" {
  assert {
    condition     = alltrue([for p in local.tool_role_profiles : contains(var.allowed_role_profiles, p)])
    error_message = "One or more tools carry an invalid 'role_profile'. Allowed: ${join(", ", var.allowed_role_profiles)}"
  }
}

check "role_profile_slug_safety" {
  assert {
    condition = alltrue([
      for profile, slug in var.role_profile_role_slugs :
      profile == "space-admin" || slug != "space-admin"
    ])
    error_message = "Non-admin role profiles must not map to space-admin."
  }
}

check "role_profile_slug_map_complete" {
  assert {
    condition     = alltrue([for profile in var.allowed_role_profiles : contains(keys(var.role_profile_role_slugs), profile)])
    error_message = "role_profile_role_slugs must define a slug for every profile listed in allowed_role_profiles."
  }
}

check "tool_required_fields_safe" {
  assert {
    condition = alltrue([
      for t in local.enabled_raw_tools : (
        try(t.name, "") != "" &&
        try(t.repository, "") != "" &&
        try(t.description, "") != "" &&
        try(t.assurance_tier, "") != "" &&
        try(t.role_profile, "") != "" &&
        try(t.branch, var.branch_main) != "" &&
        try(t.project_root, var.default_tool_project_root) != ""
      )
    ])
    error_message = "One or more tools in tooling.yaml are missing required fields (name, repository, description, assurance_tier, role_profile, branch, project_root)."
  }
}

check "tool_dependency_fields_safe" {
  assert {
    condition = alltrue([
      for t in local.enabled_raw_tools : (
        try(t.depends_on_tools, null) == null || can(tolist(t.depends_on_tools))
      )
    ])
    error_message = "depends_on_tools must be a list when provided in tooling.yaml."
  }
}

check "tool_dependencies_exist" {
  assert {
    condition = alltrue([
      for dep in local.tool_dependency_pairs : contains(keys(local.tools), dep.depends_on)
    ])
    error_message = "One or more depends_on_tools entries reference a tool that is not enabled/present in tooling.yaml."
  }
}

check "tool_dependencies_no_self_reference" {
  assert {
    condition     = alltrue([for dep in local.tool_dependency_pairs : dep.stack != dep.depends_on])
    error_message = "A tool cannot depend on itself via depends_on_tools."
  }
}

# --- Runtime Controls ---

check "naming_tokens_valid" {
  assert {
    condition = alltrue([
      can(regex(var.naming_token_regex, var.naming_org)),
      can(regex(var.naming_token_regex, var.naming_domain)),
      can(regex(var.naming_token_regex, var.naming_function_env_root_space)),
      can(regex(var.naming_token_regex, var.admin_sub_space_name)),
      can(regex(var.naming_token_regex, var.naming_function_tool_orchestrator)),
      alltrue([for n in local.tool_names_lower : can(regex(var.naming_token_regex, n))]),
      alltrue([for f in local.tool_function_tokens : can(regex(var.naming_token_regex, f))])
    ])
    error_message = "One or more naming tokens are invalid for the naming_token_regex contract."
  }
}

check "stack_names_and_slugs_length" {
  assert {
    condition = alltrue(concat(
      [for _, n in local.tool_stack_names : length(n) <= var.naming_max_length],
      [for _, s in local.tool_stack_slugs : length(s) <= var.naming_max_length]
    ))
    error_message = "Generated tooling stack name/slug exceeds naming_max_length."
  }
}

check "tooling_governance" {
  assert {
    condition     = alltrue([for s in spacelift_stack.tooling : contains(s.labels, "stack-type:management")])
    error_message = "All administrative tools MUST be labeled as 'stack-type:management' for git-flow enforcement."
  }
}

check "destructive_changes_require_repave_mode" {
  assert {
    condition     = local.cfg_enable_deletion_protection || local.cfg_repave_mode
    error_message = "Disabling deletion protection requires repave_mode=true for explicit operator intent."
  }
}
