#!/usr/bin/env python3
"""Edge list example."""

edges = [('A','B'),('B','C'),('A','C')]

def neighbors(edge_list):
    d = {}
    for a,b in edge_list:
        d.setdefault(a, []).append(b)
    return d

def main():
    print('edges ->', edges)
    print('adj list ->', neighbors(edges))

if __name__ == '__main__':
    main()
