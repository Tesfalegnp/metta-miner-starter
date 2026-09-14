#!/usr/bin/env bash
set -euo pipefail
PY=$(command -v python3)
echo "Testing pattern matching examples"
${PY} examples/10_pattern_matching/02_python/match_demo.py | grep -q "Soda likers -> \['Alice'\]"
echo "pattern matching tests passed"
