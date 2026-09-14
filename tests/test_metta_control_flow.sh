#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Running MeTTa control-flow demos..."
python3 "$ROOT_DIR/examples/03_control_flow/metta/run_control.py"
echo "PASS: MeTTa control-flow demos ran without error"
