#!/usr/bin/env python3
import subprocess
import re
import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
MORK_BIN = os.environ.get("MORK_BIN", "/home/hope/.local/bin/mork")
HELPERS = os.path.join(SCRIPT_DIR, "isurp-old-helpers.metta")
MAIN = os.path.join(SCRIPT_DIR, "isurp-old.metta")

tests = [
    (
        "Test A: Raw (ugly_man_sodaDrinker)",
        os.path.join(SCRIPT_DIR, "data/ugly_man_sodaDrinker.metta"),
        "(isurp-old (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) &db False)",
        0.00014607068574401354,
    ),
    (
        "Test B: Norm (ugly_man_sodaDrinker)",
        os.path.join(SCRIPT_DIR, "data/ugly_man_sodaDrinker.metta"),
        "(isurp-old (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) &db True)",
        0.999707773232028,
    ),
    (
        "Test C: Coupled (mock_coupled)",
        os.path.join(SCRIPT_DIR, "data/mock_coupled.metta"),
        "(isurp-old (, (Inheritance (Person $x) man) (Inheritance (Person $x) ugly) (Inheritance (Person $x) sodaDrinker)) &dbc True)",
        0.999707773232028,
    ),
    (
        "Test D: Nested 4-conjunct (true_nested)",
        os.path.join(SCRIPT_DIR, "data/true_nested.metta"),
        "(isurp-old (, (Inheritance (And (And (Person $x) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker))) (Inheritance (And (And (Person $x) man) (Or human sodaDrinker)) (Or (And human man) (And human ugly))) (Inheritance (And (And human man) (Or (Person $x) (Person Mike))) (Or (And human man) (And human sodaDrinker))) (Inheritance (And (And (Person $x) man) (Or human ugly)) (Or (And human man) (And human sodaDrinker)))) &dbn True)",
        0.9996837944664032,
    ),
    (
        "Test E1: N-ary P1 Norm (dataset_for_n_arry_format)",
        os.path.join(SCRIPT_DIR, "data/dataset_for_n_arry_format.metta"),
        "(isurp-old (, (Inheritance $x Loves $y) (Inheritance $x $Interest $Venue) (Inheritance $y $Interest $Venue)) &dbNarry True)",
        0.9886039886039886,
    ),
    (
        "Test E1: N-ary P1 Raw (dataset_for_n_arry_format)",
        os.path.join(SCRIPT_DIR, "data/dataset_for_n_arry_format.metta"),
        "(isurp-old (, (Inheritance $x Loves $y) (Inheritance $x $Interest $Venue) (Inheritance $y $Interest $Venue)) &dbNarry False)",
        0.0036212600315164425,
    ),
    (
        "Test E2: N-ary P2 Norm (dataset_for_n_arry_format)",
        os.path.join(SCRIPT_DIR, "data/dataset_for_n_arry_format.metta"),
        "(isurp-old (, (Inheritance $x $y The-Slice-Shop) (Inheritance $x Pizza-Lover $place) (Inheritance $x Pizza-Lover The-Slice-Shop)) &dbNarry True)",
        0.9981684981684982,
    ),
    (
        "Test E2: N-ary P2 Raw (dataset_for_n_arry_format)",
        os.path.join(SCRIPT_DIR, "data/dataset_for_n_arry_format.metta"),
        "(isurp-old (, (Inheritance $x $y The-Slice-Shop) (Inheritance $x Pizza-Lover $place) (Inheritance $x Pizza-Lover The-Slice-Shop)) &dbNarry False)",
        0.0018281474325430374,
    ),
]

print("=================================================================")
print("RUNNING ALL 8 ORIGINAL END-TO-END TESTS")
print("=================================================================")

all_passed = True
results_table = []

for name, data_file, query, expected in tests:
    tmp_in = "/tmp/orig_test_query.metta"
    tmp_out = "/tmp/orig_test_query.out"
    with open(tmp_in, "w") as f:
        f.write(f"{query}\n")

    cmd = [
        MORK_BIN,
        "run",
        tmp_in,
        tmp_out,
        "--aux-path",
        data_file,
        "--aux-path",
        HELPERS,
        "--aux-path",
        MAIN,
        "--instrumentation",
        "0",
    ]
    subprocess.run(cmd, check=True)

    with open(tmp_out) as f:
        lines = [line.strip() for line in f if line.strip()]

    actual = None
    for line in lines:
        m = re.match(r"^\((\d+\.\d+(?:e[+-]?\d+)?)\)$", line)
        if m:
            actual = float(m.group(1))
            break

    diff = abs(actual - expected) if actual is not None else float("inf")
    passed = diff < 1e-9
    if not passed:
        all_passed = False

    status = "PASS" if passed else "FAIL"
    print(f"[{status}] {name}")
    print(f"       Expected: {expected}")
    print(f"       Actual:   {actual}")
    print(f"       Diff:     {diff:.2e}")

    results_table.append((name, expected, actual, diff, status))

print("=================================================================")
if all_passed:
    print("ALL 8 ORIGINAL TESTS PASSED PERFECTLY!")
    sys.exit(0)
else:
    print("SOME TESTS FAILED!")
    sys.exit(1)
