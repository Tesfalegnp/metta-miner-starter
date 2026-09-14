#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# run our extended smoke/unit tests first
bash "$ROOT_DIR/tests/test_data_structures.sh"
bash "$ROOT_DIR/tests/test_search.sh"
bash "$ROOT_DIR/tests/test_graph_basics.sh"
bash "$ROOT_DIR/tests/test_pattern_matching.sh"
bash "$ROOT_DIR/tests/test_graph_algorithms.sh"

python3 "$ROOT_DIR/tests/test_metta.py"
MORK_BIN="${MORK_BIN:-$HOME/Projects/MORK/target/release/mork}" \
    "$ROOT_DIR/tests/test_mork_mm2.sh"
bash "$ROOT_DIR/tests/test_mork_examples.sh"
