# Spacelift Admin Stacks Orchestrator

This repository serves as the primary orchestrator for the Spacelift management plane. It is responsible for creating and managing all downstream administrative stacks and spaces.

## Overview

The orchestrator manages the following components:
1. **Platform Spaces**: Environment-specific spaces (Dev, Test, Prod) for workload isolation.
2. **Module Spaces**: Dedicated spaces for internal infrastructure modules.
3. **Global Policies**: Account-wide OPA/Rego policies for governance and guardrails.

## Repository Structure

```text
.
├── .spacelift/          # Spacelift-specific configuration and hooks
├── docs/                # Detailed guides for management plane evolution
├── stacks.tf            # Definitions for downstream administrative stacks
├── variables.tf         # Input definitions with modern HCL formatting
├── providers.tf         # Provider configuration
└── versions.tf          # Version constraints for Terraform and Spacelift
```

## Management Flow

1. This stack is created by the `sl-root-bootstrap` process.
2. It resides in the **Admin** space.
3. It must be granted **Administrative** permissions (or appropriate RBAC roles) to manage downstream resources.

## Configuration

This stack requires Spacelift API credentials and VCS integration details to function. These are typically injected via environment variables (`TF_VAR_*`) in the Spacelift UI or via CLI.
