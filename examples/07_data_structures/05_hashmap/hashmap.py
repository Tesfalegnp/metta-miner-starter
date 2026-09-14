#!/usr/bin/env python3
"""Simple hashmap (wrapper around dict) demo."""

class HashMap:
    def __init__(self):
        self._d = {}

    def set(self, k, v):
        self._d[k] = v

    def get(self, k, default=None):
        return self._d.get(k, default)

    def keys(self):
        return list(self._d.keys())


def main():
    hm = HashMap()
    hm.set('a', 1)
    hm.set('b', 2)
    print('keys ->', sorted(hm.keys()))
    print('get a ->', hm.get('a'))


if __name__ == '__main__':
    main()
#!/usr/bin/env python3
"""Simple dict/hash map demo."""

def main() -> None:
    d = {'a': 1, 'b': 2}
    print('get a ->', d.get('a'))
    d['c'] = 3
    print('keys ->', sorted(d.keys()))


if __name__ == '__main__':
    main()
