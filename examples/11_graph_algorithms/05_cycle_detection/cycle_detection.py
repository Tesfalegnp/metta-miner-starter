#!/usr/bin/env python3
"""Cycle detection for undirected and directed graphs."""

from typing import Dict, List


def has_cycle_undirected(adj: Dict[str, List[str]]):
    seen = set()

    def dfs(v, parent):
        seen.add(v)
        for w in adj.get(v, []):
            if w == parent:
                continue
            if w in seen:
                return True
            if dfs(w, v):
                return True
        return False

    for v in adj:
        if v not in seen:
            if dfs(v, None):
                return True
    return False


def has_cycle_directed(adj: Dict[str, List[str]]):
    seen = set()
    stack = set()

    def dfs(v):
        seen.add(v)
        stack.add(v)
        for w in adj.get(v, []):
            if w not in seen:
                if dfs(w):
                    return True
            elif w in stack:
                return True
        stack.remove(v)
        return False

    for v in adj:
        if v not in seen:
            if dfs(v):
                return True
    return False


def main():
    undirected = {'A':['B'],'B':['A','C'],'C':['B']}
    directed = {'A':['B'],'B':['C'],'C':['A']}
    print('undirected has cycle ->', has_cycle_undirected(undirected))
    print('directed has cycle ->', has_cycle_directed(directed))


if __name__ == '__main__':
    main()
