#!/usr/bin/env python3
"""Runner for MeTTa control-flow examples (uses Hyperon MeTTa)."""

from pathlib import Path
from hyperon import MeTTa

ROOT = Path(__file__).resolve().parents[1]

def main() -> None:
    metta = MeTTa()
    source = (ROOT / "metta" / "run.metta").read_text(encoding="utf-8")
    metta.run(source)

if __name__ == "__main__":
    main()
