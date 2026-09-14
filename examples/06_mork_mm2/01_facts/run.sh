#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

OUT="$ROOT_DIR/tmp/mork-facts-output.metta"
mkdir -p "$(dirname "$OUT")"

echo "Running MORK facts example with $MORK_BIN"

"$MORK_BIN" run "$ROOT_DIR/examples/06_mork_mm2/01_facts/run.metta" \
    --aux-path "$ROOT_DIR/examples/06_mork_mm2/01_facts/derive_rule.metta" \
    --aux-path "$ROOT_DIR/examples/06_mork_mm2/01_facts/facts.metta" \
    "$OUT"

echo "Wrote $OUT"
