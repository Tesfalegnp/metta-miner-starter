#!/usr/bin/env python3
"""Iterative and recursive DFS demos."""

from typing import Dict, List, Set


def dfs_recursive(adj: Dict[str, List[str]], start: str) -> List[str]:
    seen = set()
    order = []

    def _dfs(v):
        seen.add(v)
        order.append(v)
        for w in adj.get(v, []):
            if w not in seen:
                _dfs(w)

    _dfs(start)
    return order


def dfs_iterative(adj: Dict[str, List[str]], start: str) -> List[str]:
    stack = [start]
    seen = set([start])
    order = []
    while stack:
        v = stack.pop()
        order.append(v)
        for w in adj.get(v, []):
            if w not in seen:
                seen.add(w)
                stack.append(w)
    return order


def main():
    adj = {'A':['B','C'],'B':['D'],'C':['D'],'D':[]}
    print('dfs rec ->', dfs_recursive(adj,'A'))
    print('dfs itr ->', dfs_iterative(adj,'A'))


if __name__ == '__main__':
    main()
