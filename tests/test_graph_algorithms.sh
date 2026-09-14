#!/usr/bin/env bash
set -euo pipefail
PY=$(command -v python3)
echo "Testing graph algorithms"
${PY} examples/11_graph_algorithms/01_python/bfs_dfs.py | grep -q "bfs A ->"
${PY} examples/11_graph_algorithms/02_dfs/iterative_recursive.py | grep -q "dfs rec ->"
${PY} examples/11_graph_algorithms/03_shortest_path/bfs_shortest.py | grep -q "shortest A->D ->"
${PY} examples/11_graph_algorithms/04_connected_components/connected_components.py | grep -q "components ->"
${PY} examples/11_graph_algorithms/05_cycle_detection/cycle_detection.py | grep -q "undirected has cycle ->"
${PY} examples/11_graph_algorithms/06_topological_sort/topo.py | grep -q "topo ->"
${PY} examples/11_graph_algorithms/07_dijkstra/dijkstra.py | grep -q "dist ->"
echo "graph algorithms tests passed"
