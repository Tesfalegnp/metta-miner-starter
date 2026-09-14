#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Running MeTTa list examples (requires hyperon)..."
python3 "$ROOT_DIR/examples/02_lists/metta/run_metta_examples.py"
echo "PASS: MeTTa list examples ran without error"
