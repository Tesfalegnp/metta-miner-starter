#!/usr/bin/env python3
from pathlib import Path
from hyperon import MeTTa

ROOT = Path(__file__).resolve().parents[3]


def main() -> None:
    metta = MeTTa()
    src = (ROOT / 'examples' / '07_data_structures' / '04_trees' / 'tree.metta').read_text(encoding='utf-8')
    metta.run(src)
    res = metta.run('!(preorder (Node 1 (Node 2 (Node 4 (Nil) (Nil)) (Node 5 (Nil) (Nil))) (Node 3 (Node 6 (Nil) (Nil)) (Node 7 (Nil) (Nil)))))')
    if res and res[0]:
        print(res[0][0])


if __name__ == '__main__':
    main()
