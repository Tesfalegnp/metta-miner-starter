#!/usr/bin/env python3
"""Adjacency matrix example for a small graph."""

nodes = ['A','B','C','D']
idx = {n:i for i,n in enumerate(nodes)}
edges = [('A','B'),('A','C'),('C','D'),('B','D')]

def build_matrix(nodes, edges):
    n = len(nodes)
    m = [[0]*n for _ in range(n)]
    for a,b in edges:
        m[idx[a]][idx[b]] = 1
    return m

def main():
    m = build_matrix(nodes, edges)
    print('nodes ->', nodes)
    print('matrix ->')
    for row in m:
        print(row)

if __name__ == '__main__':
    main()
