#!/usr/bin/env python3
"""Runner to execute the MeTTa list examples using Hyperon MeTTa."""

from pathlib import Path
from hyperon import MeTTa


ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    metta = MeTTa()
    # Run the main demo and the extended demo
    for fname in ("run.metta", "run_more.metta", "copy_demo.metta"):
        source = (ROOT / "metta" / fname).read_text(encoding="utf-8")
        metta.run(source)


if __name__ == "__main__":
    main()
