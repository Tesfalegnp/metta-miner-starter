# MORK/MM2 Pattern Miner

This directory is the MORK implementation of the Pattern Miner. It solves the
same Soda, Pizza, and Soda+Pizza patterns as `../metta/`, but uses explicit MM2
execution rules rather than MeTTa's high-level `match` operation.

## Files

| File | Purpose |
| --- | --- |
| `data.metta` | Facts about people and their likes. |
| `miner.metta` | MM2 `exec` rules for matching, aggregation, and classification. |
| `run.metta` | Experiment configuration: minimum support is `2`. |
| `run-mork.sh` | Loads all three files through the MORK CLI. |

## MM2 pipeline

```text
(: Alice Human) + (Likes Alice Soda)
                  |
                  v
       (HumanLikes Soda Alice)
                  |
                  v
            (Support Soda 3)
                  |
                  v
    (PatternResult Soda 3 Frequent)
```

The `O (count ...)` expressions are MORK aggregation sinks. They count the
distinct matched people and write the support atoms.

## Run

```bash
export MORK_BIN=/path/to/mork   # optional when using the default path
./run-mork.sh
```

To test only this implementation from the project root:

```bash
MORK_BIN=/path/to/mork ./tests/test_mork_mm2.sh
```
