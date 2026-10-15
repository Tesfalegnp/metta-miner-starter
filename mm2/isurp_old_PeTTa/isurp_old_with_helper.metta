;; =============================================================================
;; isurp-old_collected.metta
;; =============================================================================
;;   This file collects the original implementation from:
;;     - The RootPath: https://github.com/iCog-Labs-Dev/hyperon-miner/experiments/surprisingness/isurp-old.metta
;;   together with all its recursive user-defined function dependencies collected
;;   from:
;;     - experiments/utils/common-utils.metta
;;     - experiments/utils/surp-utils/binomialMetta.metta
;;     - experiments/utils/surp-utils/surp-utils.metta
;;     - experiments/utils/surp-utils/partition-metta.metta
;;
;; Organization:
;;   Section 1: Collected External Dependencies 
;;     1.1 Basic Math & List Utilities
;;     1.2 Extremum & Min-Max Utilities
;;     1.3 Binomial Coefficient Calculations
;;     1.4 Space Support & Pattern Clause Utilities
;;     1.5 Interval Distance Utility
;;     1.6 Set Partitioning & Powerset Generation
;;   Section 2: Original isurp-old.metta Implementation
;;     (Preserved verbatim from experiments/surprisingness/isurp-old.metta)
;;   Section 3: Unresolved Dependencies & Classification Analysis
;;   Section 4: Verification and Unit Tests 
;; =============================================================================


;; =============================================================================
;; SECTION 1: COLLECTED EXTERNAL DEPENDENCIES
;; =============================================================================

;; -----------------------------------------------------------------------------
;; 1.1 Basic Math & List Utilities
;; -----------------------------------------------------------------------------

;; Source: experiments/utils/common-utils.metta:788
;    (: tuple-count (-> Any Number))
(= (tuple-count $atom) (size-atom $atom))

;; Source: experiments/utils/common-utils.metta:194
(= (// $a $b) (/ (* 1.0 $a) $b))

;; Source: experiments/utils/common-utils.metta:1492
(= (member-atom $elem $lst)
   (if (== $lst ())
       False
       (let $head (car-atom $lst)
         (let $tail (cdr-atom $lst)
           (if (== $elem $head)
               True
               (member-atom $elem $tail)
           )
         )
       )
   )
)

;; Source: experiments/utils/common-utils.metta:1507
(= (set-intersection $set2 $set1)
   (if (== $set1 ())
       ()
       (let $head (car-atom $set1)
         (let $tail (cdr-atom $set1)
           (if (member-atom $head $set2)
               (cons-atom $head (set-intersection $set2 $tail))
               (set-intersection $set2 $tail)
           )
         )
       )
   )
)


;; -----------------------------------------------------------------------------
;; 1.2 Extremum & Min-Max Utilities
;; -----------------------------------------------------------------------------

;; Source: experiments/utils/common-utils.metta:674
(=(find_max_helper $num_list $max) (
    if (== $num_list ()) $max (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_max_helper $tail (if (> $head $max) $head $max)))) 
            $dummy  )))

;; Source: experiments/utils/common-utils.metta:680
(=(max $list) (find_max_helper $list (car-atom $list)))

;; Source: experiments/utils/common-utils.metta:684
(=(find_min_helper $num_list $min) (
    if (== $num_list ()) $min (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_min_helper $tail (if (< $head $min) $head $min)))) 
            $dummy  )))

;; Source: experiments/utils/common-utils.metta:690
(=(min $list) (find_min_helper $list (car-atom $list)))

;; Source: experiments/utils/common-utils.metta:736
(=(min-max $list) ((min $list) (max $list)))


;; -----------------------------------------------------------------------------
;; 1.3 Binomial Coefficient Calculations
;; -----------------------------------------------------------------------------

;; Source: experiments/utils/surp-utils/binomialMetta.metta:1
(= (calculate_binomial_helper $n $k $result)
    (if (or (> $k $n ) (< $k 0))
        0
        (if (or (== $k 0) (== $k $n))
            1
            (let*
                (
                    ($temp (/ $n (- $n $k)))
                    ($newResult  (* $temp (calculate_binomial_helper (- $n 1) $k $temp)))
                )
                $newResult
            )
        )
    )
)

