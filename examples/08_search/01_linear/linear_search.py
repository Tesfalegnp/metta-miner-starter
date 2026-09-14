#!/usr/bin/env python3
"""Linear search demo."""

from typing import List


def linear_search(arr: List[int], target: int) -> int:
    for i, v in enumerate(arr):
        if v == target:
            return i
    return -1


def main() -> None:
    arr = [5,3,1,4]
    print('index of 4 ->', linear_search(arr, 4))
    print('index of 2 ->', linear_search(arr, 2))


if __name__ == '__main__':
    main()
