variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

# admin_space_id removed - now handled by data lookup in stacks.tf

variable "vcs_integration_id" {
  type        = string
  description = "GitHub VCS integration id"
}

variable "branch_main" {
  type    = string
  default = "main"
}

variable "child_management_stacks" {
  type = map(object({
    repository = string
    branch     = optional(string, "main")
  }))
  default = {
    "admin-platformspaces" = { repository = "sl-admin-platformspaces" }
    "admin-modulespaces"   = { repository = "sl-admin-modulespaces" }
    "admin-policies"       = { repository = "sl-admin-policies" }
  }
}
