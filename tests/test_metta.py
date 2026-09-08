"""Integration test for the baseline Hyperon MeTTa implementation."""

from __future__ import annotations

from pathlib import Path
import subprocess
import sys

from hyperon import MeTTa


ROOT_DIR = Path(__file__).resolve().parents[1]


def main() -> None:
    completed = subprocess.run(
        [sys.executable, "run.py"],
        cwd=ROOT_DIR,
        check=True,
        capture_output=True,
        text=True,
    )
    expected = (ROOT_DIR / "expect.text").read_text(encoding="utf-8")

    if completed.stdout != expected:
        raise AssertionError(
            "MeTTa output differs from expect.text.\n"
            f"Expected:\n{expected}\nActual:\n{completed.stdout}"
        )

    match_source = (ROOT_DIR / "tests" / "test-metta-match.metta").read_text(
        encoding="utf-8"
    )
    match_results = MeTTa().run(match_source)
    people = sorted(str(atom) for atom in match_results[0])
    if people != ["Alice", "Bob", "Charlie"]:
        raise AssertionError(f"Unexpected MeTTa match result: {people}")

    print("PASS: MeTTa output matches expect.text")
    print("PASS: MeTTa match test found Alice, Bob, and Charlie")


if __name__ == "__main__":
    main()
