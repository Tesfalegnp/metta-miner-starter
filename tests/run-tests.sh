#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "$ROOT_DIR/tests/test_metta.py"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}" \
    "$ROOT_DIR/tests/test_mork_mm2.sh"
