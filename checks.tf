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

check "tool_name_uniqueness_case_insensitive" {
  assert {
    condition     = length(distinct(local.tool_names_lower)) == length(local.raw_tools)
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

check "role_profile_slug_map_complete" {
  assert {
    condition     = alltrue([for profile in var.allowed_role_profiles : contains(keys(var.role_profile_role_slugs), profile)])
    error_message = "role_profile_role_slugs must define a slug for every profile listed in allowed_role_profiles."
  }
}

check "tool_required_fields_safe" {
  assert {
    condition = alltrue([
      for t in local.raw_tools : (
        try(t.name, "") != "" &&
        try(t.repository, "") != "" &&
        try(t.description, "") != "" &&
        try(t.assurance_tier, "") != "" &&
        try(t.role_profile, "") != ""
      )
    ])
    error_message = "One or more tools in tooling.yaml are missing required fields (name, repository, description, assurance_tier, role_profile)."
  }
}

# --- Runtime Controls ---

check "tooling_governance" {
  assert {
    condition     = alltrue([for s in spacelift_stack.tooling : contains(s.labels, "stack-type:management")])
    error_message = "All administrative tools MUST be labeled as 'stack-type:management' for git-flow enforcement."
  }
}
