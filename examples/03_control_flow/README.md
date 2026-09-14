# 03_control_flow

This topic demonstrates control-flow concepts using MeTTa (recursion and
pattern-based rewrites) and small MM2 mappings where meaningful. MeTTa does
not provide imperative `for`/`while` loops; repeated computation is expressed
via recursion and pattern rules.

How to run the MeTTa demos:

```bash
python3 examples/03_control_flow/metta/run_metta_control.py
```

The demo files include explanatory comments and show how to model:
- `for`-like iteration via `for_each`.
- `while`-like recursion with an explicit termination condition.
- nested iteration via recursive joins.
- break/continue semantics via short-circuit rules.
