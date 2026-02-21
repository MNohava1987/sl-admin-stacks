# Child stacks created in Admin space

resource "spacelift_stack" "platformspaces" {
  name               = "admin-platformspaces"
  space_id            = var.admin_space_id
  repository          = var.repo_platformspaces
  branch              = var.branch_main
  # Removed explicit VCS integration ID to let Spacelift use the default GitHub integration.
  # github_enterprise_id = var.vcs_integration_id
  terraform_workflow_tool = "TERRAFORM"
}

resource "spacelift_stack" "modulespaces" {
  name               = "admin-modulespaces"
  space_id            = var.admin_space_id
  repository          = var.repo_modulespaces
  branch              = var.branch_main
  # Removed explicit VCS integration ID to let Spacelift use the default GitHub integration.
  # github_enterprise_id = var.vcs_integration_id
  terraform_workflow_tool = "TERRAFORM"
}

resource "spacelift_stack" "policies" {
  name               = "admin-policies"
  space_id            = var.admin_space_id
  repository          = var.repo_policies
  branch              = var.branch_main
  # Removed explicit VCS integration ID to let Spacelift use the default GitHub integration.
  # github_enterprise_id = var.vcs_integration_id
  terraform_workflow_tool = "TERRAFORM"
}
