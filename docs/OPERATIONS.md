# Orchestrator Operations Manual

This guide covers operation of the `sl-admin-stacks` Tier-1 orchestrator.

## Managing the Tooling Arsenal

The regional management plane is driven by `manifests/tooling.yaml`. 
Space lookups use the root naming convention by default (`sl-<env>-mgmt-env-root-space` + `/admin`).
Tier-1 naming inputs should be injected by root bootstrap (`TF_VAR_naming_org`, `TF_VAR_naming_domain`, `TF_VAR_naming_function_env_root_space`, `TF_VAR_admin_sub_space_name`) to prevent drift.

### Manifest Standards:
- **Versioning**: `manifest_version` must match one of `supported_manifest_versions` (default: `"1"`).
- **Uniqueness**: Tool names are validated for case-insensitive uniqueness to prevent slug collisions.
- **Lowercase Policy**: By default, tool names must be lowercase. This can be toggled via the `enforce_lowercase_tool_names` variable.
- **Role Assignment**: Every tool must include `role_profile`. Profiles are validated against `allowed_role_profiles`.

### Adding a New Tool:
1. Open `manifests/tooling.yaml`.
2. Add a new tool entry under the `tools` list:
   ```yaml
   - name: "new-admin-tool"
     repository: "sl-admin-repo"
     description: "Description of the tool purpose"
     assurance_tier: "tier-2"
     role_profile: "stack-manager"
   ```
3. Commit and push the changes. The orchestrator will autonomously provision the new stack.

### Role Profile Mapping:
- Tool `role_profile` values are mapped to Spacelift role slugs via `role_profile_role_slugs` in `variables.tf`.
- During bootstrap, defaults can map profiles to `space-admin`.
- After bootstrap role catalog rollout, override this map from `sl-root-bootstrap` outputs (`role_profile_role_slugs` or `role_catalog` mapping strategy).

### Tooling Backlog:
Planning candidates for future tooling stacks are tracked in:
`docs/tooling/ADMIN_TOOL_CANDIDATES.md`

### Context Propagation:
The orchestrator automatically injects the following variables into every child tool:
- `TF_VAR_environment_name`: Injected from the parent environment.
- `TF_VAR_assurance_tier`: Injected based on the environment's criticality.

## Validation Workflow

Before merging changes to the arsenal, run the local validation gate:
`./scripts/assurance-gate.sh`

This script ensures that your HCL is valid and that your `tooling.yaml` manifest complies with the organizational contract.
