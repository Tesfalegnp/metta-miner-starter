from hyperon import MeTTa


def evaluate_file(metta, filename):
    with open(filename, "r", encoding="utf-8") as file:
        source = file.read()

    for expression in metta.parse_all(source):
        metta.evaluate(expression)


def main():
    metta = MeTTa()

    # Load the knowledge base and mining logic.
    evaluate_file(metta, "data.metta")
    evaluate_file(metta, "miner.metta")

    # Run the demonstration.
    evaluate_file(metta, "run.metta")


if __name__ == "__main__":
    main()