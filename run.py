"""Run the baseline MeTTa Pattern Miner implementation."""

from pathlib import Path

from hyperon import MeTTa


PROJECT_DIR = Path(__file__).resolve().parent
METTA_DIR = PROJECT_DIR / "metta"


def load_program(metta: MeTTa, filename: str) -> None:
    """Add a MeTTa source file to the current knowledge space."""
    source = (METTA_DIR / filename).read_text(encoding="utf-8")
    metta.run(source)


def query_people(metta: MeTTa, pattern: str) -> list[str]:
    """Evaluate a MeTTa query and return a stable, readable list of matches."""
    results = metta.run(f"!{pattern}")
    return sorted(str(atom) for atom in results[0])


def main() -> None:
    metta = MeTTa()
    load_program(metta, "data.metta")
    load_program(metta, "miner.metta")

    soda_people = query_people(metta, "(human-soda-pattern &self)")
    pizza_people = query_people(metta, "(human-pizza-pattern &self)")
    soda_pizza_people = query_people(metta, "(human-soda-pizza-pattern &self)")
    print("==========================================")
    print("PATTERN MINER - METTA")
    print("==========================================")

    for title, people in (
        ("Soda", soda_people),
        ("Pizza", pizza_people),
        ("Soda + Pizza", soda_pizza_people),
    ):
        print()
        print(f"{title}:")
        print(people)
        print("Support:", len(people))

    minimum_support = 2
    print()
    print(f"Minimum support: {minimum_support}")
    for pattern, people in (
        ("Soda", soda_people),
        ("Pizza", pizza_people),
        ("SodaPizza", soda_pizza_people),
    ):
        frequency = "Frequent" if len(people) >= minimum_support else "Infrequent"
        print(f"(PatternResult {pattern} {len(people)} {frequency})")

    print()
    print("==========================================")
    print("METTA COMPLETE")
    print("==========================================")


if __name__ == "__main__":
    main()
