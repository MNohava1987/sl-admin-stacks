# The name of the environment this orchestrator owns (e.g. "Live", "Test")
# This is injected by the Tier 0 bootstrap stack.
variable "environment_name" {
  type        = string
  description = "Name of the environment container"
}

# The assurance tier of this environment (e.g. "tier-2" for critical)
# This is used to correctly label child stacks for policy enforcement.
variable "assurance_tier" {
  type        = string
  description = "The assurance tier of the parent environment"
}

variable "branch_main" {
  type    = string
  default = "main"
}

variable "enable_auto_deploy" {
  type        = bool
  default     = false
  description = "Enables auto-deploy for Tier 2 administrative tools"
}

variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "Toggles deletion protection for Tier 2 administrative stacks"
}
