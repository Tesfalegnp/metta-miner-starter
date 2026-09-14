#!/usr/bin/env python3
"""Binary search (iterative and recursive) demo."""

from typing import List


def binary_search_iter(arr: List[int], target: int) -> int:
    lo, hi = 0, len(arr)-1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target:
            return mid
        if arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1


def binary_search_rec(arr: List[int], target: int, lo: int, hi: int) -> int:
    if lo > hi:
        return -1
    mid = (lo + hi) // 2
    if arr[mid] == target:
        return mid
    if arr[mid] < target:
        return binary_search_rec(arr, target, mid+1, hi)
    return binary_search_rec(arr, target, lo, mid-1)


def main() -> None:
    arr = [1,2,3,4,5]
    print('iter index of 4 ->', binary_search_iter(arr, 4))
    print('rec index of 4 ->', binary_search_rec(arr, 4, 0, len(arr)-1))


if __name__ == '__main__':
    main()
