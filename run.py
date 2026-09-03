"""Run the Pattern Miner mini-project with the installed Hyperon runtime."""

from pathlib import Path

from hyperon import MeTTa


PROJECT_DIR = Path(__file__).resolve().parent


def load_program(metta: MeTTa, filename: str) -> None:
    """Add a MeTTa source file to the current knowledge space."""
    source = (PROJECT_DIR / filename).read_text(encoding="utf-8")
    metta.run(source)


def query_people(metta: MeTTa, pattern: str) -> list[str]:
    """Evaluate a MeTTa query and return a stable, readable list of matches."""
    results = metta.run(f"!{pattern}")
    return sorted(str(atom) for atom in results[0])


def print_pattern(title: str, people: list[str], support_title: str) -> None:
    print()
    print(f"--- {title} ---")
    print()
    print(f"[{', '.join(people)}]")
    print()
    print(f"--- {support_title} ---")
    print()
    print(len(people))


def main() -> None:
    metta = MeTTa()
    load_program(metta, "data.metta")
    load_program(metta, "miner.metta")

    soda_people = query_people(metta, "(human-soda-pattern &self)")
    pizza_people = query_people(metta, "(human-pizza-pattern &self)")
    soda_pizza_people = query_people(metta, "(human-soda-pizza-pattern &self)")
    water_people = query_people(metta, "(human-likes &self Water)")

    print("==========================================")
    print("PATTERN MINER MINI PROJECT")
    print("==========================================")

    print_pattern("Pattern 1: Humans who like Soda", soda_people,
                  "Support: Human AND Likes Soda")
    print_pattern("Pattern 2: Humans who like Pizza", pizza_people,
                  "Support: Human AND Likes Pizza")
    print_pattern("Pattern 3: Human + Soda + Pizza", soda_pizza_people,
                  "Support: Human + Soda + Pizza")

    minimum_support = 2
    print()
    print(f"--- Minimum Support = {minimum_support} ---")
    print()
    results = (("Soda", soda_people), ("Water", water_people))
    for index, (item, people) in enumerate(results):
        frequency = "Frequent" if len(people) >= minimum_support else "Infrequent"
        print(f"(PatternResult (HumanLikes {item}) {len(people)} {frequency})")
        if index < len(results) - 1:
            print()

    print()
    print("==========================================")
    print("MINING COMPLETE")
    print("==========================================")


if __name__ == "__main__":
    main()
