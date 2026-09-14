#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

if [ ! -x "$MORK_BIN" ]; then
    echo "MORK binary not found: $MORK_BIN" >&2
    echo "Skipping MORK list example." >&2
    exit 2
fi

"$MORK_BIN" run "$PROJECT_DIR/mork/run.metta" \
    --aux-path "$PROJECT_DIR/mork/miner.metta" \
    --aux-path "$PROJECT_DIR/mork/data.metta"
