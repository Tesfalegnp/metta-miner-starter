#!/usr/bin/env python3
"""Dijkstra's algorithm for non-negative weights."""

import heapq
from typing import Dict, List, Tuple


def dijkstra(adj: Dict[str, List[Tuple[str,int]]], start: str):
    dist = {start:0}
    prev = {}
    pq = [(0, start)]
    while pq:
        d,u = heapq.heappop(pq)
        if d>dist.get(u, float('inf')):
            continue
        for v,w in adj.get(u, []):
            nd = d + w
            if nd < dist.get(v, float('inf')):
                dist[v] = nd
                prev[v] = u
                heapq.heappush(pq, (nd, v))
    return dist, prev


def main():
    adj = {
        'A':[('B',1),('C',4)],
        'B':[('C',2),('D',5)],
        'C':[('D',1)],
        'D':[]
    }
    dist, prev = dijkstra(adj, 'A')
    print('dist ->', dist)
    print('prev ->', prev)


if __name__ == '__main__':
    main()
