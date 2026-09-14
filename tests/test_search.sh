#!/usr/bin/env bash
set -euo pipefail
PY=$(command -v python3)
echo "Testing search examples"
out1=$($PY examples/08_search/01_linear/linear_search.py)
echo "$out1" | grep -q "index of 4 -> 3"
echo "$out1" | grep -q "index of 2 -> -1"

out2=$($PY examples/08_search/02_binary/binary_search.py)
echo "$out2" | grep -q "iter index of 4 -> 3"
echo "$out2" | grep -q "rec index of 4 -> 3"

echo "search tests passed"
