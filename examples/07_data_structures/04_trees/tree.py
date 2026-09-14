#!/usr/bin/env python3
"""Binary tree with traversal demos: preorder, inorder, postorder."""

class Node:
    def __init__(self, val, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def preorder(node):
    return [] if node is None else [node.val] + preorder(node.left) + preorder(node.right)


def inorder(node):
    return [] if node is None else inorder(node.left) + [node.val] + inorder(node.right)


def postorder(node):
    return [] if node is None else postorder(node.left) + postorder(node.right) + [node.val]


def main():
    # build a small deterministic tree:
    #    A
    #   / \
    #  B   C
    # /     \
    # D       E
    d = Node('D')
    b = Node('B', left=d)
    e = Node('E')
    c = Node('C', right=e)
    a = Node('A', left=b, right=c)

    print('preorder ->', preorder(a))
    print('inorder  ->', inorder(a))
    print('postorder->', postorder(a))


if __name__ == '__main__':
    main()
