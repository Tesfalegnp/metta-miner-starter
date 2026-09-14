; ============================================================
; MeTTa Control-Flow Library (educational)
; ============================================================
;
; MeTTa expresses iteration through recursion and pattern rewriting. This
; file contains utilities to emulate common control-flow patterns:
; - `range` produces a list-like Cons/Nil sequence from Peano bounds
; - `for_each` applies a mapped function to each element (demonstration)
; - `while_do` runs a recursive body while a condition holds (explicit)
; - `nested_iter` demonstrates nested iteration by joining two lists
;
; The goal is educational: show how to reason about repeated computation in
; a symbolic, pattern-driven setting.

!(load "../02_lists/metta/list_lib.metta")

; -----------------------------
; range: construct list of integers from Start to End inclusive.
; We use simple numeric atoms rather than Peano here for clarity.
; range N N -> Cons N Nil
; range A B -> Cons A (range (A+1) B) when A < B
; Note: MeTTa lacks arithmetic primitives by default; for demo we add a
; few `inc` facts and an ordering predicate `lt` for small ints used here.
; -----------------------------
(= (inc 1) 2)
(= (inc 2) 3)
(= (inc 3) 4)
(= (inc 4) 5)

(= (lt 1 2) True)
(= (lt 1 3) True)
(= (lt 1 4) True)
(= (lt 2 3) True)
(= (lt 2 4) True)
(= (lt 3 4) True)

(= (range $n $n)
   (Cons $n Nil))

(= (range $a $b)
   (match $a
      $a
      (match $b
         $b
         (match (lt $a $b)
            True
            (Cons $a (range (inc $a) $b))))))

; -----------------------------
; for_each: apply a function symbol (like inc) to each element, producing
; a new Cons/Nil list. This leverages the list `map` in list_lib.metta.
; -----------------------------
(= (for_each $f $lst)
   (map $f $lst))

; -----------------------------
; while_do: emulate while by condition-check + recursive body
; while_do cond body state -> final_state
; If cond(state) is True => body(state) -> state' and recurse
; else return state
; For demo, `cond` and `body` are symbolic predicates/functions like
; `(lt state 4)` and `(inc state)` used above. This is a toy pattern.
; -----------------------------
(= (while_do $cond $body $state)
   (match ($cond $state)
      True
      (while_do $cond $body ($body $state))))

(= (while_do $cond $body $state)
   (match ($cond $state)
      $x
      $state))

; -----------------------------
; nested_iter: join every element of A with every element of B and produce
; a paired list of pairs as Cons (Pair a b) ... Nil
; This is a direct nested recursion demonstration.
; -----------------------------
(= (pair_with $a $lstB)
   (match $lstB
      (Nil)
      Nil))

(= (pair_with $a $lstB)
   (match $lstB
      (Cons $b $bs)
      (Cons (Pair $a $b) (pair_with $a $bs))))

(= (nested_iter $lstA $lstB)
   (match $lstA
      (Nil)
      Nil))

(= (nested_iter $lstA $lstB)
   (match $lstA
      (Cons $a $as)
      (append (pair_with $a $lstB) (nested_iter $as $lstB))))
