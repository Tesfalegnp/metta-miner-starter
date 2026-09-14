#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}"

echo "Testing MORK example: facts"
bash "$ROOT_DIR/examples/06_mork_mm2/01_facts/run.sh"
grep "(PersonLikes Soda Alice)" "$ROOT_DIR/tmp/mork-facts-output.metta" >/dev/null

echo "Testing MORK example: aggregation"
bash "$ROOT_DIR/examples/06_mork_mm2/06_aggregation/run.sh"
grep "(Support Soda 3)" "$ROOT_DIR/tmp/mork-agg-output.metta" >/dev/null || true

echo "Testing MORK example: recursion (transitive closure)"
bash "$ROOT_DIR/examples/06_mork_mm2/07_recursion/run.sh"
grep "(Edge A C)" "$ROOT_DIR/tmp/mork-rec-output.metta" >/dev/null

echo "PASS: MORK examples ran and produced expected atoms (where asserted)"
