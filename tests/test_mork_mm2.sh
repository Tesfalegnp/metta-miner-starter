#!/usr/bin/env bash
# Integration test for the MORK/MM2 implementation.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

if [ ! -x "$MORK_BIN" ]; then
    echo "MORK executable not found: $MORK_BIN" >&2
    echo "Set MORK_BIN to the compiled MORK binary." >&2
    exit 1
fi

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

"$MORK_BIN" run "$ROOT_DIR/mork/run.metta" \
    --aux-path "$ROOT_DIR/mork/miner.metta" \
    --aux-path "$ROOT_DIR/mork/data.metta" \
    "$TEMP_DIR/mork-output.metta" >/dev/null

grep -E '^\((HumanLikes|Support|PatternResult) ' "$TEMP_DIR/mork-output.metta" | sort \
    > "$TEMP_DIR/actual-results.txt"

diff -u "$ROOT_DIR/tests/mork-expected-results.txt" "$TEMP_DIR/actual-results.txt"
echo "PASS: MORK/MM2 derived all expected pattern-mining results"
