# sl-admin-stacks

This repo is the **router**: it defines and creates the other admin stacks.

Design rule:
- This repo should NOT hardcode generated IDs from other environments.
- It should accept IDs from bootstrap (admin space id) or create resources directly.

For a personal trial, it's reasonable to have this one stack manage most of the org objects.
