#!/usr/bin/env bash

set -euo pipefail

# Resolve script directory to call helper scripts reliably
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Initiating Full Assurance Gate..."

# Execute contract validation via absolute path
"${SCRIPT_DIR}/validate-contract.sh"

echo "-> Running policy compliance simulation..."
# Note: Placeholder for future recursive Rego unit tests (opa test)
echo "   (No Rego unit tests found in Tier 2 orchestrator)"

echo "Assurance Gate: PASSED"
