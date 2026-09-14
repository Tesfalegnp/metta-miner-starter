# Pattern Miner: MeTTa and MORK/MM2

An educational Pattern Miner implemented twice against the same small knowledge
base. The project makes the difference between high-level MeTTa matching and
explicit MORK/MM2 execution visible and testable.

## What it mines

The knowledge base states that Alice, Bob, Charlie, and David are Human, then
records items they like. Both implementations derive and evaluate these three
patterns with a minimum support threshold of `2`:

| Pattern | Matching people | Support | Classification |
| --- | --- | ---: | --- |
| Human + Likes Soda | Alice, Bob, Charlie | 3 | Frequent |
| Human + Likes Pizza | Alice, Bob, Charlie | 3 | Frequent |
| Human + Likes Soda + Pizza | Alice, Bob, Charlie | 3 | Frequent |

## Architecture

```text
                     Same knowledge base
                            |
             +--------------+--------------+
             |                             |
             v                             v
       metta/data.metta               mork/data.metta
             |                             |
       Hyperon MeTTa runtime           MORK kernel
       high-level `match`              MM2 `exec` rules
             |                             |
             +--------------+--------------+
                            |
                     Pattern results
```

## Project structure

```text
metta-miner-starter/
├── README.md
├── run.py                         # MeTTa baseline runner
├── expect.text                    # Exact expected MeTTa output
├── metta/
│   ├── data.metta                 # MeTTa knowledge base
│   ├── miner.metta                # MeTTa matching rules
│   └── run.metta                  # MeTTa demo source
├── mork/
│   ├── README.md                  # MM2 rule guide
│   ├── data.metta                 # Equivalent MORK facts
│   ├── miner.metta                # MM2 execution and count rules
│   ├── run.metta                  # Run configuration / threshold
│   └── run-mork.sh                # MORK launcher
└── tests/
    ├── run-tests.sh               # Run both integration tests
    ├── test_metta.py              # Exact MeTTa output test
    ├── test-metta-match.metta     # Small MeTTa match example
    ├── test_mork_mm2.sh           # MORK derived-result test
    └── mork-expected-results.txt  # Expected MORK derived atoms
```

## Prerequisites

### MeTTa

The Python runner needs Hyperon's Python package:

```bash
python3 -c 'from hyperon import MeTTa; print("Hyperon is ready")'
```

### MORK

MORK is built separately with nightly Rust. The launcher defaults to:

```text
$HOME/Projects/MORK/target/release/mork
```

If it is elsewhere, set `MORK_BIN` for any MORK command:

```bash
export MORK_BIN=/absolute/path/to/mork
```

Check the binary:

```bash
"$MORK_BIN" --help
```

## Run the implementations

From the repository root:

```bash
cd /home/hope/Projects/metta-miner-starter
```

Run the MeTTa baseline:

```bash
python3 run.py
```

Check its complete output against the expected result:

```bash
diff -u expect.text <(python3 run.py)
```

No `diff` output means the MeTTa result is exactly correct.

Run the MORK/MM2 implementation:

```bash
./mork/run-mork.sh
```

MORK prints the initial facts and the atoms it derives. The important derived
atoms are `HumanLikes`, `Support`, and `PatternResult`.

## Run the tests

Run every project integration test:

```bash
./tests/run-tests.sh
```

Expected result:

```text
PASS: MeTTa output matches expect.text
PASS: MeTTa match test found Alice, Bob, and Charlie
PASS: MORK/MM2 derived all expected pattern-mining results
```

The MeTTa test compares the complete Python output with `expect.text`. The
MORK test runs the MM2 program, selects its derived result atoms, sorts them
(MORK does not guarantee display order), and compares them with
`tests/mork-expected-results.txt`.

## How the MORK/MM2 implementation works

`mork/miner.metta` demonstrates a complete, small MM2 pipeline:

1. `DeriveSoda`, `DerivePizza`, and `DeriveSodaPizza` use `exec` rules to join
   Human and Likes facts.
2. `CountSoda`, `CountPizza`, and `CountSodaPizza` use MORK's `count` sink to
   aggregate distinct people into `Support` atoms.
3. `Classify...` rules combine each support atom with `(MinimumSupport 2)` and
   produce a `PatternResult` atom.

This is deliberately explicit: MORK operates by adding new facts to its space
until no execution rule can derive another result. The MeTTa baseline expresses
the same lookup with nested `match` expressions and calculates support in
Python.

## Notes for further work

This is a fixed, beginner-friendly data set. The MM2 classifier currently has
one rule per observed support value (`3`) and demonstrates the threshold using
the configured value `2`. A next extension would implement a generic numeric
comparison rule so arbitrary support values and thresholds can be classified.

## Upstream projects

MORK is the MeTTa Optimal Reduction Kernel. Its command-line utility is built
from the `kernel` directory with nightly Rust. See the
[official MORK repository](https://github.com/trueagi-io/MORK) for the current
kernel and MM2 material.

## Learning examples

This repository now includes a small learning laboratory in `examples/` with
MeTTa-first demonstrations and small MORK/MM2 mappings where appropriate.

Examples added so far:

- `examples/02_lists/metta/` — A MeTTa list library (`list_lib.metta`) that
   demonstrates `Cons`/`Nil` representation and operations implemented as
   recursive pattern-based rules: `head`, `tail`, `append`, `member`, `length`
   (Peano numbers), `map`, `nth` (index), `take`, `drop`, `insert_at`,
   `remove_first`, `pop_head`, plus demo runners.
- `examples/02_lists/mork/` — A minimal MM2 example showing how `count`
   aggregation can produce a `ListLength` atom from `Element` facts.

How to run the MeTTa list demos (requires Hyperon):

```bash
python3 examples/02_lists/metta/run_metta_examples.py
```

How to run the MORK list demo (requires `mork` binary):

```bash
MORK_BIN=/path/to/mork ./examples/02_lists/mork/run-mork.sh
```

Tests for new examples:

```bash
bash tests/test_metta_lists.sh   # runs the MeTTa list demos (smoke)
bash tests/test_mork_lists.sh    # runs the MORK example or skips if binary fails
```

If the MORK binary panics or fails, the MORK example tests will be skipped
with guidance on running it manually. This avoids blocking the learning
workbench when the MORK runtime is not available or incompatible.

Roadmap
-------

The learning laboratory is organized into modules (progressing from
foundations to graph algorithms):

1. 01_basics
2. 02_lists
3. 03_control_flow
4. 04_functions
5. 05_recursion
6. 06_mork_mm2
7. 07_data_structures
8. 08_search
9. 09_graph_basics
10. 10_pattern_matching
11. 11_graph_algorithms

Each module contains Python demos, MeTTa examples where meaningful, and
MORK/MM2 examples or notes when a rule-based perspective is natural.
