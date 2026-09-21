# Pattern Miner & MM2/MORK Educational Lab

A dual-purpose repository providing:
1. **Pattern Miner Baseline**: An educational pattern mining system implemented in both high-level **Hyperon MeTTa** and explicit **MORK / MM2** execution rules against the same knowledge base.
2. **Python-List MM2/MORK Learning Lab**: A modular educational laboratory demonstrating Python-like list operations, recursive state machines (`DEF`), relational queries, and AtomSpace reasoning in MORK.

---

## 1. Project Structure

```text
metta-miner-starter/
├── README.md                          # Project guide and running instructions
├── expect.text                        # Exact expected baseline MeTTa output
├── run.py                             # MeTTa Pattern Miner baseline runner
│
├── metta/                             # Hyperon MeTTa Baseline Implementation
│   ├── data.metta                     # Knowledge base facts
│   ├── miner.metta                    # MeTTa matching rules
│   └── run.metta                      # MeTTa demo entry point
│
├── mork/                              # MORK / MM2 Baseline Implementation
│   ├── README.md                      # MM2 rule design guide
│   ├── data.metta                     # MORK knowledge base facts
│   ├── miner.metta                    # MM2 exec and count rules
│   ├── run.metta                      # Threshold configuration
│   └── run-mork.sh                    # MORK baseline launcher script
│
├── src/learning/python-list/          # Python-List Educational MM2 Package
│   ├── README.md                      # Detailed list module documentation
│   ├── demo.metta                     # Standalone runnable interactive demo
│   ├── core.metta                     # Core request/result protocol & construct
│   ├── basic.metta                    # Direct stdlib list operations
│   ├── recursive.metta                # Recursive state machines (count, map, filter)
│   ├── facts.metta                    # List-to-fact decomposition & queries
│   └── reasoning.metta                # Relational AtomSpace reasoning
│
├── tests/learning/python-list/        # Python-List Test Suites
│   ├── core-test.metta                # Core construction test
│   ├── basic-test.metta               # Basic operations test suite (22 assertions)
│   ├── recursive-test.metta           # Recursion test suite (count, map, filter)
│   ├── facts-test.metta               # Fact decomposition & query test suite
│   └── reasoning-test.metta           # AtomSpace reasoning test suite
│
└── scripts/                           # Execution & Test Runners
    ├── mork-run.sh                    # Universal MORK launcher (auto-loads dependencies)
    └── run-python-list-tests.sh       # Automated test suite runner (all 5 modules)
```

---

## 2. Prerequisites & Setup

### A. Hyperon MeTTa (Python)

Ensure Hyperon is installed in your Python environment:

```bash
python3 -c 'from hyperon import MeTTa; print("Hyperon is ready")'
```

### B. MORK Binary

MORK is built with Rust. If built locally, ensure the binary is accessible or set `MORK_BIN`:

```bash
# Default location used by scripts:
export MORK_BIN="$HOME/Projects/MORK/target/release/mork"

# Verify MORK:
"$MORK_BIN" --help
```

---

## 3. Quick Run Commands

From the repository root (`/home/hope/Projects/metta-miner-starter`):

### A. Run Pattern Miner Baselines

#### 1. Run MeTTa Baseline:
```bash
python3 run.py
```

*Verify against expected output:*
```bash
diff -u expect.text <(python3 run.py)
```
*(Empty diff output confirms exact correctness).*

#### 2. Run MORK/MM2 Pattern Miner:
```bash
./mork/run-mork.sh
```

---

### B. Run Python-List Educational Demos & Modules

#### 1. Run Standalone Interactive Demo (Single File):
```bash
mork run src/learning/python-list/demo.metta
```
*(Or use `./scripts/mork-run.sh src/learning/python-list/demo.metta`)*

#### 2. Run the Entire Automated Test Suite (All 5 Modules):
```bash
./scripts/run-python-list-tests.sh
```

**Expected Output:**
```text
==========================================
PYTHON-LIST MM2/MORK TEST RUNNER
==========================================
MORK: /home/hope/Projects/MORK/target/release/mork
Tests: tests/learning/python-list

RUN basic-test.metta...             PASS (22 assertions verified)
RUN core-test.metta...              PASS (1 assertions verified)
RUN facts-test.metta...             PASS (6 assertions verified)
RUN reasoning-test.metta...         PASS (1 assertions verified)
RUN recursive-test.metta...         PASS (7 assertions verified)

==========================================
Summary: 5/5 passed, 0 failed.
==========================================
```

