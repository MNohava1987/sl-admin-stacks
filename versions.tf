terraform {
  # Keep Terraform 1.5 for check block compatibility.
  required_version = "~> 1.5"

  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
      # Pin to provider minor for predictable behavior.
      version = "~> 1.44"
    }
  }
}
