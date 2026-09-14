#!/usr/bin/env python3
"""Singly linked list demo."""

class Node:
    def __init__(self, val, nxt=None):
        self.val = val
        self.next = nxt


class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, v):
        if not self.head:
            self.head = Node(v)
            return
        cur = self.head
        while cur.next:
            cur = cur.next
        cur.next = Node(v)

    def to_list(self):
        out = []
        cur = self.head
        while cur:
            out.append(cur.val)
            cur = cur.next
        return out


def main():
    ll = LinkedList()
    ll.append(1)
    ll.append(2)
    ll.append(3)
    print('list ->', ll.to_list())


if __name__ == '__main__':
    main()
#!/usr/bin/env python3
"""Simple singly linked list demonstration."""

from typing import Optional


class Node:
    def __init__(self, value: int, nxt: Optional['Node'] = None) -> None:
        self.value = value
        self.next = nxt


class LinkedList:
    def __init__(self) -> None:
        self.head: Optional[Node] = None

    def insert_front(self, v: int) -> None:
        self.head = Node(v, self.head)

    def find(self, v: int) -> bool:
        cur = self.head
        while cur:
            if cur.value == v:
                return True
            cur = cur.next
        return False

    def traverse(self) -> list[int]:
        out = []
        cur = self.head
        while cur:
            out.append(cur.value)
            cur = cur.next
        return out


def main() -> None:
    ll = LinkedList()
    ll.insert_front(3)
    ll.insert_front(2)
    ll.insert_front(1)
    print('traverse:', ll.traverse())
    print('find 2:', ll.find(2))
    print('find 4:', ll.find(4))


if __name__ == '__main__':
    main()
