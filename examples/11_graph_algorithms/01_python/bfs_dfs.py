#!/usr/bin/env python3
"""BFS and DFS demo implementations."""

from collections import deque
from typing import Dict, List, Set


def bfs(adj: Dict[str, List[str]], start: str) -> List[str]:
    q = deque([start])
    seen: Set[str] = {start}
    order = []
    while q:
        v = q.popleft()
        order.append(v)
        for w in adj.get(v, []):
            if w not in seen:
                seen.add(w)
                q.append(w)
    return order


def dfs(adj: Dict[str, List[str]], start: str) -> List[str]:
    seen: Set[str] = set()
    order: List[str] = []

    def _dfs(v: str):
        seen.add(v)
        order.append(v)
        for w in adj.get(v, []):
            if w not in seen:
                _dfs(w)

    _dfs(start)
    return order


def main():
    adj = {'A':['B','C'],'B':['C'],'C':['D'],'D':[]}
    print('bfs A ->', bfs(adj,'A'))
    print('dfs A ->', dfs(adj,'A'))


if __name__ == '__main__':
    main()
