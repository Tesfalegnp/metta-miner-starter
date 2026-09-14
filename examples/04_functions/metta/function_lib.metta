; ============================================================
; MeTTa Functions Library (educational)
; ============================================================
;
; Demonstrate function-like symbols in MeTTa: parameters, multiple
; parameters, nested calls, composition, and higher-order usage via
; passing function symbols. This is intentionally small and explicit
; to keep evaluation deterministic for learning and tests.

!(load "../../02_lists/metta/list_lib.metta")

; -----------------------------
; Basic function facts (toy arithmetic for demo)
; -----------------------------
(= (inc 1) 2)
(= (inc 2) 3)
(= (inc 3) 4)
(= (inc 4) 5)

; small-domain add facts for demonstration (explicit table)
(= (add 1 1) 2)
(= (add 1 2) 3)
(= (add 2 1) 3)
(= (add 2 2) 4)
(= (add 1 3) 4)

; -----------------------------
; Pair and selectors (multiple parameters and return-value style)
; -----------------------------
(= (pair $a $b) (Pair $a $b))
(= (fst $p)
   (match $p
      (Pair $a $b)
      $a))
(= (snd $p)
   (match $p
      (Pair $a $b)
      $b))

; -----------------------------
; Nested calls and composition
; -----------------------------
(= (doubleinc $x) (inc (inc $x)))

(= (compose $f $g $x)
   ($f ($g $x)))

; -----------------------------
; Higher-order usage: `map` from list_lib.metta accepts a function
; symbol like `inc` and applies it to each element. We show that
; MeTTa treats function names as atoms that can be invoked.
; -----------------------------
