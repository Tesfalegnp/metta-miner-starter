# Pattern Miner Mini Project

A small educational implementation of **Pattern Mining using MeTTa**.
This project demonstrates how patterns can be represented as logical conjunctions, matched against a knowledge base, and evaluated using **support** and **minimum-support thresholds**.

The project is inspired by the Pattern Miner work in the [iCog-Labs-Dev Pattern-miner-mm2 repository](https://github.com/iCog-Labs-Dev/Pattern-miner-mm2).

---

## 1. Project Overview

Pattern mining is the process of discovering interesting and recurring relationships in a collection of data.

In this mini-project, knowledge is represented using **MeTTa atoms**. The system searches the knowledge base for entities that satisfy different patterns.

For example:

```text
Human(x)
AND
Likes(x, Soda)
```

The system finds all humans who like Soda.

Given the following facts:

```text
Alice → Human
Bob → Human
Charlie → Human
David → Human

Alice → Likes Soda
Bob → Likes Soda
Charlie → Likes Soda
```

the discovered pattern is:

```text
Human(x) AND Likes(x, Soda)
```

with:

```text
Support = 3
```

If the minimum support is `2`, the pattern is considered:

```text
Frequent
```

---

## 2. Objectives

The main objectives of this mini-project are:

* Understand the basic concept of pattern mining.
* Represent structured knowledge using MeTTa.
* Query a knowledge base using logical patterns.
* Demonstrate conjunction between multiple clauses.
* Calculate pattern support.
* Apply a minimum-support threshold.
* Identify frequent and infrequent patterns.
* Understand the basic ideas behind the larger Pattern Miner implementation.

---

## 3. Technologies

| Technology              | Purpose                                       |
| ----------------------- | --------------------------------------------- |
| MeTTa                   | Knowledge representation and pattern matching |
| Hyperon / MeTTa Runtime | Execute the MeTTa programs                    |
| Git                     | Version control                               |
| GitHub                  | Source-code repository                        |

---

## 4. Project Structure

```text
metta-miner-starter/
│
├── README.md
├── data.metta
├── miner.metta
└── run.metta
```

### `data.metta`

Contains the knowledge base used by the miner.

It defines:

* Entities
* Entity classifications
* Beverage preferences
* Food preferences

Example:

```metta
(Inheritance Alice Human)
(Inheritance Bob Human)
(Inheritance Charlie Human)

(Evaluation (Likes Alice Soda))
(Evaluation (Likes Bob Soda))
(Evaluation (Likes Charlie Soda))
```

---

### `miner.metta`

Contains the pattern-mining logic.

It implements:

* Human + item matching
* Soda pattern
* Pizza pattern
* Soda + Pizza conjunction
* Support calculation
* Minimum-support checking
* Frequent/infrequent classification

---

### `run.metta`

The main demonstration program.

It:

1. Loads the knowledge base.
2. Loads the mining logic.
3. Executes several patterns.
4. Calculates support.
5. Applies minimum support.
6. Displays the results.

---

# 5. Knowledge Base

The knowledge base contains four humans:

```text
Alice
Bob
Charlie
David
```

and one animal:

```text
Dog
```

The classifications are:

```text
Alice  → Human
Bob    → Human
Charlie → Human
David  → Human
Dog    → Animal
```

The preferences are:

### Soda

```text
Alice   → Soda
Bob     → Soda
Charlie → Soda
```

### Water

```text
David → Water
```

### Pizza

```text
Alice   → Pizza
Bob     → Pizza
Charlie → Pizza
```

### Salad

```text
David → Salad
```

---

# 6. Pattern Representation

The project represents a pattern as a conjunction of logical clauses.

## Pattern 1: Human + Soda

```text
Human(x)
AND
Likes(x, Soda)
```

This pattern asks:

> Which entities are humans and also like Soda?

Result:

```text
Alice
Bob
Charlie
```

Support:

```text
3
```

---

## Pattern 2: Human + Pizza

```text
Human(x)
AND
Likes(x, Pizza)
```

Result:

```text
Alice
Bob
Charlie
```

Support:

```text
3
```

---

## Pattern 3: Human + Soda + Pizza

The third pattern adds another clause:

```text
Human(x)
AND
Likes(x, Soda)
AND
Likes(x, Pizza)
```

The same variable `$x` is used in all three clauses.

Therefore, the same person must satisfy all conditions.

Result:

```text
Alice
Bob
Charlie
```

Support:

```text
3
```

This demonstrates **conjunction expansion**, where additional conditions are added to an existing pattern.

---

# 7. Pattern Matching

The core matching operation uses MeTTa's `match`.

For example:

```metta
(match &self
   (Inheritance $x Human)
   (match &self
      (Evaluation (Likes $x Soda))
      $x))
```

The variable:

```text
$x
```

represents the entity being searched for.

The first clause requires:

```text
Inheritance $x Human
```

The second clause requires:

```text
Likes $x Soda
```

Because the same `$x` is used in both clauses, the result must satisfy both conditions.

The query therefore represents:

```text
Human(x) AND Likes(x, Soda)
```

---

# 8. Support

Support measures how many entities satisfy a pattern.

The basic definition used in this project is:

```text
Support(pattern)
=
Number of matching entities
```

For example:

```text
Human(x) AND Likes(x, Soda)
```

matches:

```text
Alice
Bob
Charlie
```

Therefore:

```text
Support = 3
```

Similarly:

```text
Human(x) AND Likes(x, Water)
```

has:

```text
Support = 0
```

because David likes Water, but the pattern requires the entity to be Human, and in the current example David is not included as a Soda/Pizza match.

---

# 9. Minimum Support

A minimum-support threshold determines whether a pattern is considered frequent.

The project uses:

```text
Minimum Support = 2
```

The rule is:

```text
If Support >= Minimum Support
    Pattern is Frequent
Else
    Pattern is Infrequent
```

For Soda:

```text
Support = 3
Minimum Support = 2

3 >= 2
```

Therefore:

```text
Frequent
```

For Water:

```text
Support = 0
Minimum Support = 2

0 < 2
```

Therefore:

```text
Infrequent
```

---

# 10. Running the Project

## Step 1: Enter the project directory

```bash
cd ~/Projects/metta-miner-starter
```

## Step 2: Check that MeTTa is installed

```bash
metta --version
```

## Step 3: Run the demonstration

```bash
metta run.metta
```

---

# 11. Expected Output

A successful execution should produce results similar to:

```text
==========================================
PATTERN MINER MINI PROJECT
==========================================

--- Pattern 1: Humans who like Soda ---

[Alice, Bob, Charlie]

--- Support: Human AND Likes Soda ---

3

--- Pattern 2: Humans who like Pizza ---

[Alice, Bob, Charlie]

--- Support: Human AND Likes Pizza ---

3

--- Pattern 3: Human + Soda + Pizza ---

[Alice, Bob, Charlie]

--- Support: Human + Soda + Pizza ---

3

--- Minimum Support = 2 ---

(PatternResult (HumanLikes Soda) 3 Frequent)

(PatternResult (HumanLikes Water) 0 Infrequent)

==========================================
MINING COMPLETE
==========================================
```

> **Note:** The exact formatting of MeTTa output can vary depending on the installed MeTTa/Hyperon runtime version. The important results are the matched entities, support values, and frequent/infrequent classification.

---

# 12. Example Results

| Pattern              | Matching Entities   | Support | Minimum Support | Result     |
| -------------------- | ------------------- | ------: | --------------: | ---------- |
| Human + Soda         | Alice, Bob, Charlie |       3 |               2 | Frequent   |
| Human + Pizza        | Alice, Bob, Charlie |       3 |               2 | Frequent   |
| Human + Soda + Pizza | Alice, Bob, Charlie |       3 |               2 | Frequent   |
| Human + Water        | None                |       0 |               2 | Infrequent |

---

# 13. Mining Workflow

The complete workflow of the mini-project is:

```text
              Knowledge Base
                    │
                    ▼
             Generate Pattern
                    │
                    ▼
             Pattern Matching
                    │
                    ▼
            Find Matching Data
                    │
                    ▼
             Calculate Support
                    │
                    ▼
          Compare with Min Support
                    │
             ┌──────┴──────┐
             │             │
        Support >= 2    Support < 2
             │             │
             ▼             ▼
         Frequent       Infrequent
```

---

# 14. Three-Clause Pattern

The most important example in this project is:

```text
Human(x)
AND
Likes(x, Soda)
AND
Likes(x, Pizza)
```

This demonstrates how a pattern can be extended by adding another condition.

The matching process can be understood as:

```text
             Human
               │
               ▼
        Alice, Bob, Charlie, David
               │
               ▼
           Likes Soda
               │
               ▼
        Alice, Bob, Charlie
               │
               ▼
           Likes Pizza
               │
               ▼
        Alice, Bob, Charlie
```

Final support:

```text
3
```

---

# 15. Relationship to Pattern Miner

This mini-project implements the basic concepts required to understand a larger pattern-mining system.

The main concepts demonstrated are:

```text
Knowledge Representation
        ↓
Pattern Definition
        ↓
Pattern Matching
        ↓
Conjunction
        ↓
Support Calculation
        ↓
Minimum Support
        ↓
Frequent Pattern
```

The full [Pattern-miner-mm2](https://github.com/iCog-Labs-Dev/Pattern-miner-mm2) project is considerably more advanced. It contains a broader implementation of frequent pattern mining, including components for pattern generation/expansion and testing.

This mini-project intentionally keeps the implementation small so that the underlying concepts can be understood before studying the complete implementation.

---

# 16. Important MeTTa Concepts Used

## Variables

MeTTa variables are represented using `$`.

Example:

```metta
$x
```

The variable can represent an entity such as:

```text
Alice
Bob
Charlie
```

---

## Matching

The `match` operation searches a space for atoms satisfying a pattern.

Example:

```metta
(match &self
   (Inheritance $x Human)
   $x)
```

This finds entities classified as Human.

---

## Conjunction

Nested `match` expressions allow multiple conditions to be combined.

Example:

```metta
Human(x)
AND
Likes(x, Soda)
```

---

## Functions

MeTTa functions are defined using equations.

Example:

```metta
(= (frequent? $support $min-support)
   (>= $support $min-support))
```

This checks whether a pattern satisfies the minimum-support requirement.

---

# 17. Limitations

This is an educational mini-project and intentionally has a limited scope.

It currently:

* Uses a small manually created knowledge base.
* Demonstrates predefined patterns.
* Uses a simple support calculation.
* Uses a fixed minimum-support threshold.
* Does not automatically generate all possible patterns.
* Does not implement the complete Pattern Miner pipeline.
* Does not include advanced interestingness/surprisingness measures.

These limitations make the project easier to understand and use as a foundation for implementing more advanced mining functionality.

---

# 18. Possible Future Improvements

The project can be extended by implementing:

1. Automatic pattern generation.
2. Automatic conjunction expansion.
3. Pattern search over multiple predicates.
4. Candidate pattern generation.
5. Automatic frequent-pattern discovery.
6. Pattern ranking.
7. Interestingness or surprisingness measures.
8. Larger knowledge bases.
9. Automated tests.
10. Comparison with the complete Pattern Miner implementation.

A possible future architecture is:

```text
Knowledge Base
      │
      ▼
Initial Patterns
      │
      ▼
Pattern Expansion
      │
      ▼
Candidate Patterns
      │
      ▼
Pattern Matching
      │
      ▼
Support Calculation
      │
      ▼
Minimum Support Filtering
      │
      ▼
Frequent Patterns
      │
      ▼
Interestingness / Ranking
```

---

# 19. Learning Outcome

After completing this mini-project, the main concepts demonstrated are:

* How structured information can be represented in MeTTa.
* How `match` can be used to query a knowledge base.
* How multiple clauses can be combined into a conjunction.
* How matching entities can be counted as pattern support.
* How minimum support can be used to classify patterns.
* How a simple frequent-pattern miner can be constructed from logical queries.
* How the educational implementation relates to a larger Pattern Miner system.

---

# 20. Conclusion

This mini-project provides a simple implementation of the core idea behind pattern mining using MeTTa.

The project starts with a knowledge base, defines logical patterns, finds matching entities, calculates support, and determines whether patterns are frequent according to a minimum-support threshold.

For example:

```text
Human(x)
AND
Likes(x, Soda)
```

produces:

```text
Alice
Bob
Charlie
```

with:

```text
Support = 3
```

Since:

```text
3 >= 2
```

the pattern is classified as:

```text
Frequent
```

Although this implementation is intentionally smaller than the full Pattern Miner project, it provides a practical foundation for understanding the main concepts before moving to more advanced pattern generation and mining techniques.

---

## References

* [iCog-Labs-Dev Pattern-miner-mm2](https://github.com/iCog-Labs-Dev/Pattern-miner-mm2)
* [Hyperon / MeTTa](https://github.com/trueagi-io/hyperon-experimental)
* [MeTTa Documentation](https://metta-lang.dev/)

---

## Author

**Pattern Miner Mini Project**

Developed as an educational implementation for understanding **Pattern Mining, MeTTa, logical pattern matching, conjunction, and support-based frequent pattern detection**.
