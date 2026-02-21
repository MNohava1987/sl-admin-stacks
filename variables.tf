variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

variable "admin_space_id" {
  type        = string
  description = "The ID of the Admin space where stacks will be created"
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
  # Empty map causes destruction of all managed child stacks
  default = {}
}