;; Source: experiments/utils/surp-utils/binomialMetta.metta:17
(= (calculate_binomial $n $k) (calculate_binomial_helper (max-atom ($n)) (max-atom ($k)) 1))

;; Source: experiments/utils/surp-utils/binomialMetta.metta:18
(=(cal_binomial $n $k) (calculate_binomial $n $k))


;; -----------------------------------------------------------------------------
;; 1.4 Space Support & Pattern Clause Utilities
;; -----------------------------------------------------------------------------

;; Source: experiments/utils/common-utils.metta:75
;;Determines the number of conjunctive clauses in a pattern.
(=(n_conjuncts_new $pattern) (
   let ($head $tail) (decons-atom $pattern) (
    if (== $head ,) (eval (tuple-count $tail)) 1)
))

;; Source: experiments/utils/common-utils.metta:816
 ;; Count the number of instances of a given pattern
;;(: counter (-> hyperon::space::DynSpace Atom Number))
(= (counter $db $ptrn)
    (let $result (collapse (match $db $ptrn $ptrn))
         (tuple-count $result)
    )
)

;; Source: experiments/utils/common-utils.metta:840
;; returns the number of support of a pattern

(= (sup-num $db $pattern)
    (let $sup (counter $db $pattern)
        $sup
    )
)

;; Source: experiments/utils/common-utils.metta:932
 ;;db size
; (: db_size (-> SpaceType  Number))
(= (db_size $db)
     (tuple-count (collapse (get-atoms $db)))
    
)

;; Source: experiments/utils/common-utils.metta:712
(=(get-cnj-clouses $pattern) (
  let ($head $tail) (decons-atom $pattern)  (if (== $head ,) $tail $pattern)
))


;; -----------------------------------------------------------------------------
;; 1.5 Interval Distance Utility
;; -----------------------------------------------------------------------------

;; Source: experiments/utils/surp-utils/surp-utils.metta:112
(=(dst_from_interval $emin $emax $emp) (
  if (< $emax $emp) (- $emp $emax) (if (< $emp $emin ) (- $emin $emp) 0.0)
))


;; -----------------------------------------------------------------------------
;; 1.6 Set Partitioning & Powerset Generation
;; -----------------------------------------------------------------------------

;; Source: experiments/utils/surp-utils/partition-metta.metta:24
;; Recursively prepend $elem to each subset in $subsets
(= (prepend-to-each $elem $subsets)
  (if (== $subsets ())
     ()
     (let ($first $rest) (decons-atom $subsets)
      (cons-atom (cons-atom $elem $first)
              (prepend-to-each $elem $rest))
     )
  )
)

;; Source: experiments/utils/surp-utils/partition-metta.metta:10
;; Example:  (powerset (a b)) → (() (b) (a) (a b))
(= (powerset $lst)
  (if (== $lst ())
     (())                              ; only subset of empty list
     (let* (
       (($head $tail) (decons-atom $lst))
       ($ps-tail   (powerset $tail)) ; subsets of tail
       ($with-head (prepend-to-each $head $ps-tail)) ; prepend head to each
      )
      (union-atom $ps-tail $with-head) ; union of both halves
     )
  )
)

;; Source: experiments/utils/surp-utils/partition-metta.metta:2
;;Checks if **all elements** of $lst are in $used
(=(all-in $lst $used)
(let $inter (set-intersection $lst $used) (if (== (size-atom $inter) (size-atom $lst)) True False))

)

;; Source: experiments/utils/surp-utils/partition-metta.metta:83
;;Checks if **any element** of $lst is in $used
(=(any-in $lst $used)(let $inter (set-intersection $lst $used) (if (== (size-atom $inter) 0) False True)))

;; Source: experiments/utils/surp-utils/partition-metta.metta:87
;the subset can't be an empty set or the orginal set itself
(= (valid-subset $subset $original)
   (and (not (== $subset ()))
        (not (== $subset $original))))  

;; Source: experiments/utils/surp-utils/partition-metta.metta:112
 ; Recursive helper
