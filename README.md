# Spacelift Admin Stacks Orchestrator

This repository serves as the primary orchestrator for the Spacelift management plane. It follows a "High Assurance" pattern to dynamically manage and secure all downstream administrative stacks.

## Overview

The orchestrator manages the following components:
1. **Platform Spaces**: Environment-specific spaces (Dev, Test, Prod) for workload isolation.
2. **Module Spaces**: Dedicated spaces for internal infrastructure modules.
3. **Global Policies**: Account-wide OPA/Rego policies for governance and guardrails.

## High Assurance Features

- **Self-Aware Space Lookup**: Uses `data.spacelift_space_by_path` to resolve its location dynamically, eliminating hardcoded IDs.
- **Automated Secret Propagation**: Automatically injects API keys and VCS configurations into all child stacks via `locals.tf` logic.
- **Data-Driven Management**: Stacks are managed via a central map in `variables.tf`, allowing for easy scaling.

## Repository Structure

```text
.
├── .spacelift/          # Quality gates and formatting hooks
├── docs/                # Operational and scale guides
├── main.tf              # Primary stack and variable resource definitions
├── data.tf              # Dynamic resource lookups (Space IDs)
├── locals.tf            # Complex transformation logic for child stacks
├── variables.tf         # Input definitions and child stack registry
├── outputs.tf           # Orchestrator status and resolved IDs
├── providers.tf         # Provider configuration
└── versions.tf          # Version constraints
```

## Management Flow

1. This stack is created by the `sl-root-bootstrap` process.
2. It resides in the **Admin** space.
3. It must be granted **Administrative** permissions in its Behavior settings to manage downstream resources.

## Operational Instructions

See [docs/OPERATIONS.md](docs/OPERATIONS.md) for detailed instructions on adding new stacks or handling management plane recovery.
