; ============================================================
; Pattern Miner Mini Project - Mining Logic
; ============================================================


; ============================================================
; Find humans who like an item
; ============================================================

(= (human-likes $kb $item)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x $item))
         $x)))


; ============================================================
; Soda pattern
; ============================================================

(= (human-soda-pattern $kb)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x Soda))
         $x)))


; ============================================================
; Pizza pattern
; ============================================================

(= (human-pizza-pattern $kb)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x Pizza))
         $x)))


; ============================================================
; Three-clause pattern
;
; Human(x)
; AND Likes(x, Soda)
; AND Likes(x, Pizza)
; ============================================================

(= (human-soda-pizza-pattern $kb)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x Soda))
         (match $kb
            (Evaluation (Likes $x Pizza))
            $x))))


; Support and frequency classification are calculated in run.py.
; `match` produces one result per matching atom in Hyperon 0.2, so its
; `size` primitive cannot count the whole result set from inside MeTTa.
; Keeping the pattern definitions here makes the knowledge query logic
; explicit; the Python runner aggregates those query results reliably.
