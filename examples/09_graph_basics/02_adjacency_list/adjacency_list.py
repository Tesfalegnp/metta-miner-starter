#!/usr/bin/env python3
"""Adjacency list example for a fixed graph."""

edges = [('A','B'),('A','C'),('C','D'),('B','D')]

def build_adj(edges):
    adj = {}
    for a,b in edges:
        adj.setdefault(a, []).append(b)
        adj.setdefault(b, [])
    return adj

def main():
    adj = build_adj(edges)
    print('edges ->', edges)
    print('adj ->', adj)

if __name__ == '__main__':
    main()
