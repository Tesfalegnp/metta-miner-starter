#!/usr/bin/env python3
"""Runner for MeTTa functions examples."""

from pathlib import Path
from hyperon import MeTTa

ROOT = Path(__file__).resolve().parents[1]


def _eval_print(metta: MeTTa, expr: str) -> None:
    """Evaluate an expression `expr` (like "(inc 1)") and print the
    first resulting atom if present, otherwise print a blank line.
    We use the `!` query prefix to ask MeTTa to evaluate the expression.
    """
    results = metta.run(f"!{expr}")
    if results and results[0]:
        # Print the first result in a readable form
        print(results[0][0])
    else:
        print()


def main() -> None:
    metta = MeTTa()
    # load the function library (rules and facts)
    lib_source = (ROOT / "metta" / "function_lib.metta").read_text(
        encoding="utf-8"
    )
    metta.run(lib_source)

    print("--- Demonstrate basic function: inc 1 -> 2 ---")
    _eval_print(metta, "(inc 1)")

    print("--- Demonstrate multiple params: add 1 2 -> 3 ---")
    _eval_print(metta, "(add 1 2)")

    print("--- Demonstrate nested call: inc (inc 1) ---")
    _eval_print(metta, "(inc (inc 1))")

    print("--- Demonstrate doubleinc via function ---")
    _eval_print(metta, "(doubleinc 1)")

    print("--- Demonstrate compose inc ∘ inc on 1 ---")
    _eval_print(metta, "(compose inc inc 1)")

    print("--- Demonstrate higher-order map with inc ---")
    _eval_print(metta, "(map inc (Cons 1 (Cons 2 Nil)))")

    print("--- Demonstrate pair ---")
    _eval_print(metta, "(pair 1 2)")


if __name__ == "__main__":
    main()
