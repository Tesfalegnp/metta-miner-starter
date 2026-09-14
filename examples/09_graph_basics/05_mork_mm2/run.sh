#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

OUT="$ROOT_DIR/tmp/mork-graph-output.metta"
mkdir -p "$(dirname "$OUT")"

echo "Running MORK reachability example with $MORK_BIN"

"$MORK_BIN" run "$ROOT_DIR/examples/09_graph_basics/05_mork_mm2/run.metta" \
    --aux-path "$ROOT_DIR/examples/09_graph_basics/05_mork_mm2/facts.metta" \
    --aux-path "$ROOT_DIR/examples/09_graph_basics/05_mork_mm2/rules.metta" \
    "$OUT"

echo "Wrote $OUT"
