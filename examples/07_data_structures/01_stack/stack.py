#!/usr/bin/env python3
"""Simple stack implementation and demo."""

class Stack:
    def __init__(self):
        self._data = []

    def push(self, v):
        self._data.append(v)

    def pop(self):
        return self._data.pop() if self._data else None

    def peek(self):
        return self._data[-1] if self._data else None

    def is_empty(self):
        return len(self._data) == 0


def main():
    s = Stack()
    s.push(1)
    s.push(2)
    s.push(3)
    print('peek ->', s.peek())
    print('pop ->', s.pop())
    print('pop ->', s.pop())
    print('empty ->', s.is_empty())


if __name__ == '__main__':
    main()
#!/usr/bin/env python3
"""Simple Python stack demonstration."""

from typing import List, Any


class Stack:
    def __init__(self) -> None:
        self._data: List[Any] = []

    def push(self, x: Any) -> None:
        self._data.append(x)

    def pop(self) -> Any:
        return self._data.pop()

    def peek(self) -> Any:
        return self._data[-1] if self._data else None

    def is_empty(self) -> bool:
        return not self._data


def main() -> None:
    s = Stack()
    s.push(1)
    s.push(2)
    s.push(3)
    print("peek:", s.peek())
    print("pop:", s.pop())
    print("pop:", s.pop())
    print("is_empty:", s.is_empty())
    print("pop:", s.pop())
    print("is_empty:", s.is_empty())


if __name__ == "__main__":
    main()