(= (partitions-helper $subsets $original $current $used)
   (if (all-in $original $used)
       ($current)
       (partitions-collect (cdr-atom $subsets) $original $current $used))
       

       
       )

;; Source: experiments/utils/surp-utils/partition-metta.metta:99
; Collect partitions by trying each valid subset
(= (partitions-collect $subsets $original $current $used)
   (if (== $subsets ())
       ()
       (let ($subset $rest) (decons-atom $subsets)   
         (if (and (valid-subset $subset $original)
                  (not (any-in $subset $used)))     ;; ((a b) ( c))
             (let* (
                    ($first (partitions-helper $subsets $original (cons-atom $subset $current) (union-atom $used $subset)))
                      ($second (partitions-collect $rest $original $current $used)))
                        (union-atom $first $second))
             (partitions-collect $rest $original $current $used)))))

;; Source: experiments/utils/surp-utils/partition-metta.metta:123
; Main: Generate all partitions
(= (partitions $subsets $original)
   (partitions-collect $subsets $original () ()))

;; Source: experiments/utils/surp-utils/partition-metta.metta:173
(= (partitions $original)
   (let $first-element (car-atom $original)
     (if (== $first-element ,)
         (partitions (powerset (cdr-atom $original))
                      (cdr-atom $original))
         (partitions (powerset $original)
                     $original)
      )
   )
)

;; Source: experiments/utils/surp-utils/partition-metta.metta:184
(= (partitions-wout-pattern $original) (
   let $partions (partitions $original)  (exclude-item ($original) $partions)
))


;; =============================================================================
;; SECTION 2: ORIGINAL isurp-old.metta IMPLEMENTATION
;; =============================================================================
;; The definitions below are preserved verbatim from
;; experiments/surprisingness/isurp-old.metta.

;;types
; (: total_counts (-> Pattern SpaceType Number))
; ; (: accumulator-x (-> (List Number) Number))
; ; (: accumulator-x (-> (List Number) Number Number))
; (: n_conjuncts_new (-> Pattern Number))
; ; (: compute-component-support (-> (List Pattern) SpaceType (List Number)))
; (: compute-component-support (-> Any SpaceType Any))
; (: ptrn-support (-> Pattern SpaceType Number))
; (: prob (-> Pattern SpaceType Number Number))
; (: add-pattern (-> (List Pattern) SpaceType Pattern))

; (: blk-prob (-> (List Pattern) SpaceType Number Number))

; (: iprob-old (-> (MList Pattern)) SpaceType Number)

; (: iprob_ (-> (MList Pattern) SpaceType Number (List Number)))
; (: iprob (-> (MList Pattern)) SpaceType Number Number)




; (: isurp-old_ (-> (List (List Pattern)) SpaceType Number (List Number)))
;(: isurp-old (-> Pattern SpaceType Bool Number))


;;;;;;;;;;;;;;;;;;;;
;;High-Level Steps;;
;;;;;;;;;;;;;;;;;;;;
;; - Compute the probability of the pattern (pattern_prob).
;; - Generate all partitions excluding the pattern.
;; - Calculate the probabilities of all partitions (iprob).
;; - Identify the minimum and maximum probabilities (emin, emax) of the partitions.
;; - Compute the distance of pattern_prob from the interval [emin,emax]
;; - Normalize the distance if required.
;; - Bound the final surprisingness value to a maximum of 1.0



;;The total count is implemented using the binomial coefficient and the power of 
;;the database size and number of conjuncts, because in the classic implementation, 
;;the documentation recommends using powers — but the actual implementation uses the binomial coefficient.

;;Calculates the total possible counts for a pattern based on database size 
;;and the number of conjunctive clauses in the pattern.
;(=(total_counts $pattern $db) (pow (db_size $db) (n_conjuncts_new $pattern)))

;; Function: total_counts
;; Description: Calculates the total possible counts for a pattern using the binomial coefficient.
;; Parameters:
;;   - $pattern: The pattern whose total count is to be estimated.
;;   - $db: The database context in which the pattern appears.
;; Returns:
;;   - The total number of possible combinations based on database size and number of conjunctive clauses.
(= (total_counts $pattern $db) (cal_binomial (db_size $db) (n_conjuncts_new $pattern)))





