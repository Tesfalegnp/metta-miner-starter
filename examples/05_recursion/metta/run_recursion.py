#!/usr/bin/env python3
"""Runner for MeTTa recursion examples."""

from pathlib import Path
from hyperon import MeTTa

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    metta = MeTTa()
    # load the recursion library which itself loads list_lib
    lib_source = (ROOT / "metta" / "recursion_lib.metta").read_text(
        encoding="utf-8"
    )
    metta.run(lib_source)
    def _eval_print(expr: str) -> None:
        results = metta.run(f"!{expr}")
        if results and results[0]:
            print(results[0][0])
        else:
            print()

    print("--- Factorial examples (Peano) ---")
    _eval_print("(fact Zero)")
    _eval_print("(fact (Succ Zero))")
    _eval_print("(fact (Succ (Succ Zero)))")

    print("--- Fibonacci examples (Peano) ---")
    _eval_print("(fib Zero)")
    _eval_print("(fib (Succ Zero))")
    _eval_print("(fib (Succ (Succ Zero)))")

    print("--- Sum of list ---")
    _eval_print(
        "(sum_list (Cons (Succ Zero) (Cons (Succ (Succ Zero)) (Cons (Succ (Succ (Succ Zero))) Nil))))"
    )

    print("--- Reverse list ---")
    _eval_print(
        "(reverse (Cons (Succ Zero) (Cons (Succ (Succ Zero)) (Cons (Succ (Succ (Succ Zero))) Nil))))"
    )

    print("--- Preorder tree traversal ---")
    _eval_print(
        "(preorder (Node (Succ Zero) (Node (Succ (Succ Zero)) (Nil) (Nil)) (Node (Succ (Succ (Succ Zero))) (Nil) (Nil))))"
    )


if __name__ == "__main__":
    main()
