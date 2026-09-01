; ============================================================
; Pattern Miner Mini Project - Mining Logic
; ============================================================

; ------------------------------------------------------------
; Find humans who like an item.
;
; Pattern:
;
;   Human($x)
;   AND
;   Likes($x, $item)
;
; ------------------------------------------------------------

(= (human-likes $kb $item)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x $item))
         $x)))


; ------------------------------------------------------------
; Count results.
; ------------------------------------------------------------

(= (count-list ()) 0)

(= (count-list ($head $tail))
   (+ 1 (count-list $tail)))


; ------------------------------------------------------------
; Calculate support.
;
; Support = number of entities satisfying:
;
;   Human($x)
;   AND
;   Likes($x, $item)
;
; ------------------------------------------------------------

(= (support $kb $item)
   (count-list (human-likes $kb $item)))


; ------------------------------------------------------------
; Minimum-support test.
; ------------------------------------------------------------

(= (frequent? $support $min-support)
   (>= $support $min-support))


; ------------------------------------------------------------
; Produce mining result.
; ------------------------------------------------------------

(= (mine-pattern $kb $item $min-support)
   (let $s (support $kb $item)
      (if (frequent? $s $min-support)
          (PatternResult
             (HumanLikes $item)
             $s
             Frequent)
          (PatternResult
             (HumanLikes $item)
             $s
             Infrequent))))


; ============================================================
; Two-Clause Pattern: Human + Soda
; ============================================================

(= (human-soda-pattern $kb)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x Soda))
         $x)))


; ============================================================
; Two-Clause Pattern: Human + Pizza
; ============================================================

(= (human-pizza-pattern $kb)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x Pizza))
         $x)))


; ============================================================
; Three-Clause Pattern:
;
; Human($x)
; AND Likes($x, Soda)
; AND Likes($x, Pizza)
;
; Demonstrates conjunction expansion.
; ============================================================

(= (human-soda-pizza-pattern $kb)
   (match $kb
      (Inheritance $x Human)
      (match $kb
         (Evaluation (Likes $x Soda))
         (match $kb
            (Evaluation (Likes $x Pizza))
            $x))))