#!/usr/bin/env python3
"""Shortest path in unweighted graph using BFS."""

from collections import deque
from typing import Dict, List


def bfs_shortest(adj: Dict[str, List[str]], start: str, goal: str):
    q = deque([start])
    parent = {start: None}
    while q:
        v = q.popleft()
        if v == goal:
            break
        for w in adj.get(v, []):
            if w not in parent:
                parent[w] = v
                q.append(w)
    if goal not in parent:
        return None
    path = []
    cur = goal
    while cur is not None:
        path.append(cur)
        cur = parent[cur]
    return list(reversed(path))


def main():
    adj = {'A':['B','C'],'B':['D'],'C':['D'],'D':[]}
    print('shortest A->D ->', bfs_shortest(adj,'A','D'))


if __name__ == '__main__':
    main()
