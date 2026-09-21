# Python-List Educational Module in MM2/MORK

An educational module demonstrating Python-like list operations, recursive state machines, and relational querying using the **MeTTa Optimal Reduction Kernel (MORK)** and **MM2** execution rules.

---

## 1. Quick Start: How to Run

### Option A: Run Standalone Demo directly with MORK

```bash
mork run src/learning/python-list/demo.metta
```

### Option B: Run Any File Easily with the Helper Script

```bash
./scripts/mork-run.sh src/learning/python-list/demo.metta
./scripts/mork-run.sh tests/learning/python-list/basic-test.metta
./scripts/mork-run.sh tests/learning/python-list/recursive-test.metta
```

*(The `mork-run.sh` helper automatically detects and loads dependencies listed in `;; TEST-AUX` comments).*

### Option C: Run Full Automated Test Suite (All 5 Modules)

```bash
./scripts/run-python-list-tests.sh
```

---

## 2. What This Module Teaches

This module bridges familiar Python list manipulations and declarative AtomSpace computation in MM2:

1. **Symbolic S-Expression Lists**: How lists like `(Alice Bob Carol)` and `()` are represented directly in the AtomSpace.
2. **Request / Result Protocol**: Asynchronous, fact-driven requests (`LIST-REQUEST`) transformed into observable facts (`LIST-RESULT`).
3. **Verified Standard Library Functions**: Leveraging `mm2-stdlib` primitives (`car-atom`, `cdr-atom`, `length`, `is-member`, `append`, `reverse`, `exclude-item`, `index-atom`).
4. **Structural Pattern Matching**: Detecting empty lists `()` vs single/multi elements without fragile string/type conversions.
5. **Recursive State Machines (`DEF`)**: Implementing multi-step loops (e.g., `count`, `map`, `filter`, `to-facts`) using declarative dynamic rule instantiation (`DEF`).
6. **Fact Generation & Querying**: Turning structured nested data into first-class relational facts and performing pattern queries.
7. **Relational Reasoning**: Combining domain knowledge facts to derive higher-level insights.

---

## 3. Module Architecture

```text
src/learning/python-list/
├── README.md            # Educational documentation & usage guide
├── demo.metta           # Standalone runnable interactive demo
├── core.metta           # Core protocol and construct operation
├── basic.metta          # Direct stdlib list operations
├── recursive.metta      # Recursive state machines (count, map, filter)
├── facts.metta          # List decomposition into facts & query engine
└── reasoning.metta      # Relational AtomSpace reasoning
```

```text
tests/learning/python-list/
├── core-test.metta       # Core construction tests
├── basic-test.metta      # Basic operations & edge-case suite
├── recursive-test.metta  # Recursion (count, map, filter) suite
├── facts-test.metta      # Fact generation & query suite
└── reasoning-test.metta  # AtomSpace reasoning test suite
```

---

## 4. Protocol & Operations

### Request / Result Conventions

Every list operation follows the AtomSpace pattern:

```metta
;; Request format:
(LIST-REQUEST <operation> <id> <args...>)

;; Result format:
(LIST-RESULT <operation> <id> <value>)
```

### Basic Operations (`basic.metta`)

| Operation | Python Equivalent | MM2 / MORK Expression | Example Output |
| :--- | :--- | :--- | :--- |
| `empty` | `len(items) == 0` | `(LIST-REQUEST empty e1 ())` | `(LIST-RESULT empty e1 true)` |
| `first` | `items[0]` | `(pure ... $first (car-atom (' $list)))` | `(LIST-RESULT first f1 Alice)` |
| `tail` | `items[1:]` | `(pure ... $tail (cdr-atom (' $list)))` | `(LIST-RESULT tail t1 (Bob Carol))` |
| `length` | `len(items)` | `(pure ... $len (length (' $list)))` | `(LIST-RESULT length l1 3)` |
| `member` | `item in items` | `(pure ... $is-mem (is-member $item (' $list)))` | `(LIST-RESULT member m1 true)` |
| `append` | `left + right` | `(pure ... $res (append (' ($left $right))))` | `(LIST-RESULT append a1 (Alice Bob Carol Daniel))` |
| `reverse` | `items[::-1]` | `(pure ... $res (reverse (' $list)))` | `(LIST-RESULT reverse r1 (Carol Bob Alice))` |
| `remove` | `[x for x in items if x != item]` | `(pure ... $res (exclude-item $item (' $list)))` | `(LIST-RESULT remove rm1 (Bob Carol))` |
| `find` | `items[index]` | `(pure ... $res (index-atom $index (' $list)))` | `(LIST-RESULT find fd1 Bob)` |

### Recursive Operations (`recursive.metta`)

Recursive state machines in MM2 use explicit state facts and `DEF` dynamic rule instantiations:

* **`count`**: Decomposes the list with `car-atom`/`cdr-atom`, unifies matching heads, collects matching occurrences into an accumulator, and computes `(length (' $acc))`.
* **`map`**: Looks up `(LIST-MAP-RULE $from $to)` for each element, accumulates mapped items with `cons`, and finalizes with `reverse`.
* **`filter`**: Checks `(LIST-FILTER-PREDICATE $item keep|drop)`, preserves `keep` items, and finalizes with `reverse`.

### Fact Generation & Reasoning (`facts.metta`, `reasoning.metta`)

* **`to-facts`**: Decomposes `(Alice Bob Carol)` into individual assertions:
  ```metta
  (LIST-FACT facts-1 Alice)
  (LIST-FACT facts-1 Bob)
  (LIST-FACT facts-1 Carol)
  (LIST-RESULT to-facts facts-1 done)
  ```
* **`query-facts`**: Matches query fact `(LIST-QUERY facts-1 Bob)` against existing assertions to derive `(LIST-QUERY-RESULT facts-1 Bob)`.
* **`reasoning`**: Pattern matches `(PERSON $p)` and `(LIKES $p Coffee)` to derive `(REASONING-RESULT $p)`.
