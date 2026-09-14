#!/usr/bin/env python3
"""Set demo: basic operations."""

def main():
    s = set()
    s.add(1)
    s.add(2)
    s.add(2)
    print('set ->', sorted(list(s)))
    print('contains 1 ->', 1 in s)


if __name__ == '__main__':
    main()
#!/usr/bin/env python3
"""Simple set operations demo."""

def main() -> None:
    a = {1,2,3}
    b = {3,4}
    print('union ->', a | b)
    print('intersection ->', a & b)
    print('difference ->', a - b)


if __name__ == '__main__':
    main()
