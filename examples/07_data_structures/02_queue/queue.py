#!/usr/bin/env python3
"""Simple queue implementation and demo."""

from collections import deque


class Queue:
    def __init__(self):
        self._q = deque()

    def enqueue(self, v):
        self._q.append(v)

    def dequeue(self):
        return self._q.popleft() if self._q else None

    def is_empty(self):
        return len(self._q) == 0


def main():
    q = Queue()
    q.enqueue('a')
    q.enqueue('b')
    q.enqueue('c')
    print('dequeue ->', q.dequeue())
    print('dequeue ->', q.dequeue())
    print('empty ->', q.is_empty())


if __name__ == '__main__':
    main()
#!/usr/bin/env python3
"""Simple Python queue demonstration."""

from typing import Deque, Any
from collections import deque


class Queue:
    def __init__(self) -> None:
        self._d: Deque[Any] = deque()

    def enqueue(self, x: Any) -> None:
        self._d.append(x)

    def dequeue(self) -> Any:
        return self._d.popleft()

    def front(self) -> Any:
        return self._d[0] if self._d else None

    def is_empty(self) -> bool:
        return not self._d


def main() -> None:
    q = Queue()
    q.enqueue('a')
    q.enqueue('b')
    q.enqueue('c')
    print('front:', q.front())
    print('dequeue:', q.dequeue())
    print('dequeue:', q.dequeue())
    print('is_empty:', q.is_empty())
    print('dequeue:', q.dequeue())
    print('is_empty:', q.is_empty())


if __name__ == '__main__':
    main()
