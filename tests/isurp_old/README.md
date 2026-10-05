# ISurp-Old MM2 Test Cases

These tests validate the independent MM2 implementation of the original `isurp-old` algorithm.

## Implementation under test

```text
src/isurp_old.metta
```

## Running the tests

Run the entire test suite using the automated test runner:

```bash
./scripts/run-isurp-old-tests.sh
```

Or run any individual test using the MORK helper:

```bash
./scripts/mork-run.sh tests/isurp_old/test_basic_3conjunct.metta
```

## Test scope

The current tests focus on the validated 3-conjunct case:

```text
(c1 c2 c3)
```

The implementation evaluates these four independent partition products:

```text
P(c1)       * P(c2,c3)
P(c1,c3)    * P(c2)
P(c1,c2)    * P(c3)
P(c1)       * P(c2) * P(c3)
```

Then:

```text
emin = min(P1,P2,P3,P4)
emax = max(P1,P2,P3,P4)
```

and:

```text
distance = distance(emp, [emin, emax])
```

## Expected behavior

### Case 1: empirical probability inside interval

```text
emin <= empirical_probability <= emax
```

Expected:
```text
distance = 0
raw result = 0
normalized result = 0
```

### Case 2: empirical probability above interval

```text
empirical_probability > emax
```

Expected:
```text
distance = empirical_probability - emax
```

### Case 3: empirical probability below interval

```text
empirical_probability < emin
```

Expected:
```text
distance = emin - empirical_probability
```

### Case 4: normalization

When `NORMALIZATION = TRUE`:
```text
min(distance / max(emax, empirical_probability), 1.0)
```

### Case 5: raw mode

When `NORMALIZATION = FALSE`:
```text
min(distance, 1.0)
```

## Important denominator rule

Block probabilities must use the total count of the **full pattern**, matching the original `prob`/`blk-prob` behavior. They must not independently replace the denominator with the database size.

## Test philosophy

The tests verify mathematical behavior rather than reproducing the mentor/reference implementation's internal rule structure. The alternative implementation intentionally avoids recursive combinatorial emission and instead directly evaluates the required partition products.
