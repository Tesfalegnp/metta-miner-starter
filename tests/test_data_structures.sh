#!/usr/bin/env bash
set -euo pipefail
echo "Running data-structures and related example smoke tests"

PYTHON=$(command -v python3 || true)
if [ -z "$PYTHON" ]; then
  echo "python3 not found" >&2
  exit 2
fi

echo "-> 08_search linear"
${PYTHON} examples/08_search/01_linear/linear_search.py | sed -n '1,2p'

echo "-> 08_search binary"
${PYTHON} examples/08_search/02_binary/binary_search.py | sed -n '1,2p'

echo "-> 09_graph_basics edge list"
${PYTHON} examples/09_graph_basics/01_edge_list/edge_list.py | sed -n '1,2p'

echo "-> 10_pattern_matching python"
${PYTHON} examples/10_pattern_matching/02_python/match_demo.py | sed -n '1p'

echo "-> 11_graph_algorithms bfs/dfs"
${PYTHON} examples/11_graph_algorithms/01_python/bfs_dfs.py | sed -n '1,2p'
echo "-> 07_data_structures tree traversals"
${PYTHON} examples/07_data_structures/04_trees/tree.py | sed -n '1,3p'


echo "All smoke tests executed"
