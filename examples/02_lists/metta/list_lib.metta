; ============================================================
; MeTTa List Library (educational)
; ============================================================
;
; This file demonstrates how common list concepts can be represented in
; MeTTa. MeTTa is symbolic: lists are best represented as nested Cons/Nil
; structures or as a single structured atom `(List ...)` for static data.
;
; We implement:
; - `Nil` and `Cons` list representation
; - `head` and `tail` via pattern matching
; - `append` (concatenation) recursively
; - `member` (membership test)
; - `length` using Peano numbers (`Zero` and `Succ`)
; - a tiny `map` example using an explicit `inc` mapping for demo
;
; NOTE: This is educational code. MeTTa encourages pattern/rule-based
; transformations rather than in-place mutation. Operations like Python's
; index-assignment or slicing don't map directly to a symbolic rewrite model
; — instead you produce new structures via rules.

; -----------------------------
; Peano numbers
; -----------------------------
(Zero)
(Succ Zero)
(Succ (Succ Zero))
(Succ (Succ (Succ Zero)))
(Succ (Succ (Succ (Succ Zero))))

; -----------------------------
; Example lists (Cons/Nil)
; -----------------------------
(Nil)
(Cons 1 (Cons 2 (Cons 3 Nil)))
(Cons 10 (Cons 20 (Cons 30 Nil)))

; -----------------------------
; head: return the first element
; (head (Cons H T)) -> H
; -----------------------------
(= (head $lst)
   (match $lst
      (Cons $h $t)
      $h))

; -----------------------------
; tail: return the tail list
; (tail (Cons H T)) -> T
; -----------------------------
(= (tail $lst)
   (match $lst
      (Cons $h $t)
      $t))

; -----------------------------
; append: concatenation of two lists
; append Nil ys -> ys
; append (Cons x xs) ys -> Cons x (append xs ys)
; -----------------------------
(= (append $a $b)
   (match $a
      (Nil)
      $b))

(= (append $a $b)
   (match $a
      (Cons $x $xs)
      (Cons $x (append $xs $b))))

; -----------------------------
; member: true if element appears in list
; member x Nil -> false (no result)
; member x (Cons x xs) -> x
; member x (Cons y ys) -> member x ys
; -----------------------------
(= (member $e $lst)
   (match $lst
      (Cons $e $xs)
      $e))

(= (member $e $lst)
   (match $lst
      (Cons $x $xs)
      (member $e $xs)))

; -----------------------------
; length: compute Peano length
; length Nil -> Zero
; length (Cons _ xs) -> Succ (length xs)
; -----------------------------
(= (length $lst)
   (match $lst
      (Nil)
      Zero))

(= (length $lst)
   (match $lst
      (Cons $x $xs)
      (Succ (length $xs))))

; -----------------------------
; map: simple map using an explicit inc function for demo
; inc: map small integers to their successor (1->2, 2->3, etc.)
; This is a toy example: a real higher-order mapping is more involved.
; -----------------------------
(= (inc 1) 2)
(= (inc 2) 3)
(= (inc 3) 4)

(= (map $f $lst)
   (match $lst
      (Nil)
      Nil))

(= (map $f $lst)
   (match $lst
      (Cons $x $xs)
      (Cons ($f $x) (map $f $xs))))
