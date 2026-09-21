#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$ROOT_DIR/tests/learning/python-list"
OUT_DIR="${OUT_DIR:-/tmp/metta-miner-python-list-tests}"

DEFAULT_MORK_BIN="$ROOT_DIR/../MORK/target/release/mork"

if [[ -z "${MORK_BIN:-}" ]]; then
  if command -v mork >/dev/null 2>&1; then
    MORK_BIN="$(command -v mork)"
  elif [[ -x "$DEFAULT_MORK_BIN" ]]; then
    MORK_BIN="$DEFAULT_MORK_BIN"
  else
    echo "ERROR: mork binary not found." >&2
    echo "Set MORK_BIN=/path/to/mork and retry." >&2
    exit 1
  fi
fi

mkdir -p "$OUT_DIR"

echo "=========================================="
echo "PYTHON-LIST MM2/MORK TEST RUNNER"
echo "=========================================="
echo "MORK: $MORK_BIN"
echo "Tests: $TEST_DIR"
echo

total=0
failures=0

run_case() {
  local case_file="$1"
  local test_name
  test_name="$(basename "$case_file")"
  local out_file="$OUT_DIR/${test_name%.metta}.out.metta"
  local aux_args=()
  local aux_path

  total=$((total + 1))

  while IFS= read -r aux_path || [[ -n "$aux_path" ]]; do
    [[ -z "$aux_path" ]] && continue
    if [[ "$aux_path" != /* ]]; then
      aux_path="$ROOT_DIR/$aux_path"
    fi
    aux_args+=("--aux-path" "$aux_path")
  done < <(sed -n 's/^;; TEST-AUX[[:space:]]\{1,\}//p' "$case_file")

  printf "%-35s " "RUN $test_name..."

  if ! "$MORK_BIN" run "$case_file" "$out_file" "${aux_args[@]}" --steps 100000 --instrumentation 0 >/dev/null 2>&1; then
    echo "FAIL (MORK execution failed)"
    failures=$((failures + 1))
    return
  fi

  # Verify expected results using python S-expression extractor
  local verify_output
  if ! verify_output="$(python3 -c '
import sys, re

case_file = sys.argv[1]
out_file = sys.argv[2]

with open(case_file) as f:
    text = f.read()

# Remove comments
cleaned = "\n".join(l.split(";")[0] for l in text.splitlines())

# Extract (EXPECTED-RESULT <id> <fact>)
# Find top-level s-expressions
tokens = []
i = 0
n = len(cleaned)

expected_list = []
while i < n:
    if cleaned[i].isspace():
        i += 1
        continue
    if cleaned[i] == "(":
        start = i
        depth = 0
        while i < n:
            if cleaned[i] == "(":
                depth += 1
            elif cleaned[i] == ")":
                depth -= 1
                if depth == 0:
                    i += 1
                    break
            i += 1
        sexpr = cleaned[start:i].strip()
        if sexpr.startswith("(EXPECTED-RESULT"):
            # Normalize whitespace within sexpr
            inner = sexpr[len("(EXPECTED-RESULT"): -1].strip()
            parts = inner.split(None, 1)
            if len(parts) == 2:
                test_id, expected_fact = parts[0], " ".join(parts[1].split())
                expected_list.append((test_id, expected_fact))
    else:
        i += 1

if not expected_list:
    print("NO_ASSERTIONS")
    sys.exit(2)

with open(out_file) as f:
    out_lines = set(" ".join(line.strip().split()) for line in f if line.strip())

missing = []
for test_id, fact in expected_list:
    if fact not in out_lines:
        missing.append((test_id, fact))

if missing:
    for test_id, fact in missing:
        print(f"MISSING: {test_id} -> {fact}")
    sys.exit(1)

print(f"OK:{len(expected_list)}")
' "$case_file" "$out_file")"; then
    echo "FAIL"
    echo "$verify_output" | sed 's/^/  [x] /'
    failures=$((failures + 1))
  else
    local count="${verify_output#OK:}"
    echo "PASS ($count assertions verified)"
  fi
}

for case_file in "$TEST_DIR"/*-test.metta; do
  [[ -f "$case_file" ]] || continue
  run_case "$case_file"
done

echo
echo "=========================================="
echo "Summary: $((total - failures))/$total passed, $failures failed."
echo "=========================================="

if [[ "$failures" -ne 0 ]]; then
  exit 1
fi
