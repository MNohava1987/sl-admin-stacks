# Admin Tool Candidates

Candidate tooling for `manifests/tooling.yaml` fanout.

## Current Direction

This list is for planning only. Promote candidates into `manifests/tooling.yaml` once design, ownership, and guardrails are approved.

## Candidates

### `drift-auditor`

- Focus: detect and report configuration drift and policy drift.
- Why it fits Tier-2: centralized governance signal for all admin stacks.

### `runner-pool-manager`

- Focus: worker pool lifecycle, sizing, and label strategy.
- Why it fits Tier-2: shared orchestration dependency across tooling stacks.

### `context-profile-manager`

- Focus: context and variable baseline distribution for tool stacks.
- Why it fits Tier-2: reduces per-tool duplication and config drift.

### `integration-broker`

- Focus: VCS/cloud/notification integration standards.
- Why it fits Tier-2: enforces consistent integration posture by environment.

### `incident-automation`

- Focus: workflow automation for failed applies, policy denials, and critical alerts.
- Why it fits Tier-2: operational response belongs in management-plane automation.