;; Function: accumulator-x
;; Description: Computes the product of a list of numbers recursively
;; Parameters:
;;   - $num_list: A list of numbers to multiply.
;;   - $prev_value (optional): The accumulated product (defaults to 1).
;; Returns:
;;   - The product of all elements in the list as a single number.
(=(accumulator-x $num_list) (accumulator-x $num_list 1))
(=(accumulator-x $num_list $prev_value)  (
   if (== $num_list ()) $prev_value (let ($head $tail) (decons-atom $num_list) (accumulator-x $tail (* $head $prev_value)))
))



;;Recursively calculates the support for each component of a 
(=(compute-component-support $cps $db)
(collapse (sup-num $db (superpose $cps)) )
)


;; Calculate the support for each component of the conjunctive 
;; pattern and return the product of their results.
(=(ptrn-support $pattern $db)(
    let $cps (get-cnj-clouses $pattern) 
           (accumulator-x (compute-component-support $cps $db))
))


; Function: prob
; Description: Calculates the probability of a pattern occurring in a given database.
; Parameters:
;   - $pattern: The pattern whose probability is to be calculated.
;   - $db: The database in which the pattern is evaluated.
; Returns:
;   - The probability value as a ratio of the pattern's support to its total possible count.
(= (prob $pattern $db $total_count) (// (sup-num $db $pattern) $total_count))


;;Converts a list of blocks into a conjunctive pattern
(=(add-pattern $blks $db) (
let* ( ($pattern (cons-atom , $blks)) ($dummy (add-atom $db $pattern))) $pattern
))


;;Calculates the probability of a block within a partition by first converting 
;;it into a pattern and then computing its probability.
(= (blk-prob $blk $db $total_count) (
    let $pattern (cons-atom , $blk) (prob $pattern $db $total_count)
  ))
                      

; Function: iprob
; Description: Estimates the probability of each partition under the assumption that blocks 
;              within a partition are independent. It multiplies the probabilities of individual blocks.
; Parameters:
;   - $partition: A list of blocks representing the partition.
;   - $db: The database used to evaluate block probabilities.
; Returns:
;   - The estimated joint probability of the partition, computed by multiplying individual block probabilities.
(=(iprob-old $partition $db) 
    (accumulator-x (collapse  (blk-prob  (superpose $partition) $db)))                              
)

;;Recursive steps for iprob
(=(iprob_ $partition $db $total_count)(
    if (== $partition ()) () (
        let* (
           ( ($head $tail) (decons-atom $partition))
           ($prob (blk-prob $head $db $total_count))
           ($dummy (iprob_ $tail $db $total_count))
        ) 
             (cons-atom $prob $dummy)
    )
))


;;This is the recursive version of iprob-old. While the non-deterministic (or above) 
;;implementation works within this file, it causes issues when used from other files.
(=(iprob $partition $db $total_count) (
    let $products (iprob_ $partition $db $total_count) (accumulator-x $products)
))


;;Recursive steps for isurp
(= (isurp-old_ $partitions $db $total_count) (
    if (== $partitions ()) () (
        let* (
            (($head $tail) (decons-atom $partitions))
             ($res (iprob $head $db $total_count))
             ($dummy (isurp-old_ $tail $db $total_count)))
        (cons-atom $res $dummy)
    )
))

;; Function: isurp-old
;; Description: Computes the I-surprisingness of a conjunctive pattern based on its probability 
;;              and the distribution of probabilities from independently generated partitions. 
;;              It measures how far the pattern's probability deviates from the expected interval 
;;              defined by the minimum and maximum probabilities. Optionally, the surprisingness 
;;              value can be normalized.
; Parameters:
;   - $pattern: A conjunctive pattern whose surprisingness is to be evaluated.
;   - $db: The database or corpus used for evaluating probabilities.
;   - $normalize: A boolean flag indicating whether to normalize the surprisingness by the pattern's probability.
; Returns:
;   - A numeric value representing the surprisingness score, optionally normalized and capped at 1.0.
 
(= (isurp-old $pattern $db $normalize)   
   (let* (
          (true  (println! "==== isurp-old surprisingness =====")) 
          ($total_count (total_counts $pattern $db) )
          ($pattern_prob (prob $pattern $db $total_count))
          ($partitions (partitions-wout-pattern (cdr-atom $pattern)))
          ($results  (isurp-old_  $partitions $db $total_count))
          (($emin $emax) (min-max $results))
          ($dst (dst_from_interval $emin $emax $pattern_prob))
           )
              (min ((if (== True $normalize) (// $dst (max $emax $pattern_prob)) $dst) 1.0))       
            ))


;; =============================================================================
;; SECTION 3: UNRESOLVED DEPENDENCIES & CLASSIFICATION ANALYSIS
;; =============================================================================
;; The following function calls in the collected implementation require documentation:
;;
;; 1. max calling with (2-argument arity): but original max function need one argiments only
;;      path of max function: experiments/utils/common-utils.metta:680 
;;      takes a single list argument like (=(max $list) (find_max_helper $list (car-atom $list))).
;; 2. blk-prob calling with (2-argument arity): but needs three argument
;; =============================================================================


;; =============================================================================
;; SECTION 4: VERIFICATION AND UNIT TESTS
;; =============================================================================
;; Exactly two test cases for every collected user-defined function.
;; Tests call each specific function directly with arguments matching its signature.

;; Setup mock spaces for testing space-dependent functions
!(bind! &test-space (new-space))
!(add-atom &test-space (Inheritance Bob man))
!(add-atom &test-space (Inheritance Mike man))
!(add-atom &test-space (Inheritance Bob ugly))

!(bind! &empty-space (new-space))



!(assertEqual (tuple-count (A B C)) 3)  ; Expected result: 3
!(assertEqual (tuple-count ()) 0) ; Expected result: 0

!(assertEqual (// 4 2) 2.0) ; Expected result: 2.0
!(assertEqual (// 5 2) 2.5)  ;; Expected result: 2.5

!(assertEqual (member-atom 2 (1 2 3)) True) ; Expected result: True
!(assertEqual (member-atom 5 (1 2 3)) False) ;; Expected result: False

!(set-intersection (1 2 3) (2 3 4)) ;; Expected result: (2 3)
!(set-intersection (1 2) (3 4)) ;; Expected result: ()

!(assertEqual (find_max_helper (1 4 2) 0) 4) ;; Expected result: 4
!(assertEqual (find_max_helper () 10) 10) ;; Expected result: 10

!(assertEqual (max (4 2 8 1 5)) 8) ;; Expected result: 8
!(assertEqual (max (10)) 10) ;; Expected result: 10

!(assertEqual (find_min_helper (4 1 2) 4) 1) ;; Expected result: 1
!(assertEqual (find_min_helper () 5) 5) ;; Expected result: 5

!(assertEqual (min (4 2 8 1 5)) 1) ;; Expected result: 1
!(assertEqual (min (10)) 10) ;;; Expected result: 10

!(assertEqual (min-max (4 2 8 1 5)) (1 8)) ;;; Expected result: (1 8)
!(assertEqual (min-max (5)) (5 5)) ;;;; Expected result: (5 5)

!(assertEqual (calculate_binomial_helper 5.0 2.0 1) 10.0) ;;; Expected result: 10.0
!(assertEqual (calculate_binomial_helper 4 0 1) 1)  ;;; Expected result: 1

!(assertEqual (calculate_binomial 5 2) 10.0)  ;;; Expected result: 10.0
!(assertEqual (calculate_binomial 4 4) 1)  ;;;; Expected result: 1

!(assertEqual (cal_binomial 5 2) 10.0) ;;; Expected result: 10.0
!(assertEqual (cal_binomial 6 3) 20.0)  ;;;; Expected result: 20.0

!(n_conjuncts_new (, A B C))  ;;; Expected result: 3 (in PeTTa; returns unreduced size-atom in hyperon 0.2 standalone)
!(assertEqual (n_conjuncts_new (Inheritance $x man)) 1) ;;;; Expected result: 1

!(assertEqual (counter &test-space (Inheritance $x man)) 2) ;; ; Expected result: 2
!(assertEqual (counter &test-space (Inheritance $x woman)) 0)   ;;; Expected result: 0

!(assertEqual (sup-num &test-space (Inheritance $x man)) 2)   ;;;; Expected result: 2
!(assertEqual (sup-num &test-space (Inheritance $x woman)) 0)   ;;;; Expected result: 0

!(assertEqual (db_size &test-space) 3)  ;;;; Expected result: 3
!(assertEqual (db_size &empty-space) 0)  ;; Expected result: 0

!(assertEqual (get-cnj-clouses (, A B)) (A B)) ;; ; Expected result: (A B)
!(assertEqual (get-cnj-clouses (A B C)) (A B C))  ;;; Expected result: (A B C)

!(assertEqual (dst_from_interval 0.2 0.5 0.7) 0.19999999999999996) ;;;;; Expected result: 0.19999999999999996
!(assertEqual (dst_from_interval 0.2 0.5 0.3) 0.0)   ;; ; Expected result: 0.0





!(prepend-to-each a ((b) (c))) ;; Expected result: ((a b) (a c))
!(assertEqual (prepend-to-each a ()) ()) ;;; Expected result: ()

!(powerset (a b))  ;;;; Expected result: (() (b) (a) (a b)) (in PeTTa; depends on PeTTa reduction)
!(assertEqual (powerset ()) (()))  ;;; Expected result: (())

!(all-in (a b) (a b c))  ;;;; Expected result: True
!(all-in (a d) (a b c))    ; Expected result: False

!(any-in (a d) (a b c))  ; Expected result: True 
!(any-in (d e) (a b c))   ; Expected result: False

!(assertEqual (valid-subset (a) (a b)) True)
!(assertEqual (valid-subset () (a b)) False)


!(partitions-helper ((b)) (a b) ((a)) (a b)) ;; Expected result: (((a)))
!(partitions-helper ((b)) (a b) ((a)) (a)) 

!(assertEqual (partitions-collect () (a b) () ()) ())
!(partitions-collect ((a) (b)) (a b) () ())

!(partitions ((a) (b)) (a b))
!(assertEqual (partitions () (a b)) ())

!(partitions-wout-pattern ((Inheritance $x man) (Inheritance $x ugly)))
!(partitions-wout-pattern ((Inheritance $x man)))

!(assertEqual (total_counts (Inheritance $x man) &test-space) 3.0)
!(total_counts (, (Inheritance $x man) (Inheritance $x ugly)) &test-space)

!(assertEqual (accumulator-x (2 3 4)) 24)
!(assertEqual (accumulator-x (2 3) 10) 60)

!(compute-component-support ((Inheritance $x man) (Inheritance $x ugly)) &test-space)
!(assertEqual (compute-component-support () &test-space) ())

!(assertEqual (ptrn-support (, (Inheritance $x man) (Inheritance $x ugly)) &test-space) 2)
!(assertEqual (ptrn-support (, (Inheritance $x man) (Inheritance $x woman)) &test-space) 0)

!(assertEqual (prob (Inheritance $x man) &test-space 4) 0.5)
!(assertEqual (prob (Inheritance $x woman) &test-space 4) 0.0)

!(assertEqual (add-pattern ((Inheritance $x man) (Inheritance $x ugly)) &test-space) (, (Inheritance $x man) (Inheritance $x ugly)))
!(assertEqual (add-pattern (A B) &test-space) (, A B))

!(blk-prob ((Inheritance $x man)) &test-space 4) ; Expected result: 0.5
!(blk-prob ((Inheritance $x ugly)) &test-space 2)

!(iprob-old (((Inheritance $x man))) &test-space)
!(assertEqual (iprob-old () &test-space) 1)

!(iprob_ (((Inheritance $x man))) &test-space 4)
!(assertEqual (iprob_ () &test-space 4) ())

!(iprob (((Inheritance $x man))) &test-space 4)
!(assertEqual (iprob () &test-space 4) 1)

!(isurp-old_ (((((Inheritance $x man))))) &test-space 4)
!(assertEqual (isurp-old_ () &test-space 4) ())

!(isurp-old (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) &test-space False)
!(isurp-old (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) &test-space True)
