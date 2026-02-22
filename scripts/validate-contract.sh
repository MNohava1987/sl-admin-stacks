#!/usr/bin/env bash

set -euo pipefail

# Resolve repository root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Starting High-Assurance Contract Validation in ${REPO_ROOT}..."

cd "${REPO_ROOT}"

# Validation Suite
echo "-> Initializing Terraform (no-backend)..."
terraform init -backend=false

echo "-> Verifying HCL formatting..."
terraform fmt -check -recursive

echo "-> Validating Terraform configuration..."
terraform validate

echo "Validation Successful."
