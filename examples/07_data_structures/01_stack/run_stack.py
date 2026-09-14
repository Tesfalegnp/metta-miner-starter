#!/usr/bin/env python3
"""Run MeTTa stack demo."""

from pathlib import Path
from hyperon import MeTTa

ROOT = Path(__file__).resolve().parents[3]


def main() -> None:
    metta = MeTTa()
    source = (ROOT / "examples" / "07_data_structures" / "01_stack" / "stack.metta").read_text(encoding="utf-8")
    metta.run(source)
    res = metta.run("!(peek-stack (StackCons 1 (StackCons 2 StackNil)))")
    if res and res[0]:
        print(res[0][0])


if __name__ == "__main__":
    main()
