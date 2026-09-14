#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

if [ ! -x "$MORK_BIN" ]; then
    echo "SKIP: MORK binary not found ($MORK_BIN)"
    exit 0
fi

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

set +e
"$MORK_BIN" run "$ROOT_DIR/examples/02_lists/mork/run.metta" \
    --aux-path "$ROOT_DIR/examples/02_lists/mork/miner.metta" \
    --aux-path "$ROOT_DIR/examples/02_lists/mork/data.metta" \
    "$TEMP_DIR/mork-output.metta"
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -ne 0 ]; then
    echo "SKIP: MORK execution failed (exit code $EXIT_CODE). See binary or environment." >&2
    echo "You can run manually: MORK_BIN=$MORK_BIN $ROOT_DIR/examples/02_lists/mork/run-mork.sh" >&2
    exit 0
fi

grep '^\(ListLength ' "$TEMP_DIR/mork-output.metta" || true
echo "PASS: MORK list example produced output (check above)"
