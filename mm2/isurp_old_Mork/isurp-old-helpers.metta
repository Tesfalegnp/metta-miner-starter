; Demo atoms for MORK space
(&test-space (Inheritance Bob man))
(&test-space (Inheritance Mike man))
(&test-space (Inheritance Bob ugly))
(&space (Item 1))
(&space (Item 2))
(&space (Item 3))
(&space (Item 4))
(&space (Item 5))


  ;; Function: max & find_max_helper
(exec (freq 001 find-max-helper-empty)
  (, (find_max_helper () $init))
  (O (+ ($init)) 
      (- (find_max_helper () $init))))

  
(exec (freq 002 find-max-helper-list)
  (, (find_max_helper $lst $init))
  (O
    (pure ($result) $result (max-atom (' ($init $lst))))
    (- (find_max_helper $lst $init))))

; (find_max_helper (1 4 2) 0) ; expected: (4)
; (find_max_helper () 10)     ; expected: (10)


(exec (freq 003 max-single)
  (, (max ($x)))
  (O (+ ($x)) 
      (- (max ($x)))))

(exec (freq 004 max-multi)
  (, (max $lst))
  (O
    (pure ($result) $result (max-atom (' $lst)))
    (- (max $lst))))

(exec (freq 005 max-two-arg)
  (, (max $x $y))
  (O
    (pure ($result) $result (max-atom (' ($x $y))))
    (- (max $x $y))))

; (max (4 2 8 1 5))       ; expects: (8)
; (max (10))              ; expects: (10)
; (max 3 7)              ; expects: (7)

      ;; Function: min & find_min_helper
(exec (freq 006 find-min-helper-empty)
  (, (find_min_helper () $init))
  (O (+ ($init)) 
      (- (find_min_helper () $init))))

(exec (freq 007 find-min-helper-list)
  (, (find_min_helper $lst $init))
  (O
    (pure ($result) $result (min-atom (' ($init $lst))))
    (- (find_min_helper $lst $init))))

; (find_min_helper (4 1 2) 4) ; expected: (1)
; (find_min_helper () 5)      ; expected: (5)


(exec (freq 008 min-single)
  (, (min ($x)))
  (O (+ ($x)) 
      (- (min ($x)))))

(exec (freq 009 min-multi)
  (, (min $lst))
  (O
    (pure ($result) $result (min-atom (' $lst)))
    (- (min $lst))))

(exec (freq 010 min-two-arg)
  (, (min $x $y))
  (O
    (pure ($result) $result (min-atom (' ($x $y))))
    (- (min $x $y))))

; (min (4 2 8 1 5))       ; expected: (1)
; (min (10))              ; expected: (10)
; (min 5 10)              ; expected: (5)


        ;; Function: min-max
(exec (freq 011 min-max-start)
  (, (min-max $lst))
  (O
    (pure (min-max-step $lst $min) $min (min-atom (' $lst)))
    (- (min-max $lst))))

(exec (freq 012 min-max-finish)
  (, (min-max-step $lst $min))
  (O
    (pure ($min $max) $max (max-atom (' $lst)))
    (- (min-max-step $lst $min))))

; (min-max (4 2 8 1 5))   ; expected: (1 8)
; (min-max (5))           ; expected: (5 5)

      ;; Function: blk-prob
      ;; Calculates the probability of a block within a partition
(exec (freq 055 blk-prob-1)
  (, (blk-prob ($c1) $db $total_count))
  (O
    (+ (prob $c1 $db $total_count))
    (- (blk-prob ($c1) $db $total_count))))

(exec (freq 056 blk-prob-2)
  (, (blk-prob ($c1 $c2) $db $total_count))
  (O
    (+ (prob (, $c1 $c2) $db $total_count))
    (- (blk-prob ($c1 $c2) $db $total_count))))

; (blk-prob ((Inheritance $m man)) &test-space 4)   ; expected: (0.5)
; (blk-prob ((Inheritance $u ugly)) &test-space 2)  ; expected: (0.5)

        ;; Function: iprob_
        ;; Recursive probability step for partitions
(exec (freq 050 iprob-sub-empty)
  (, (iprob_ () $db $total_count))
  (O
    (+ ())
    (- (iprob_ () $db $total_count))))

(exec (freq 051 iprob-sub-one)
  (, (iprob_ (($c1)) $db $total_count))
  (O
    (+ (iprob-sub-req 1 $db $c1 $total_count))
    (+ (iprob-sub-cnt 1 $db 0))
    (- (iprob_ (($c1)) $db $total_count))))

(exec (freq 052 iprob-sub-count)
  (, (iprob-sub-req 1 $db $c1 $total_count)
     ($db $c1)
     (iprob-sub-cnt 1 $db 0))
  (O
    (count (iprob-sub-cnt 1 $db $count) $count $c1)
    (- (iprob-sub-cnt 1 $db 0))))

(exec (freq 053 iprob-sub-finish)
  (, (iprob-sub-req 1 $db $c1 $total_count)
     (iprob-sub-cnt 1 $db $count))
  (O
    (pure
      ($p1)
      $p1
      (f64_to_string
        (div_f64
          (f64_from_string $count)
          (f64_from_string $total_count))))
    (- (iprob-sub-req 1 $db $c1 $total_count))
    (- (iprob-sub-cnt 1 $db $count))))

; (iprob_ (((Inheritance $m man))) &test-space 4)   ; expected: (0.5)
; (iprob_ () &test-space 4)                         ; expected: ()

    ;; Function: iprob & iprob-old
    ;; Estimates joint probability of partition blocks under independence assumption
(exec (freq 050 iprob-old-empty)
  (, (iprob-old () $db))
  (O
    (+ (1))
    (- (iprob-old () $db))))

; (iprob-old () &test-space)                        ; expected: (1)

(exec (freq 050 iprob-base-empty)
  (, (iprob () $db $total_count))
  (O
    (+ (1))
    (- (iprob () $db $total_count))))

(exec (freq 051 iprob-one-block)
  (, (iprob (($c1)) $db $total_count))
  (O
    (+ (iprob-eval-req 1 $db $c1 $total_count))
    (+ (iprob-eval-cnt 1 $db 0))
    (- (iprob (($c1)) $db $total_count))))

(exec (freq 052 iprob-eval-count)
  (, (iprob-eval-req 1 $db $c1 $total_count)
     ($db $c1)
     (iprob-eval-cnt 1 $db 0))
  (O
    (count (iprob-eval-cnt 1 $db $count) $count $c1)
    (- (iprob-eval-cnt 1 $db 0))))

(exec (freq 053 iprob-eval-finish)
  (, (iprob-eval-req 1 $db $c1 $total_count)
     (iprob-eval-cnt 1 $db $count))
  (O
    (pure
      ($p)
      $p
      (f64_to_string
        (div_f64
          (f64_from_string $count)
          (f64_from_string $total_count))))
    (- (iprob-eval-req 1 $db $c1 $total_count))
    (- (iprob-eval-cnt 1 $db $count))))

(exec (freq 051 iprob-two-blocks)
  (, (iprob (($c1) ($c2)) $db $total_count))
  (O
    (+ (iprob-eval2-req $db $c1 $c2 $total_count))
    (+ (iprob-eval2-cnt1 $db 0))
    (+ (iprob-eval2-cnt2 $db 0))
    (- (iprob (($c1) ($c2)) $db $total_count))))

(exec (freq 051 iprob-two-blocks-direct)
  (, (iprob ($b1 $b2) $db $total_count))
  (O
    (+ (iprob-eval2-req $db $b1 $b2 $total_count))
    (+ (iprob-eval2-cnt1 $db 0))
    (+ (iprob-eval2-cnt2 $db 0))
    (- (iprob ($b1 $b2) $db $total_count))))

(exec (freq 052 iprob-eval2-count1)
  (, (iprob-eval2-req $db $c1 $c2 $total_count)
     ($db $c1)
     (iprob-eval2-cnt1 $db 0))
  (O
    (count (iprob-eval2-cnt1 $db $count) $count $c1)
    (- (iprob-eval2-cnt1 $db 0))))

(exec (freq 052 iprob-eval2-count2)
  (, (iprob-eval2-req $db $c1 $c2 $total_count)
     ($db $c2)
     (iprob-eval2-cnt2 $db 0))
  (O
    (count (iprob-eval2-cnt2 $db $count) $count $c2)
    (- (iprob-eval2-cnt2 $db 0))))

(exec (freq 053 iprob-eval2-finish)
  (, (iprob-eval2-req $db $c1 $c2 $total_count)
     (iprob-eval2-cnt1 $db $k1)
     (iprob-eval2-cnt2 $db $k2))
  (O
    (pure
      ($result)
      $result
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k1)
            (f64_from_string $total_count))
          (div_f64
            (f64_from_string $k2)
            (f64_from_string $total_count)))))
    (- (iprob-eval2-req $db $c1 $c2 $total_count))
    (- (iprob-eval2-cnt1 $db $k1))
    (- (iprob-eval2-cnt2 $db $k2))))

; (iprob (((Inheritance $m man))) &test-space 4)    ; expected: (0.5)
; (iprob () &test-space 4)                          ; expected: (1)


    ;; Function: prob
    ;; Step 1: Initialize prob, setup support counting for pattern in $db
(exec (freq 060 prob-start)
  (, (prob $pattern $db $total_count))
  (O
    (+ (prob-req $db $pattern $total_count))
    (+ (prob-cnt $db 0))
    (- (prob $pattern $db $total_count))))

;; Step 2: Count instances of pattern in $db (handles 0 instances if absent)
(exec (freq 061 prob-count)
  (, (prob-req $db $pattern $total_count)
     ($db $pattern)
     (prob-cnt $db 0))
  (O
    (count (prob-cnt $db $count) $count $pattern)
    (- (prob-cnt $db 0))))

(exec (freq 061 prob-count-two)
  (, (prob-req $db (, $c1 $c2) $total_count)
     ($db $c1)
     ($db $c2)
     (prob-cnt $db 0))
  (O
    (count (prob-cnt $db $count) $count ($c1 $c2))
    (- (prob-cnt $db 0))))

(exec (freq 061 prob-count-three)
  (, (prob-req $db (, $c1 $c2 $c3) $total_count)
     ($db $c1)
     ($db $c2)
     ($db $c3)
     (prob-cnt $db 0))
  (O
    (count (prob-cnt $db $count) $count ($c1 $c2 $c3))
    (- (prob-cnt $db 0))))

(exec (freq 061 prob-count-four)
  (, (prob-req $db (, $c1 $c2 $c3 $c4) $total_count)
     ($db $c1)
     ($db $c2)
     ($db $c3)
     ($db $c4)
     (prob-cnt $db 0))
  (O
    (count (prob-cnt $db $count) $count ($c1 $c2 $c3 $c4))
    (- (prob-cnt $db 0))))

;; Step 3: Forward support count and total_count to ratio function (//)
(exec (freq 062 prob-to-ratio)
  (, (prob-req $db $pattern $total_count)
     (prob-cnt $db $count))
  (O
    (+ (ratio $count $total_count))
    (- (prob-req $db $pattern $total_count))
    (- (prob-cnt $db $count))))

;; Step 4: Execute ratio calculation (// function)
(exec (freq 063 prob-ratio-exec)
  (, (ratio $a $b))
  (O
    (pure
      ($result)
      $result
      (f64_to_string
        (div_f64
          (f64_from_string $a)
          (f64_from_string $b))))
    (- (ratio $a $b))))

; (prob (Inheritance $x man) &test-space 4)  ;;; expected : 0.5
; (prob (Inheritance $x woman) &test-space 4)  ;; expects : 0.0

    ;; Function: add-pattern
    ;; with Two blocks
(exec (freq 070 add-pattern-2)
  (, (add-pattern ($b1 $b2) $db))
  (O
    (+ ((, $b1 $b2)))
    (+ ($db (, $b1 $b2)))
    (- (add-pattern ($b1 $b2) $db))))

;; With Three blocks
(exec (freq 071 add-pattern-3)
  (, (add-pattern ($b1 $b2 $b3) $db))
  (O
    (+ ((, $b1 $b2 $b3)))
    (+ ($db (, $b1 $b2 $b3)))
    (- (add-pattern ($b1 $b2 $b3) $db))))

;; With One block
(exec (freq 072 add-pattern-1)
  (, (add-pattern ($b1) $db))
  (O
    (+ ((, $b1)))
    (+ ($db (, $b1)))
    (- (add-pattern ($b1) $db))))

;; General fallback using pure cons
(exec (freq 073 add-pattern-cons)
  (, (add-pattern $blks $db))
  (O
    (pure
      ($pattern)
      $pattern
      (cons , (' $blks)))
    (pure
      ($db $pattern)
      $pattern
      (cons , (' $blks)))
    (- (add-pattern $blks $db))))

; (add-pattern ((Inheritance $x man) (Inheritance $x ugly)) &test-space)  ;;; Expected result: (, (Inheritance $x man) (Inheritance $x ugly))
; (add-pattern (A B) &test-space)  ;; Expected result: (, A B)


 
    ;; Function: ptrn-support
  ;; Two conjuncts with comma: (, $c1 $c2)
(exec (freq 150 ptrn-sup-two)
  (, (ptrn-support (, $c1 $c2) $db))
  (O
    (+ (ptrn-sup-wait $db ($c1 $c2)))
    (+ (compute-component-support ($c1 $c2) $db))
    (- (ptrn-support (, $c1 $c2) $db))))

;; Single clause: ($c1)
(exec (freq 151 ptrn-sup-one)
  (, (ptrn-support ($c1) $db))
  (O
    (+ (ptrn-sup-wait $db ($c1)))
    (+ (compute-component-support ($c1) $db))
    (- (ptrn-support ($c1) $db))))

;; Feed component support into accumulator-x
(exec (freq 350 ptrn-sup-feed-acc-2)
  (, (ptrn-sup-wait $db ($c1 $c2))
     (component-support-result $db ($c1 $c2) $counts))
  (O
    (+ (accumulator-x $counts))
    (- (ptrn-sup-wait $db ($c1 $c2)))
    (- (component-support-result $db ($c1 $c2) $counts))
    (- $counts)))

(exec (freq 351 ptrn-sup-feed-acc-1)
  (, (ptrn-sup-wait $db ($c1))
     (component-support-result $db ($c1) $counts))
  (O
    (+ (accumulator-x $counts))
    (- (ptrn-sup-wait $db ($c1)))
    (- (component-support-result $db ($c1) $counts))
    (- $counts)))

; (ptrn-support (, (Inheritance $x man) (Inheritance $x ugly)) &test-space)
; (ptrn-support (, (Inheritance $x man) (Inheritance $x woman)) &test-space)


;;Count database size N for the given $db in (total_counts $pattern $db)
(exec (freq 101 total-counts-db-size)
  (, (total_counts $pattern $db)
     ($db $atom))
  (O
    (count (total-counts-step1 $pattern $n) $n $atom)
    (- (total_counts $pattern $db))))

;;Extract head of pattern to check if it is a conjunction
(exec (freq 102 total-counts-head)
  (, (total-counts-step1 $pattern $n))
  (O
    (pure
      (total-counts-step2 $head $pattern $n)
      $head
      (car-atom (' $pattern)))
    (- (total-counts-step1 $pattern $n))))

;;Check if head is ','
(exec (freq 103 total-counts-check-comma)
  (, (total-counts-step2 $head $pattern $n))
  (O
    (pure
      (total-counts-step3 $is_comma $pattern $n)
      $is_comma
      (is-member $head (' (,))))
    (- (total-counts-step2 $head $pattern $n))))

;;Head is ',' so count conjuncts in tail
(exec (freq 104 total-counts-conj-true)
  (, (total-counts-step3 true $pattern $n))
  (O
    (pure
      (total-counts-ready $n $k)
      $k
      (size-atom (cdr-atom (' $pattern))))
    (- (total-counts-step3 true $pattern $n))))

;;  Head is not ',' so atomic clause, k = 1 , why that k=1?
(exec (freq 105 total-counts-conj-false)
  (, (total-counts-step3 false $pattern $n))
  (O
    (+ (total-counts-ready $n 1))
    (- (total-counts-step3 false $pattern $n))))

;;  Compute binomial coefficient C(n, k)
(exec (freq 106 total-counts-binom)
  (, (total-counts-ready $n $k))
  (O
    (pure
      ($result)
      $result
      (i64_to_string
        (div_i64
          (falling_factorial (i64_from_string $n) (i64_from_string $k))
          (factorial (i64_from_string $k)))))
    (- (total-counts-ready $n $k))))

; (total_counts (Item $x) &space) ;expected 5
; (total_counts (, (Item $x) (Item $y)) &space)  ; expected 10
; (total_counts (, (Item $x) (Item $y) (Item $z)) &space) ;expect 10


;; Function: accumulator-x,  Recursively computes the product of a list of numbers.

  ;; initialize accumulator to 1
(exec (freq 201 acc-total-list)
  (, (accumulator-x $list))
  (O
    (+ (accumulator-x $list 1))
    (- (accumulator-x $list))))

(exec (freq 401 acc-total-list-late)
  (, (accumulator-x $list))
  (O
    (+ (accumulator-x $list 1))
    (- (accumulator-x $list))))

;; empty list returns the accumulated value
(exec (freq 202 acc-empty)
  (, (accumulator-x () $acc))
  (O
    (+ ($acc))
    (- (accumulator-x () $acc))))

(exec (freq 402 acc-empty-late)
  (, (accumulator-x () $acc))
  (O
    (+ ($acc))
    (- (accumulator-x () $acc))))

;; initialize recursive state machine with call ID to prevent cross-call interference
(exec (freq 203 acc-start)
  (, (accumulator-x $list $acc)
     (DEF acc-split $s-p $s-t))
  (O
    (+ (acc-work ($list $acc) $list $acc))
    (+ (exec (freq 204 acc-split) $s-p $s-t))
    (- (accumulator-x $list $acc))))

(exec (freq 403 acc-start-late)
  (, (accumulator-x $list $acc)
     (DEF acc-split $s-p $s-t))
  (O
    (+ (acc-work ($list $acc) $list $acc))
    (+ (exec (freq 204 acc-split) $s-p $s-t))
    (- (accumulator-x $list $acc))))

;; Step 1: Decompose list into head and tail
(DEF acc-split
  (, (acc-work $id $list $acc)
     (DEF acc-calc $c-p $c-t))
  (O
    (pure (acc-head $id $head) $head (car-atom (' $list)))
    (pure (acc-tail $id $tail) $tail (cdr-atom (' $list)))
    (+ (acc-held $id $acc))
    (+ (exec (freq 205 acc-calc) $c-p $c-t))
    (- (acc-work $id $list $acc))))

;; Step 2: Multiply head by accumulator
(DEF acc-calc
  (, (acc-head $id $head)
     (acc-tail $id $tail)
     (acc-held $id $acc)
     (DEF acc-done $d-p $d-t)
     (DEF acc-next $n-p $n-t))
  (O
    (pure
      (acc-prod $id $new-acc)
      $new-acc
      (i64_to_string
        (product_i64
          (i64_from_string $head)
          (i64_from_string $acc))))
    (+ (acc-check $id $tail))
    (+ (exec (freq 206 acc-done) $d-p $d-t))
    (+ (exec (freq 207 acc-next) $n-p $n-t))
    (- (acc-head $id $head))
    (- (acc-tail $id $tail))
    (- (acc-held $id $acc))))

;; Terminal step: tail is empty () -> emit final product
(DEF acc-done
  (, (acc-check $id ())
     (acc-prod $id $final))
  (O
    (+ ($final))
    (- (acc-check $id ()))
    (- (acc-prod $id $final))))

;; Non-terminal step: tail is not empty -> stage for next recursive step
(DEF acc-next
  (, (acc-check $id $tail)
     (acc-prod $id $new-acc)
     (DEF acc-resume $r-p $r-t))
  (O
    (+ (acc-stage $id $tail $new-acc))
    (+ (exec (freq 208 acc-resume) $r-p $r-t))
    (- (acc-check $id $tail))
    (- (acc-prod $id $new-acc))))

;; Step 3: Loop back to acc-split with tail and updated accumulator
(DEF acc-resume
  (, (acc-stage $id $tail $new-acc)
     (DEF acc-split $s-p $s-t))
  (O
    (+ (acc-work $id $tail $new-acc))
    (+ (exec (freq 204 acc-split) $s-p $s-t))
    (- (acc-stage $id $tail $new-acc))))

; (accumulator-x (2 3 4))    ; expected: (24)
; (accumulator-x (2 3) 10)   ; expected: (60)
; (accumulator-x ())         ; expected: (1)


    ;; *************************************************************************
    ;; Function: compute-component-support
    ;; Calculates the support for each component of a conjunctive pattern in $db
    ;; *************************************************************************

  ;; Empty component list
(exec (freq 301 comp-sup-empty)
  (, (compute-component-support () $db))
  (O
    (+ ())
    (- (compute-component-support () $db))))

  ;; Single component
(exec (freq 302 comp-sup-one-start)
  (, (compute-component-support ($cmp_1) $db))
  (O
    (+ (comp-sup-one-request $db $cmp_1))
    (- (compute-component-support ($cmp_1) $db))))

(exec (freq 303 comp-sup-one-count)
  (, (comp-sup-one-request $db $c1)
     ($db $c1))
  (O
    (count (comp-sup-one-cnt $db $count) $count $c1)))

(exec (freq 304 comp-sup-one-finish)
  (, (comp-sup-one-cnt $db $count)
     (comp-sup-one-request $db $c1))
  (O
    (+ ($count))
    (- (comp-sup-one-cnt $db $count))
    (- (comp-sup-one-request $db $c1))))

  ;; Two components
(exec (freq 305 comp-sup-two-start)
  (, (compute-component-support ($c1 $c2) $db))
  (O
    (+ (component-sup-c1 $db $c1))
    (+ (component-sup-c2 $db $c2))
    (+ (comp-sup-cnt1 $db 0))
    (+ (comp-sup-cnt2 $db 0))
    (- (compute-component-support ($c1 $c2) $db))))

(exec (freq 306 comp-sup-two-count1)
  (, (component-sup-c1 $db $c1)
     ($db $c1)
     (comp-sup-cnt1 $db 0))
  (O
    (count (comp-sup-cnt1 $db $count) $count $c1)
    (- (comp-sup-cnt1 $db 0))))

(exec (freq 307 comp-sup-two-count2)
  (, (component-sup-c2 $db $c2)
     ($db $c2)
     (comp-sup-cnt2 $db 0))
  (O
    (count (comp-sup-cnt2 $db $count) $count $c2)
    (- (comp-sup-cnt2 $db 0))))

(exec (freq 308 comp-sup-two-finish)
  (, (comp-sup-cnt1 $db $k1)
     (comp-sup-cnt2 $db $k2)
     (component-sup-c1 $db $c1)
     (component-sup-c2 $db $c2))
  (O
    (+ (component-support-result $db ($c1 $c2) ($k2 $k1)))
    (+ ($k2 $k1))
    (- (comp-sup-cnt1 $db $k1))
    (- (comp-sup-cnt2 $db $k2))
    (- (component-sup-c1 $db $c1))
    (- (component-sup-c2 $db $c2))))

;; Three components: returns (count3 count2 count1)
(exec (freq 309 comp-sup-three-start)
  (, (compute-component-support ($c1 $c2 $c3) $db))
  (O
    (+ (comp-sup-3-c1 $db $c1))
    (+ (comp-sup-3-c2 $db $c2))
    (+ (comp-sup-3-c3 $db $c3))
    (- (compute-component-support ($c1 $c2 $c3) $db))))

(exec (freq 310 comp-sup-three-count1)
  (, (comp-sup-3-c1 $db $c1) ($db $c1))
  (O (count (comp-sup-3-cnt1 $db $count) $count $c1)))

(exec (freq 311 comp-sup-three-count2)
  (, (comp-sup-3-c2 $db $c2) ($db $c2))
  (O (count (comp-sup-3-cnt2 $db $count) $count $c2)))

(exec (freq 312 comp-sup-three-count3)
  (, (comp-sup-3-c3 $db $c3) ($db $c3))
  (O (count (comp-sup-3-cnt3 $db $count) $count $c3)))

(exec (freq 313 comp-sup-three-finish)
  (, (comp-sup-3-cnt1 $db $k1)
     (comp-sup-3-cnt2 $db $k2)
     (comp-sup-3-cnt3 $db $k3)
     (comp-sup-3-c1 $db $c1)
     (comp-sup-3-c2 $db $c2)
     (comp-sup-3-c3 $db $c3))
  (O
    (+ ($k3 $k2 $k1))
    (- (comp-sup-3-cnt1 $db $k1))
    (- (comp-sup-3-cnt2 $db $k2))
    (- (comp-sup-3-cnt3 $db $k3))
    (- (comp-sup-3-c1 $db $c1))
    (- (comp-sup-3-c2 $db $c2))
    (- (comp-sup-3-c3 $db $c3))))

; (compute-component-support ((Inheritance $x man) (Inheritance $x ugly)) &test-space) ; expected: (1 2)
; (compute-component-support () &test-space) ; expected: ()


;; -----------------------------------------------------------------------------
;; Function: //(Ratio) (Floating point division)
;; -----------------------------------------------------------------------------
(exec (freq 001 float-div)
  (, (// $a $b))
  (O
    (+ (ratio $a $b))
    (- (// $a $b))))
; (// 4 2)                ; expected: (2.0)
; (// 5 2)                ; expected: (2.5)


;    ;; Count the elements in each tuple-count request.
(exec ( freq 001 tuple-count-function)
        (, (tuple-count $atoms))
        (O
                (pure
                        ($count)
                        $count
                        (size-atom (' $atoms)))
                (- (tuple-count $atoms))))

; (tuple-count (A B C))
; (tuple-count (1 2 3 4 5))

;     ;; to get the ratio of two numbers. and from // function name converted to ration fucntion
(exec (freq 002 ratio_creator)
  (, (ratio $a $b))
  (O
    (pure
      ($result) ;;output variable
      $result
      (f64_to_string
        (div_f64
          (f64_from_string $a)
          (f64_from_string $b))))
    (- (ratio $a $b))))

; (ratio 10 3)

;  ; to check the membership of an element in a list. 
(exec (freq 003 member-atom)
  (, (member-atom $elem $lst))
  (O
    (pure
      ($result)
      $result
      (is-member $elem (' $lst)))
    (- (member-atom $elem $lst))))

; (member-atom 1 (1 2 3))



; ;; Set intersection using the registered intersection operation.

(exec (freq 004 set_intersection)
  (, (SET-INTERSECTION-REQUEST $set1 $set2))
  (O
    (pure
      (Result-Set $result) ;; Here why not working with one variable $result instead of (Result-Set $result), because the output variable is a set and not an atom.
      $result
      (intersection-atom (' ($set1 $set2))))
    (- (SET-INTERSECTION-REQUEST $set1 $set2)))
)

; (SET-INTERSECTION-REQUEST (1 2 3 4 5) (2 3 4 5))


(exec (freq 005 max-atom)
  (, (max-atom-request $lst))
  (O
    (pure
      ($result)
      $result
      (max-atom (' $lst)))
    (- (max-atom-request $lst))))

; (max-atom-request (2 4 5.9))

(exec (freq 006 min-atom)
  (, (min-atom-request $lst))
  (O
    (pure
      ($result)
      $result
      (min-atom (' $lst)))
    (- (min-atom-request $lst))))
; (min-atom-request (2 4 5.9))

;; this function calculates the binomial coefficient using the formula n! / (k! * (n-k)!)
(exec (freq 007 calculate_binomial)
  (, (cal_binomial $n $k))
  (O
    (pure
      ($result)
      $result
      (i64_to_string
        (div_i64
          (falling_factorial (i64_from_string $n) (i64_from_string $k))
          (factorial (i64_from_string $k)))))
    (- (cal_binomial $n $k))))

; ;; (cal_binomial 5 2)


 ;; Extract the head of the pattern
(exec (freq 008 n_conj_extract)
  (, (n_conjuncts_new $pattern))
  (O
    (pure
      (n_conj_step $head $pattern)
      $head
      (car-atom (' $pattern)))
    (- (n_conjuncts_new $pattern))))

  ;; Check if the head is the conjunction symbol ','
(exec (freq 009 n_conj_check_comma)
  (, (n_conj_step $head $pattern))
  (O
    (pure
      (n_conj_ready $is_comma $pattern)
      $is_comma
      (is-member $head (' (,))))
    (- (n_conj_step $head $pattern))))

  ;;If head is ',', count conjuncts in the tail using (size-atom (cdr-atom (' $pattern)))
(exec (freq 010 n_conj_true)
  (, (n_conj_ready true $pattern))
  (O
    (pure
      ($result)
      $result
      (size-atom (cdr-atom (' $pattern))))
    (- (n_conj_ready true $pattern))))

;;If head is not ',', it is a single atomic clause, so count is 1
(exec (freq 011 n_conj_false)
  (, (n_conj_ready false $pattern))
  (O
    (+ (1))
    (- (n_conj_ready false $pattern))))


; (n_conjuncts_new (, A B C D)) ; expected output: 4
; (n_conjuncts_new (Inheritance $x man)) ;expected output: 1



;; Forward sup-num request to counter in MORK ;; may not mandatory coz counter-pattern is already defined, but for clarity and explicitness, we can keep it here.
(exec (freq 011 sup-num-to-counter)
  (, (sup-num $db $pattern))
  (O (+ (counter $db $pattern))
     (- (sup-num $db $pattern))))

; (sup-num &test-space (Inheritance $x man)) ; expected output: 2


; ;; MORK exec rule for counting matching pattern instances from atomspace
(exec (freq 012 counter-pattern)
  (, (counter $db $pattern)($db $pattern))
  (O (count ($count) $count $pattern)
      (- (counter $db $pattern))))

; ;; (counter &test-space (Inheritance $x man)) ; expected output: 2


;; Database size calculation in MORK
(exec (freq 013 database_size)
    (, (db_size $db) 
       ($db $atom))
    (O (count ($count) $count $atom)
       (- (db_size $db))))

; (db_size &test-space) ; expected output: 3


;; get conjection clauses from a pattern with supporting with helper functions.
(exec (freq 014 get-conj-extract)
  (, (get-cnj-clouses $pattern))
  (O
    (pure
      (get-conj-check $head $pattern)
      $head
      (car-atom (' $pattern)))
    (- (get-cnj-clouses $pattern))))

;; Check if head is ','
(exec (freq 015 get-conj-bool)
  (, (get-conj-check $head $pattern))
  (O
    (pure
      (get-conj-route $is_comma $pattern)
      $is_comma (is-member $head (' (,))))
    (- (get-conj-check $head $pattern))))

;; If head is ',', return tail (cdr-atom)
(exec (freq 016 get-conj-true)
  (, (get-conj-route true $pattern))
  (O
    (pure
      $result
      $result
      (cdr-atom (' $pattern)))
    (- (get-conj-route true $pattern))))

;;else, return the pattern unchanged
(exec (freq 017 get-conj-false)
  (, (get-conj-route false $pattern))
  (O
    (+ $pattern)
    (- (get-conj-route false $pattern))))

; ;; Test cases in MORK:
; (get-cnj-clouses (A B C)) ; expected output: (A B C)
; (get-cnj-clouses (, A B)) ; expected output: (A B)


(exec (freq 018 distance-from-interval)
  (, (dst_from_interval $emin $emax $emp))
  (O
    (pure
      ($result)
      $result
      (f64_to_string
        (abs_f64
          (sub_f64
            (f64_from_string $emp)
            (clamp_f64
              (f64_from_string $emp)
              (f64_from_string $emin)
              (f64_from_string $emax))))))
    (- (dst_from_interval $emin $emax $emp))))

; (dst_from_interval 0.2 0.5 0.7) ; expected output: 0.19999999999999996
; (dst_from_interval 0.2 0.5 0.3) ; expected output: 0.0
  

;; Prepend element to empty subsets list () -> ()
(exec (freq 019 prepend-empty)
  (, (prepend-to-each $elem ()))
  (O
    (+ ())
    (- (prepend-to-each $elem ()))))

;; Prepend element to single subset
(exec (freq 020 prepend-one)
  (, (prepend-to-each $elem ($s1)))
  (O
    (pure
      (prepend-one-done $r1)
      $r1
      (cons $elem (' $s1)))
    (- (prepend-to-each $elem ($s1)))))

(exec (freq 021 prepend-one-finish)
  (, (prepend-one-done $r1))
  (O
    (+ ($r1))     ;;return the result of prepending the element to the single subset
    (- (prepend-one-done $r1))))

;; Prepend element to two subsets
(exec (freq 022 prepend-two)
  (, (prepend-to-each $elem ($s1 $s2)))
  (O
    (pure (prepend-two-step1 $elem $s2 $r1) $r1 (cons $elem (' $s1)))
    (- (prepend-to-each $elem ($s1 $s2)))))

(exec (freq 023 prepend-two-step2)
  (, (prepend-two-step1 $elem $s2 $r1))
  (O
    (pure (prepend-two-done $r1 $r2) $r2 (cons $elem (' $s2)))
    (- (prepend-two-step1 $elem $s2 $r1))))

(exec (freq 024 prepend-two-finish)
  (, (prepend-two-done $r1 $r2))
  (O
    (+ ($r1 $r2)) ;;return the result of prepending the element to both subsets but 
                        ;; what about the subsets element morethan 2, we need to handle that case as well, 
                                ;; so we can use recursion to handle that case.
    (- (prepend-two-done $r1 $r2))))

; ;; Function: prepend-to-each
; (prepend-to-each a ((b) (c))) ; expected: ((a b) (a c))
; (prepend-to-each a ())        ; expected: ()
; (prepend-to-each a ((d)))        ; expected: ((a d))



;; Powerset of empty set () -> (())
(exec (freq 025 powerset-empty)
  (, (powerset ()))
  (O
    (+ (()))
    (- (powerset ()))))

;; Powerset of 1-element set ($x) -> (() ($x))
(exec (freq 026 powerset-one)
  (, (powerset ($x)))
  (O
    (+ (() ($x)))
    (- (powerset ($x)))))

;; Powerset of 2-element set ($x $y) -> (() ($y) ($x) ($x $y))
(exec (freq 027 powerset-two)
  (, (powerset ($x $y)))
  (O
    (+ (() ($y) ($x) ($x $y))) ;; what about the set of the element too large?
    (- (powerset ($x $y)))))

; ;; Function: powerset
; (powerset (a b))              ; expected: (() (b) (a) (a b))
; (powerset ())                 ; expected: (())


(exec (freq 028 all-in-diff)
  (, (all-in $lst $used))
  (O
    (pure
      (all-in-diff $diff)
      $diff
      (subtraction-atom (' ($lst $used))))
    (- (all-in $lst $used))))

(exec (freq 029 all-in-size)
  (, (all-in-diff $diff))
  (O
    (pure
      (all-in-len $len)
      $len
      (size-atom (' $diff)))
    (- (all-in-diff $diff))))

(exec (freq 030 all-in-true)
  (, (all-in-len 0))
  (O
    (+ (True))
    (- (all-in-len 0))))

(exec (freq 031 all-in-false)
  (, (all-in-len $other))
  (O
    (+ (False))
    (- (all-in-len $other))))


; ;; Function: all-in
; (all-in (a b) (a b c))        ; expectation output: True
; (all-in (a d) (a b c))        ; expectation output: False


(exec (freq 032 any-in-inter)
  (, (any-in $lst $used))
  (O
    (pure
      (any-in-diff $inter)
      $inter
      (intersection-atom (' ($lst $used))))
    (- (any-in $lst $used))))

(exec (freq 033 any-in-size)
  (, (any-in-diff $inter))
  (O
    (pure
      (any-in-len $len)
      $len
      (size-atom (' $inter)))
    (- (any-in-diff $inter))))

(exec (freq 034 any-in-false)
  (, (any-in-len 0))
  (O
    (+ (False))
    (- (any-in-len 0))))

(exec (freq 035 any-in-true)
  (, (any-in-len $other))
  (O
    (+ (True))
    (- (any-in-len $other))))

; (any-in (a d) (a b c))        ; expected-output: True
; (any-in (d e) (a b c))        ; expected: False


;; empty set is not subset to oginal set
(exec (freq 036 valid-subset-empty)
  (, (valid-subset () $original))
  (O
    (+ (False))
    (- (valid-subset () $original))))


;;A subset is equal to the original also invalid.

(exec (freq 037 valid-subset-equal)
  (, (valid-subset $same $same))
  (O
    (+ (False))
    (- (valid-subset $same $same))))


;; Every element of S belongs to O is valid subset.

(exec (freq 038 valid-subset-difference)
  (, (valid-subset $subset $original))
  (O
    (pure
      (valid-subset-diff $diff)
      $diff
      (subtraction-atom (' ($subset $original))))
    (- (valid-subset $subset $original))))


;;Calculate the size of S - O.

(exec (freq 039 valid-subset-difference-size)
  (, (valid-subset-diff $diff))
  (O
    (pure
      (valid-subset-diff-size $len)
      $len
      (size-atom (' $diff)))
    (- (valid-subset-diff $diff))))


;;An empty(0) difference means S is contained in O.

(exec (freq 040 valid-subset-contained)
  (, (valid-subset-diff-size 0))
  (O
    (+ (True)) ;;Valid
    (- (valid-subset-diff-size 0))))


;;A non-empty difference means S is not fully contained in O.

(exec (freq 041 valid-subset-not-contained)
  (, (valid-subset-diff-size $len))
  (O
    (+ (False)) ;;Invalid
    (- (valid-subset-diff-size $len))))

; ;; test-1
; (valid-subset (a b) (a b c))      ; expected: True
; (valid-subset () (a b))       ; expected: False
; (valid-subset (a b) (a b))       ; expected: False



(exec (freq 042 partitions-helper-covered)
  (, (partitions-helper $subsets $orig $current $orig))
  (O
    (+ ($current))
    (- (partitions-helper $subsets $orig $current $orig))))

(exec (freq 043 partitions-helper-empty-tail)
  (, (partitions-helper ($s) $orig $current $used))
  (O
    (+ ())
    (- (partitions-helper ($s) $orig $current $used))))

; ;; Function: partitions-helper
; (partitions-helper ((b)) (a b) ((a)) (a b)) ; expected: (((a)))
; (partitions-helper ((b)) (a b) ((a)) (a))   ; expected: ()

(exec (freq 041 partitions-collect-empty)
  (, (partitions-collect () $orig $curr $used))
  (O
    (+ ())
    (- (partitions-collect () $orig $curr $used))))

(exec (freq 042 partitions-collect-two)
  (, (partitions-collect ($s1 $s2) $orig () ()))
  (O
    (+ (($s1 $s2)))
    (- (partitions-collect ($s1 $s2) $orig () ()))))


; ;; Function: partitions-collect
; (partitions-collect () (a b) () ())         ; expected: ()
; (partitions-collect ((a) (b)) (a b) () ())  ; expected: (((a) (b)))


(exec (freq 043 partitions-two-arg-empty)
  (, (partitions () $orig))
  (O
    (+ ())
    (- (partitions () $orig))))

(exec (freq 044 partitions-two-arg)
  (, (partitions ($s1 $s2) $orig))
  (O
    (+ (($s1 $s2)))
    (- (partitions ($s1 $s2) $orig))))


; (partitions ((a) (b)) (a b))                ; expected: (((a) (b)))
; (partitions () (a b))                       ; expected: ()



(exec (freq 045 partitions-wout-pattern)
  (, (partitions-wout-pattern $pattern))
  (O
    (pure
      (partitions-wout-pattern-res $result)
      $result
      (partitions (' $pattern)))
    (- (partitions-wout-pattern $pattern))))

(exec (freq 046 partitions-wout-pattern-finish)
  (, (partitions-wout-pattern-res $result))
  (O
    (+ $result)
    (- (partitions-wout-pattern-res $result))))


; (partitions-wout-pattern ((Inheritance $x man) (Inheritance $x ugly))) ; expectation: ((((Inheritance $a man)) ((Inheritance $b ugly))))
; (partitions-wout-pattern ((Inheritance $x man)))                       ; expectation: ()
; (partitions-wout-pattern (a b))                       ; expects: ((a) (b))



; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; ;; Clean up component support result tag
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(exec (freq 997 clean-comp-sup-res)
  (, (component-support-result $db $cps $counts))
  (O (- (component-support-result $db $cps $counts))))

;; Clean up counter request tags from final output
(exec (freq 996 clean-counter-req)
  (, (counter $db $pattern))
  (O (- (counter $db $pattern))))

;; Clean up DEF template action code from final output
(exec (freq 998 clean-acc-defs)
  (, (DEF $name $p $t))
  (O (- (DEF $name $p $t))))

;; Clean up demo atoms from final output
(exec (freq 999 clean-test-space)
  (, (&test-space $item))
  (O (- (&test-space $item))))
(exec (freq 1000 clean-space)
  (, (&space $item))
  (O (- (&space $item))))


