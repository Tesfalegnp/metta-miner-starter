; ============================================================
; MeTTa Recursion Library (educational)
; ============================================================
;
; Demonstrates recursive definitions using Peano numbers and list
; structures. Includes: factorial, fibonacci, sum_list, length (via
; list_lib), reverse, and recursive search/traversal.

!(load "../../02_lists/metta/list_lib.metta")

; -----------------------------
; Peano literals (extend small range for arithmetic results)
; -----------------------------
(Zero)
(Succ Zero)
(Succ (Succ Zero))
(Succ (Succ (Succ Zero)))
(Succ (Succ (Succ (Succ Zero))))
(Succ (Succ (Succ (Succ (Succ Zero)))))
(Succ (Succ (Succ (Succ (Succ (Succ Zero))))))

; -----------------------------
; Peano addition (plus)
; plus Zero b -> b
; plus (Succ a) b -> Succ (plus a b)
; -----------------------------
(= (plus Zero $b) $b)
(= (plus (Succ $a) $b) (Succ (plus $a $b)))

; -----------------------------
; Peano multiplication (mult)
; mult Zero b -> Zero
; mult (Succ a) b -> plus b (mult a b)
; -----------------------------
(= (mult Zero $b) Zero)
(= (mult (Succ $a) $b) (plus $b (mult $a $b)))

; -----------------------------
; Factorial (fact)
; fact Zero -> Succ Zero (1)
; fact (Succ n) -> mult (Succ n) (fact n)
; -----------------------------
(= (fact Zero) (Succ Zero))
(= (fact (Succ $n)) (mult (Succ $n) (fact $n)))

; -----------------------------
; Fibonacci (fib)
; fib Zero -> Zero
; fib (Succ Zero) -> Succ Zero
; fib (Succ (Succ n)) -> plus (fib (Succ n)) (fib n)
; -----------------------------
(= (fib Zero) Zero)
(= (fib (Succ Zero)) (Succ Zero))
(= (fib (Succ (Succ $n))) (plus (fib (Succ $n)) (fib $n)))

; -----------------------------
; Sum of a list (sum_list) using plus
; sum_list Nil -> Zero
; sum_list (Cons x xs) -> plus x (sum_list xs)
; -----------------------------
(= (sum_list (Nil)) Zero)
(= (sum_list (Cons $x $xs)) (plus $x (sum_list $xs)))

; -----------------------------
; Reverse list using append
; reverse Nil -> Nil
; reverse (Cons x xs) -> append (reverse xs) (Cons x Nil)
; -----------------------------
(= (reverse (Nil)) Nil)
(= (reverse (Cons $x $xs)) (append (reverse $xs) (Cons $x Nil)))

; -----------------------------
; Recursive search over lists uses `member` defined in list_lib.metta
; Tree traversal: represent tree as Node(Value Left Right)
; preorder traversal example
; -----------------------------
(= (preorder (Nil)) Nil)
(= (preorder (Node $v (Nil) (Nil))) (Cons $v Nil))
(= (preorder (Node $v $l $r)) (Cons $v (append (preorder $l) (preorder $r))))
