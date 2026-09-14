04_functions — Functions (MeTTa-first learning)
===============================================

What this example teaches
- Basic function-like facts in MeTTa (symbol → evaluation)
- Parameters and multiple parameters
- Nested function calls and composition
- Higher-order use by passing function symbols (e.g., `map inc`)

How to run (MeTTa)

Run the examples with:

```bash
python3 examples/04_functions/metta/run_functions.py
```

Expected output
- See `tests/expect_functions.text` for exact expected output.

Python version
- Examples are runnable with Python 3 and `hyperon`/MeTTa bindings installed.

MeTTa version
- Uses the local Hyperon MeTTa bindings in this repository (as in other examples).

MORK/MM2
- This folder focuses on MeTTa. Investigations for MORK/MM2 implementations
  will be added only when there is a meaningful one-to-one demonstration.

Important conceptual difference
- Python: functions are procedural call/return. MeTTa: symbols/rules are
  matched and rewritten to produce resulting atoms; passing a function name
  is passing a symbol that can be applied via existing rules.
