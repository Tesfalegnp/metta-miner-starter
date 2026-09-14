#!/usr/bin/env python3
"""Connected components using DFS."""

from typing import Dict, List


def components(adj: Dict[str, List[str]]):
    seen = set()
    comps = []

    def dfs(v, comp):
        seen.add(v)
        comp.append(v)
        for w in adj.get(v, []):
            if w not in seen:
                dfs(w, comp)

    for v in adj:
        if v not in seen:
            comp = []
            dfs(v, comp)
            comps.append(comp)
    return comps


def main():
    adj = {'A':['B'],'B':['A'],'C':['D'],'D':['C'],'E':[]}
    print('components ->', components(adj))


if __name__ == '__main__':
    main()