#### 3. Run Individual Learning Modules with `./scripts/mork-run.sh`:

The `./scripts/mork-run.sh` helper automatically detects `;; TEST-AUX` comments and loads all required implementation files for you:

* **Basic Operations Suite** (`empty`, `first`, `tail`, `length`, `member`, `append`, `reverse`, `remove`, `find`):
  ```bash
  ./scripts/mork-run.sh tests/learning/python-list/basic-test.metta
  ```

* **Recursive Operations Suite** (`count`, `map`, `filter`):
  ```bash
  ./scripts/mork-run.sh tests/learning/python-list/recursive-test.metta
  ```

* **Fact Decomposition & Query Suite** (`to-facts`, `query-facts`):
  ```bash
  ./scripts/mork-run.sh tests/learning/python-list/facts-test.metta
  ```

* **AtomSpace Reasoning Suite** (`reasoning-query`):
  ```bash
  ./scripts/mork-run.sh tests/learning/python-list/reasoning-test.metta
  ```

* **Core Protocol Suite** (`construct`):
  ```bash
  ./scripts/mork-run.sh tests/learning/python-list/core-test.metta
  ```

---

## 4. Educational Concepts Reference

### Python vs MM2/MORK Comparison

| Concept | Python | MM2 / MORK Expression | Module |
| :--- | :--- | :--- | :--- |
| **Construct** | `items = ['Alice', 'Bob']` | `(LIST-REQUEST construct c1 (Alice Bob))` | [`core.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/core.metta) |
| **Empty Check** | `len(items) == 0` | `(LIST-REQUEST empty e1 ())` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **First / Head** | `items[0]` | `(pure ... $first (car-atom (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Tail** | `items[1:]` | `(pure ... $tail (cdr-atom (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Length** | `len(items)` | `(pure ... $len (length (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Membership** | `item in items` | `(pure ... $is_mem (is-member $item (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Append** | `left + right` | `(pure ... $res (append (' ($left $right))))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Reverse** | `items[::-1]` | `(pure ... $res (reverse (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Remove** | `[x for x in items if x != item]` | `(pure ... $res (exclude-item $item (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Index / Find** | `items[index]` | `(pure ... $res (index-atom $index (' $list)))` | [`basic.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/basic.metta) |
| **Count** | `items.count(target)` | Recursive state machine (`car-atom`/`cdr-atom` + `DEF`) | [`recursive.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/recursive.metta) |
| **Map** | `[f(x) for x in items]` | Symbolic rule mapping `(LIST-MAP-RULE $from $to)` | [`recursive.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/recursive.metta) |
| **Filter** | `[x for x in items if p(x)]` | Symbolic predicate `(LIST-FILTER-PREDICATE $item keep\|drop)` | [`recursive.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/recursive.metta) |
| **Decompose to Facts** | `for x in items: db.add(x)` | Emits `(LIST-FACT id item)` per element | [`facts.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/facts.metta) |
| **Query Facts** | `db.query(item)` | Matches `(LIST-QUERY id item)` against `(LIST-FACT id item)` | [`facts.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/facts.metta) |
| **Reasoning** | `if person and likes: infer()` | Relational rule `(PERSON $p) (LIKES $p Coffee)` | [`reasoning.metta`](file:///home/hope/Projects/metta-miner-starter/src/learning/python-list/reasoning.metta) |

---

## 5. Upstream Projects & Conventions

* **[MORK](https://github.com/trueagi-io/MORK)**: MeTTa Optimal Reduction Kernel.
* **[Pattern-miner-mm2](https://github.com/iCog-Labs-Dev/Pattern-miner-mm2)**: Frequent pattern miner in MM2/MORK using `DEF` dynamic rule instantiation and `EXPECTED-RESULT` testing conventions.
* **[mm2-stdlib](https://github.com/iCog-Labs-Dev/mm2-stdlib)**: Standard library pure grounding primitives for MM2.
