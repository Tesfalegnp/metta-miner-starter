#!/usr/bin/env python3
import subprocess
import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
MORK_BIN = os.environ.get("MORK_BIN", "/home/hope/.local/bin/mork")
HELPERS = os.path.join(SCRIPT_DIR, "isurp-old-helpers.metta")
MAIN = os.path.join(SCRIPT_DIR, "isurp-old.metta")

# Focused unit tests for isurp-old_ as required by Section 7
sub_tests = [
    (
        "Empty partition list",
        "(isurp-old_ () &test-space 4)",
        "()",
    ),
    (
        "One partition with single block (1 conjunct)",
        "(isurp-old_ ((Inheritance $m man)) &test-space 4)",
        "(0.5)",
    ),
    (
        "One partition with two blocks",
        "(isurp-old_ (((Inheritance $x man) (Inheritance $x ugly))) &test-space 4)",
        "(0.125)",
    ),
    (
        "Multiple partitions: 2 partitions each with 1 block",
        "(isurp-old_ (((Inheritance $m man)) ((Inheritance $m ugly))) &test-space 4)",
        "((0.5 0.25))",
    ),
    (
        "Multiple partitions: 2 partitions with mixed block sizes",
        "(isurp-old_ (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x man))) &test-space 4)",
        "((0.125 0.5))",
    ),
    (
        "Multiple partitions: 3 partitions",
        "(isurp-old_ (((Inheritance $x man)) ((Inheritance $x ugly)) ((Inheritance $x man))) &test-space 4)",
        "((0.5 0.25 0.5))",
    ),
    (
        "Zero-support block (pattern absent from DB)",
        "(isurp-old_ (((Inheritance $x nonexistent))) &test-space 4)",
        "(0.0)",
    ),
    (
        "Repeated invocation 1 (state leakage check)",
        "(isurp-old_ ((Inheritance $m man)) &test-space 4)",
        "(0.5)",
    ),
    (
        "Repeated invocation 2 (state leakage check)",
        "(isurp-old_ ((Inheritance $m man)) &test-space 4)",
        "(0.5)",
    ),
]

print("=================================================================")
print("RUNNING TARGETED ISURP-OLD_ TESTS (Section 7)")
print("=================================================================")

all_passed = True
for name, query, expected in sub_tests:
    tmp_in = "/tmp/sub_query.metta"
    tmp_out = "/tmp/sub_query.out"
    with open(tmp_in, "w") as f:
        f.write(f"{query}\n")

    cmd = [
        MORK_BIN,
        "run",
        tmp_in,
        tmp_out,
        "--aux-path",
        HELPERS,
        "--aux-path",
        MAIN,
        "--instrumentation",
        "0",
    ]
    subprocess.run(cmd, check=True)

    with open(tmp_out) as f:
        lines = [l.strip() for l in f if l.strip()]

    actual = lines[0] if lines else ""
    passed = actual == expected
    if not passed:
        all_passed = False
    status = "PASS" if passed else "FAIL"
    print(f"[{status}] {name}")
    print(f"       Expected: {expected}")
    print(f"       Actual:   {actual}")

print("=================================================================")
if all_passed:
    print("ALL TARGETED ISURP-OLD_ TESTS PASSED SUCCESSFULLY!")
    sys.exit(0)
else:
    print("SOME TARGETED TESTS FAILED!")
    sys.exit(1)
