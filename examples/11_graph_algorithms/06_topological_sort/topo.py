#!/usr/bin/env python3
"""Topological sort using Kahn's algorithm."""

from typing import Dict, List


def kahn(adj: Dict[str, List[str]]):
    indeg = {u:0 for u in adj}
    for u in adj:
        for v in adj[u]:
            indeg[v] = indeg.get(v,0)+1
    q = [u for u in indeg if indeg[u]==0]
    order = []
    while q:
        u = q.pop(0)
        order.append(u)
        for v in adj.get(u, []):
            indeg[v] -= 1
            if indeg[v] == 0:
                q.append(v)
    if len(order) != len(indeg):
        return None
    return order


def main():
    adj = {'A':['B','C'],'B':['D'],'C':['D'],'D':[]}
    print('topo ->', kahn(adj))


if __name__ == '__main__':
    main()
