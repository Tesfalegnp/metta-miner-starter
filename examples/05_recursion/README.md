05_recursion — Recursion (MeTTa-first learning)
===============================================

What this example teaches
- Recursive definitions using Peano numbers and symbolic rules
- Factorial and Fibonacci expressed as recursive MeTTa rules
- Recursive list algorithms: sum, reverse, search
- Simple tree traversal (preorder)

How to run (MeTTa)

```bash
python3 examples/05_recursion/metta/run_recursion.py
```

Expected output: see `tests/expect_recursion.text`.

Python/MeTTa/MORK notes
- MeTTa expresses recursion as pattern rewrite rules that produce new
  atoms; we use Peano numbers for arithmetic. MORK/MM2 equivalents will
  be added only when there's a meaningful mapping.
