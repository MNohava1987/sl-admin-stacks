variable "environment_name" {
  type        = string
  description = "Environment name managed by this orchestrator."
}

variable "assurance_tier" {
  type        = string
  description = "Assurance tier of the parent environment."
}

variable "branch_main" {
  type    = string
  default = "main"
}

variable "default_tool_project_root" {
  type        = string
  default     = "/"
  description = "Default project_root for child tooling stacks when omitted in manifest."
}

variable "naming_org" {
  type        = string
  default     = "sl"
  description = "Organization token used by the naming convention."
}

variable "naming_domain" {
  type        = string
  default     = "mgmt"
  description = "Domain token used by the naming convention."
}

variable "naming_function_env_root_space" {
  type        = string
  default     = "env-root-space"
  description = "Function token for top-level environment root spaces."
}

variable "admin_sub_space_name" {
  type        = string
  default     = "admin"
  description = "Sub-space name used by Tier-1 orchestrators."
}

variable "naming_function_tool_orchestrator" {
  type        = string
  default     = "orchestrator"
  description = "Suffix token appended to tool name for <org>-<env>-<domain>-<function> stack naming."
}

variable "naming_token_regex" {
  type        = string
  default     = "^[a-z0-9]+(-[a-z0-9]+)*$"
  description = "Regex contract for naming tokens."
}

variable "naming_max_length" {
  type        = number
  default     = 63
  description = "Maximum length for generated stack names/slugs."
}

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Enable auto-deploy for Tier-2 administrative tools."
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "DANGER: If false, Tier-2 management stacks can be deleted. Keep true for normal operations."
}

variable "repave_mode" {
  type        = bool
  default     = true
  description = "Set true only for intentional teardown/repave operations when deletion protection is disabled."
}

# --- Contract Settings ---

variable "supported_manifest_versions" {
  type        = list(string)
  default     = ["1"]
  description = "Allowed versions for manifests/tooling.yaml."
}

variable "allowed_assurance_tiers" {
  type        = list(string)
  default     = ["tier-1", "tier-2", "tier-3"]
  description = "Allowed assurance tiers for child tools."
}

variable "enforce_lowercase_tool_names" {
  type        = bool
  default     = true
  description = "Enforces that all tool names in tooling.yaml must be lowercase."
}

variable "allowed_role_profiles" {
  type        = list(string)
  default     = ["stack-manager", "space-manager", "policy-manager", "readonly-auditor", "space-admin"]
  description = "Allowed role profiles for tools in manifests/tooling.yaml."
}

variable "role_profile_role_slugs" {
  type = map(string)
  default = {
    "stack-manager"    = "sl-mgmt-role-stack-manager"
    "space-manager"    = "sl-mgmt-role-space-manager"
    "policy-manager"   = "sl-mgmt-role-policy-manager"
    "readonly-auditor" = "sl-mgmt-role-readonly-auditor"
    "space-admin"      = "space-admin"
  }
  description = "Map of role profiles to Spacelift role slugs. Override from bootstrap outputs as custom roles are introduced."

  validation {
    condition     = contains(keys(var.role_profile_role_slugs), "space-admin")
    error_message = "role_profile_role_slugs must include a space-admin mapping for safe fallback behavior."
  }
}
