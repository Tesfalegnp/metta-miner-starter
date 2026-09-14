#!/usr/bin/env python3
"""Binary tree traversals (preorder, inorder, postorder)."""

from typing import Optional, List


class Node:
    def __init__(self, v: int, l: Optional['Node'] = None, r: Optional['Node'] = None) -> None:
        self.v = v
        self.l = l
        self.r = r


def preorder(root: Optional[Node]) -> List[int]:
    if not root:
        return []
    return [root.v] + preorder(root.l) + preorder(root.r)


def inorder(root: Optional[Node]) -> List[int]:
    if not root:
        return []
    return inorder(root.l) + [root.v] + inorder(root.r)


def postorder(root: Optional[Node]) -> List[int]:
    if not root:
        return []
    return postorder(root.l) + postorder(root.r) + [root.v]


def main() -> None:
    # Tree:    1
    #         /   \
    #        2     3
    #       / \   / \
    #      4   5 6   7
    root = Node(1, Node(2, Node(4), Node(5)), Node(3, Node(6), Node(7)))
    print('preorder:', preorder(root))
    print('inorder:', inorder(root))
    print('postorder:', postorder(root))


if __name__ == '__main__':
    main()
