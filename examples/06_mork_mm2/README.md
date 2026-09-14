06_mork_mm2 — MORK / MM2 learning examples
============================================

This folder contains small, runnable MORK/MM2 examples that demonstrate
core concepts: facts, rules (exec), aggregation (count), and a simple
recursive-style transitive closure implemented as rule-driven derivation.

Each example has a `run.sh` that invokes the local `MORK_BIN` (default
`$HOME/Projects/MORK/target/release/mork`) and produces a `mork-output.metta`
file. Tests invoke the run scripts and validate the produced atoms.

Use these examples to compare MeTTa rule/evaluation behavior with MM2's
execution rules and aggregations.
