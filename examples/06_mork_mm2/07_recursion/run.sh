#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

OUT="$ROOT_DIR/tmp/mork-rec-output.metta"
mkdir -p "$(dirname "$OUT")"

"$MORK_BIN" run "$ROOT_DIR/examples/06_mork_mm2/07_recursion/run.metta" \
    --aux-path "$ROOT_DIR/examples/06_mork_mm2/07_recursion/rec_rules.metta" \
    --aux-path "$ROOT_DIR/examples/06_mork_mm2/07_recursion/rec_data.metta" \
    "$OUT"

echo "$OUT"
