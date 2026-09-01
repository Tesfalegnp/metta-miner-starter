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


; ============================================================
; Support
; ============================================================

(= (support $kb $item)
   (size (human-likes $kb $item)))


; ============================================================
; Frequent pattern test
; ============================================================

(= (frequent? $support $min-support)
   (>= $support $min-support))


; ============================================================
; Mining result
; ============================================================

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