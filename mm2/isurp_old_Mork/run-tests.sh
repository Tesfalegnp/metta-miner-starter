#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

MORK_BIN="${MORK_BIN:-$(command -v mork || echo "$ROOT_DIR/../MORK/target/release/mork")}"
OUT_FILE="/tmp/isurp_old_conversion_test.out"

echo "================================================================="
echo "RUNNING ISURP-OLD CONVERSION TEST SUITE"
echo "================================================================="
echo "MORK Binary: $MORK_BIN"
echo "Test File:   $SCRIPT_DIR/test_suite.metta"
echo "Helpers:     $SCRIPT_DIR/isurp-old-helpers.metta"
echo "Main:        $SCRIPT_DIR/isurp-old.metta"
echo

# 1. Regression Test Suite
echo ">>> STEP 1: Running Core Helper & Algorithm Regression Suite..."
"$MORK_BIN" run "$SCRIPT_DIR/test_suite.metta" "$OUT_FILE" \
  --aux-path "$SCRIPT_DIR/isurp-old-helpers.metta" \
  --aux-path "$SCRIPT_DIR/isurp-old.metta" \
  --instrumentation 0

python3 -c "
with open('$OUT_FILE') as f:
    out = set(line.strip() for line in f if line.strip())

expected = [
    '(0.1111111111111111)',
    '(0.3333333333333333)',
    '(0.5)',
    '()',
    '(8)',
    '(1)',
    '(1 8)',
    '(2.5)',
    '(10)',
    '(24)',
    '(4)',
    '(3)',
    '(5)',
    '(0.19999999999999996)',
    '(0.0)',
    '(0.30000000000000004)',
    '(True)',
    '(False)'
]

missing = [exp for exp in expected if exp not in out]
if missing:
    print('FAILED! Missing assertions:', missing)
    exit(1)
print(f'ALL {len(expected)} CORE REGRESSION ASSERTIONS VERIFIED SUCCESSFULLY!')
"
echo

# 2. Targeted isurp-old_ Test Suite (Section 7)
echo ">>> STEP 2: Running Targeted isurp-old_ Tests..."
python3 "$SCRIPT_DIR/test_isurp_old_sub.py"
echo

# 3. Full Original End-to-End Test Suite (Section 6)
echo ">>> STEP 3: Running All 8 Original End-to-End Tests..."
python3 "$SCRIPT_DIR/test_original_suite.py"
echo

echo "================================================================="
echo "ALL TESTS (REGRESSION, UNIT, AND END-TO-END) PASSED PERFECTLY!"
echo "================================================================="
