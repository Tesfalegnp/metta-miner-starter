#!/usr/bin/env python3
from pathlib import Path
from hyperon import MeTTa

ROOT = Path(__file__).resolve().parents[3]


def main() -> None:
    metta = MeTTa()
    src = (ROOT / 'examples' / '07_data_structures' / '03_linked_list' / 'linked_list.metta').read_text(encoding='utf-8')
    metta.run(src)
    res = metta.run('!(member 2 (Cons 1 (Cons 2 (Cons 3 Nil))))')
    if res and res[0]:
        print(res[0][0])


if __name__ == '__main__':
    main()
