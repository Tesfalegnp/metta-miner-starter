#!/usr/bin/env bash
set -euo pipefail
PY=$(command -v python3)
echo "Testing graph basics"
${PY} examples/09_graph_basics/01_edge_list/edge_list.py | grep -q "adj list ->"
${PY} examples/09_graph_basics/02_adjacency_list/adjacency_list.py | grep -q "adj ->"
${PY} examples/09_graph_basics/03_adjacency_matrix/adjacency_matrix.py | sed -n '1,2p'
echo "Running MORK graph example (may require MORK_BIN env)"
bash examples/09_graph_basics/05_mork_mm2/run.sh | sed -n '1,3p'
echo "graph basics tests passed"
