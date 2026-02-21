# Orchestrator Operations Guide

This document explains how to manage and scale the Spacelift administrative fleet.

## High-to-Low Assurance Model
This repository acts as the **Tier 1 Orchestrator**. 
- **Tier 0 (Bootstrap)**: Manual seed, creates this orchestrator.
- **Tier 1 (Admin Stacks)**: Automates the creation of all administrative "Spaces" and "Policies".
- **Tier 2 (Platform/Modules)**: Manages actual cloud resources and developer modules.

## Adding a New Administrative Stack
To add a new stack to the management plane (e.g., `admin-blueprints`):

1. Open `variables.tf`.
2. Add the stack to the `child_management_stacks` map:
   ```hcl
   "admin-blueprints" = { repository = "sl-admin-blueprints" }
   ```
3. Commit and push.

**Result**: The orchestrator will create the stack and automatically inject all required API keys and VCS configurations. No manual setup is required for the new child.

## Handling a Repave
If the management plane is destroyed:
1. Run the `sl-root-bootstrap` repave process.
2. Once the `admin-stacks` orchestrator is restored, trigger its deployment.
3. It will restore all child stacks (`platformspaces`, `modulespaces`, `policies`) and restore their environment variables from its own state.
