variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

variable "admin_space_id" {
  type = string
}

variable "vcs_integration_id" {
  type        = string
  description = "GitHub VCS integration id"
}

variable "repo_platformspaces" {
  type    = string
  default = "sl-admin-platformspaces"
}

variable "repo_modulespaces" {
  type    = string
  default = "sl-admin-modulespaces"
}

variable "repo_policies" {
  type    = string
  default = "sl-admin-policies"
}

variable "branch_main" {
  type    = string
  default = "main"
}
