#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Change this if your MORK binary is installed elsewhere.
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

echo "=========================================="
echo "PATTERN MINER - MORK / MM2"
echo "=========================================="
echo
echo "MORK executable:"
echo "$MORK_BIN"

if [ ! -x "$MORK_BIN" ]; then
    echo
    echo "ERROR: MORK executable was not found."
    echo
    echo "Set MORK_BIN to the MORK executable, for example:"
    echo
    echo "export MORK_BIN=/path/to/MORK/target/release/mork"
    exit 1
fi

echo
echo "Running MORK/MM2 program..."
echo

"$MORK_BIN" run "$PROJECT_DIR/mork/run.metta" \
    --aux-path "$PROJECT_DIR/mork/miner.metta" \
    --aux-path "$PROJECT_DIR/mork/data.metta"
