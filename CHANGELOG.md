# Changelog

All notable changes to the Spacelift Admin Stacks Orchestrator will be documented in this file.

## [1.2.0] - 2026-02-22
### Changed
- Aligned Terraform comments with `sl-root-bootstrap` style: short, direct, and operational.
- Standardized section header language in `checks.tf`.
- Normalized provider/version commentary for readability and consistency.
- Updated README and Operations wording to match current manifest-driven contract language.

### Fixed
- Strengthened deletion-protection warnings in code and variable descriptions.
- Aligned manifest version examples and defaults to `"1"` across docs, variables, and `manifests/tooling.yaml`.

## [1.1.0] - 2026-02-21
### Added
- High-Assurance Manifest Orchestration: Regional tools are now fully data-driven via `manifests/tooling.yaml`.
- Strict Contract Validation: Implemented Terraform `check` blocks to enforce manifest versioning, type safety (list vs null), field completeness, and case-insensitive uniqueness.
- Keyless RBAC Model: Transitioned all Tier 2 stacks to modern `spacelift_role_attachment` resources, removing hardcoded API keys.
- Local Assurance Gates: Added path-safe scripts for offline contract validation and quality checks using `init -backend=false`.
- Regional Context Propagation: Automatically injects environment names and assurance tiers into all orchestrated tools.
- Modernized Documentation: Rewrote root README and Operations Manual to reflect manifest-driven workflow and naming standards.

### Fixed
- Provider Inconsistency: Aligned `providers.tf` with the worker-authentication model, resolving undeclared variable errors.
- Slug Conflicts: Standardized deterministic lowercase slug generation to prevent account-level naming collisions.
- Baseline Cleanup: Standardized HCL formatting across the entire repository.

---

## [1.0.0] - 2026-02-20
### Added
- Initial orchestrator structure for Platform, Module, and Policy stacks.
- Professional directory structure and documentation.
- Automated code quality hooks via Spacelift configuration.
- Standardized HCL formatting for all Terraform resources.
- Modern Spacelift Provider compatibility.
