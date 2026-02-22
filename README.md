# Spacelift Admin Stacks Orchestrator (Tier 1)

This repository runs the Tier-1 orchestrator for a single environment (for example `live` or `test`). It deploys and governs Tier-2 admin tooling stacks from a manifest.

## Purpose

The orchestrator bridges the gap between the foundation and the workloads. It is responsible for:
1. Deploying Tier 2 administrative stacks (Platform Spaces, Policies, etc.) defined in the manifest.
2. Granting child tools administrative authority over their regional environment.
3. Propagating regional context (Environment Name, Assurance Tier) to all child resources.

## Architecture: Manifest-Driven Tooling

The tooling catalog is manifest-driven in `manifests/tooling.yaml`.
Space discovery follows the same naming catalog as root bootstrap by default:
- Environment root path: `root/sl-<env>-mgmt-env-root-space`
- Admin sub-space path: `root/sl-<env>-mgmt-env-root-space/admin`
- Bootstrap should inject:
  - `TF_VAR_naming_org`
  - `TF_VAR_naming_domain`
  - `TF_VAR_naming_function_env_root_space`
  - `TF_VAR_admin_sub_space_name`
  to keep Tier-1 lookups aligned with Tier-0 naming.

## Operational Workflow

### Scaling the Arsenal
Add or remove tools by editing the `manifests/tooling.yaml` file. The orchestrator will automatically synchronize the state during the next run. Ensure the following standards are met:
- `manifest_version` must be a supported version (default: `"1"`).
- Tool names should be unique (case-insensitive) and lowercase by default.
- Every tool must declare a `role_profile` (for example `space-manager` or `policy-manager`).
- Role profiles resolve to role slugs through `var.role_profile_role_slugs` (override from bootstrap role catalog outputs).

### Local Validation
Execute the high-assurance validation gate from any directory in the repo before committing:
`./scripts/assurance-gate.sh`

## Governance

This stack must be labeled with `assurance:tier-1` and `stack-type:management` to trigger the appropriate organizational guardrails. Its children are autonomously labeled as `assurance:tier-2`.
