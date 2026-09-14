"""Integration test for MeTTa functions examples."""

from __future__ import annotations

from pathlib import Path
import subprocess
import sys


ROOT_DIR = Path(__file__).resolve().parents[1]


def main() -> None:
    completed = subprocess.run(
        [sys.executable, "examples/04_functions/metta/run_functions.py"],
        cwd=ROOT_DIR,
        check=True,
        capture_output=True,
        text=True,
    )
    expected = (ROOT_DIR / "tests" / "expect_functions.text").read_text(
        encoding="utf-8"
    )

    if completed.stdout != expected:
        raise AssertionError(
            "MeTTa functions output differs from expect_functions.text.\n"
            f"Expected:\n{expected}\nActual:\n{completed.stdout}"
        )

    print("PASS: MeTTa functions output matches expect_functions.text")


if __name__ == "__main__":
    main()
