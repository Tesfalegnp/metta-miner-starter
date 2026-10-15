#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

MORK_BIN="${MORK_BIN:-$(command -v mork || echo "$ROOT_DIR/../MORK/target/release/mork")}"
OUT_FILE="/tmp/isurp_old_conversion_test.out"

echo "=========================================="
echo "RUNNING ISURP-OLD CONVERSION TEST SUITE"
echo "=========================================="
echo "MORK Binary: $MORK_BIN"
echo "Test File:   $SCRIPT_DIR/test_suite.metta"
echo "Helpers:     $SCRIPT_DIR/isurp-old-helpers.metta"
echo "Main:        $SCRIPT_DIR/isurp-old.metta"
echo

"$MORK_BIN" run "$SCRIPT_DIR/test_suite.metta" "$OUT_FILE" \
  --aux-path "$SCRIPT_DIR/isurp-old-helpers.metta" \
  --aux-path "$SCRIPT_DIR/isurp-old.metta" \
  --instrumentation 0

echo "Output results from MORK:"
cat "$OUT_FILE"
echo
echo "Verifying expected results..."
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
print(f'ALL {len(expected)} CORE ASSERTIONS VERIFIED SUCCESSFULLY!')
"
