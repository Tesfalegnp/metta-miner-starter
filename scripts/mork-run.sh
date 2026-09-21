#!/usr/bin/env bash
# ================================================================
# MORK Runner Helper
#
# Runs any .metta file with MORK. If the file contains ';; TEST-AUX'
# references, it automatically loads those auxiliary dependencies.
#
# Usage:
#     ./scripts/mork-run.sh <path/to/file.metta>
# ================================================================

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_MORK_BIN="$ROOT_DIR/../MORK/target/release/mork"

if [[ -z "${MORK_BIN:-}" ]]; then
  if command -v mork >/dev/null 2>&1; then
    MORK_BIN="$(command -v mork)"
  elif [[ -x "$DEFAULT_MORK_BIN" ]]; then
    MORK_BIN="$DEFAULT_MORK_BIN"
  elif [[ -x "$HOME/.local/bin/mork" ]]; then
    MORK_BIN="$HOME/.local/bin/mork"
  else
    echo "ERROR: mork binary not found." >&2
    echo "Set MORK_BIN=/path/to/mork and retry." >&2
    exit 1
  fi
fi

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <file.metta>"
  exit 1
fi

INPUT_FILE="$1"
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "ERROR: File not found: $INPUT_FILE" >&2
  exit 1
fi

# Detect any ;; TEST-AUX annotations if present
aux_args=()
while IFS= read -r aux_path || [[ -n "$aux_path" ]]; do
  [[ -z "$aux_path" ]] && continue
  if [[ "$aux_path" != /* ]]; then
    aux_path="$ROOT_DIR/$aux_path"
  fi
  aux_args+=("--aux-path" "$aux_path")
done < <(sed -n 's/^;; TEST-AUX[[:space:]]\{1,\}//p' "$INPUT_FILE")

"$MORK_BIN" run "$INPUT_FILE" "${aux_args[@]}" --steps 100000 --instrumentation 0
