#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Running MeTTa recursion demos..."
python3 "$ROOT_DIR/examples/05_recursion/metta/run_recursion.py"
echo "PASS: MeTTa recursion demos ran without error"
