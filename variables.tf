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

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Enable auto-deploy for Tier-2 administrative tools."
}

variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "DANGER: If false, Tier-2 management stacks can be deleted. Keep true for normal operations."
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
    "stack-manager"    = "space-admin"
    "space-manager"    = "space-admin"
    "policy-manager"   = "space-admin"
    "readonly-auditor" = "space-admin"
    "space-admin"      = "space-admin"
  }
  description = "Map of role profiles to Spacelift role slugs. Override from bootstrap outputs as custom roles are introduced."

  validation {
    condition     = contains(keys(var.role_profile_role_slugs), "space-admin")
    error_message = "role_profile_role_slugs must include a space-admin mapping for safe fallback behavior."
  }
}
