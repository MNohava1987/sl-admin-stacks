variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

# The name of the environment this orchestrator owns (e.g. "Prod", "Staging")
# This is injected by the bootstrap stack.
variable "environment_name" {
  type        = string
  description = "Name of the environment container"
}

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
    "admin-modulestacks"   = { repository = "sl-admin-modulestacks" }
  }
}

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Enables auto-deploy for child management stacks"
}
