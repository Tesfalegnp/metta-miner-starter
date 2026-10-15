;; =============================================================================
;;      MAIN I-SURPRISINGNESS ALGORITHM (MM2 / MORK)
;; =============================================================================
;; Purpose:
;;   Main surprisingness calculation algorithm converted from PeTTa isurp_old.metta to new Mork isurp_old.metta
;;  
;; Functions in this file:
;;   - isurp-old_ : Recursive partition step calculating partition probabilities
;;   - isurp-old  : Computes the I-surprisingness score of a conjunctive pattern
;;
;; Dependencies:
;;   Requires helper definitions in isurp-old-helpers.metta:
;;     mork run <query-file> <out-file> \
;;       --aux-path mm2/isurp_old_Mork/isurp-old-helpers.metta \
;;       --aux-path mm2/isurp_old_Mork/isurp-old.metta
;; =============================================================================


;; -----------------------------------------------------------------------------
;; Function: isurp-old_  Corresponding original PeTTa:
;;   (= (isurp-old_ $partitions $db $total_count) ...)
;; -----------------------------------------------------------------------------

;; empty partitions list -> empty result list ()
(exec (freq 047 isurp-old-sub-empty)
  (, (isurp-old_ () $db $total_count))
  (O
    (+ ())
    (- (isurp-old_ () $db $total_count))))

;; Single partition: start evaluation and counter for conjunct $c1
(exec (freq 048 isurp-old-sub-1)
  (, (isurp-old_ (((($c1)))) $db $total_count))
  (O
    (+ (isurp-sub-eval 1 $db $c1 $total_count))
    (+ (isurp-sub-cnt 1 $db 0))
    (- (isurp-old_ (((($c1)))) $db $total_count))))

;; Count occurrences of conjunct $c1 in $db
(exec (freq 049 isurp-sub-count)
  (, (isurp-sub-eval 1 $db $c1 $total_count)
     ($db $c1)
     (isurp-sub-cnt 1 $db 0))
  (O
    (count (isurp-sub-cnt 1 $db $count) $count $c1)
    (- (isurp-sub-cnt 1 $db 0))))

;; Compute probability count / total_count and emit result
(exec (freq 050 isurp-sub-finish)
  (, (isurp-sub-eval 1 $db $c1 $total_count)
     (isurp-sub-cnt 1 $db $count))
  (O
    (pure
      ($ratio_res)
      $ratio_res
      (f64_to_string
        (div_f64
          (f64_from_string $count)
          (f64_from_string $total_count))))
    (- (isurp-sub-eval 1 $db $c1 $total_count))
    (- (isurp-sub-cnt 1 $db $count))))

;; Preserved tests for isurp-old_:
; (isurp-old_ (((((Inheritance $m man))))) &test-space 4) ; expected: (0.5)
; (isurp-old_ () &test-space 4)                           ; expected: ()


;; -----------------------------------------------------------------------------
;; Function: isurp-old
;; Description:
;;   Computes the I-surprisingness of a conjunctive pattern based on its
;;   empirical probability in the database and the independent probability
;;   from its components. Measures deviation distance and optionally normalizes.
;; Corresponding original MeTTa:
;;   (= (isurp-old $pattern $db $normalize) ...)
;; Parameters:
;;   - (, $c1 $c2) : Conjunctive pattern
;;   - $db         : Database / atomspace context
;;   - $norm       : Boolean flag (True for normalized, False for raw bounded)
;; -----------------------------------------------------------------------------

;; Step 1: Initialize isurp-old evaluation and initialize counters
(exec (freq 080 isurp-start)
  (, (isurp-old (, $c1 $c2) $db $norm))
  (O
    (+ (isurp-eval ($c1 $c2) $db $norm))
    (+ (isurp-c-total $db $norm 0))
    (+ (isurp-c-joint $db $norm 0))
    (+ (isurp-c-1 $db $norm 0))
    (+ (isurp-c-2 $db $norm 0))
    (- (isurp-old (, $c1 $c2) $db $norm))))

;; Step 2a: Count total atoms in database $db (for total count N)
(exec (freq 081 isurp-cnt-db)
  (, (isurp-eval ($c1 $c2) $db $norm)
     ($db $atom)
     (isurp-c-total $db $norm 0))
  (O
    (count (isurp-c-total $db $norm $n) $n $atom)
    (- (isurp-c-total $db $norm 0))))

;; Step 2b: Count joint occurrences of ($c1 $c2)
(exec (freq 081 isurp-cnt-j)
  (, (isurp-eval ($c1 $c2) $db $norm)
     ($db $c1)
     ($db $c2)
     (isurp-c-joint $db $norm 0))
  (O
    (count (isurp-c-joint $db $norm $j) $j ($c1 $c2))
    (- (isurp-c-joint $db $norm 0))))

;; Step 2c: Count single occurrences of conjunct $c1
(exec (freq 081 isurp-cnt-one)
  (, (isurp-eval ($c1 $c2) $db $norm)
     ($db $c1)
     (isurp-c-1 $db $norm 0))
  (O
    (count (isurp-c-1 $db $norm $k1) $k1 $c1)
    (- (isurp-c-1 $db $norm 0))))

;; Step 2d: Count single occurrences of conjunct $c2
(exec (freq 081 isurp-cnt-two)
  (, (isurp-eval ($c1 $c2) $db $norm)
     ($db $c2)
     (isurp-c-2 $db $norm 0))
  (O
    (count (isurp-c-2 $db $norm $k2) $k2 $c2)
    (- (isurp-c-2 $db $norm 0))))

;; Step 3: Compute joint pattern probability and independent component product
(exec (freq 082 isurp-calc-joint)
  (, (isurp-eval $pair $db $norm)
     (isurp-c-total $db $norm $n)
     (isurp-c-joint $db $norm $j)
     (isurp-c-1 $db $norm $k1)
     (isurp-c-2 $db $norm $k2))
  (O
    (pure
      (isurp-p-joint $norm $ppat)
      $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (div_f64
            (f64_from_string
              (i64_to_string
                (product_i64
                  (i64_from_string $n)
                  (sub_i64 (i64_from_string $n) (i64_from_string 1)))))
            (f64_from_string 2.0)))))
    (pure
      (isurp-p-indep $norm $pindep)
      $pindep
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k1)
            (div_f64
              (f64_from_string
                (i64_to_string
                  (product_i64
                    (i64_from_string $n)
                    (sub_i64 (i64_from_string $n) (i64_from_string 1)))))
              (f64_from_string 2.0)))
          (div_f64
            (f64_from_string $k2)
            (div_f64
              (f64_from_string
                (i64_to_string
                  (product_i64
                    (i64_from_string $n)
                    (sub_i64 (i64_from_string $n) (i64_from_string 1)))))
              (f64_from_string 2.0))))))
    (- (isurp-eval $pair $db $norm))
    (- (isurp-c-total $db $norm $n))
    (- (isurp-c-joint $db $norm $j))
    (- (isurp-c-1 $db $norm $k1))
    (- (isurp-c-2 $db $norm $k2))))

;; Step 4a: Emit Raw result when normalize = False (capped at 1.0)
(exec (freq 083 isurp-emit-false)
  (, (isurp-p-joint False $ppat)
     (isurp-p-indep False $pindep))
  (O
    (pure
      ($res)
      $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $pindep)
                (f64_from_string $pindep))))
          (f64_from_string 1.0))))
    (- (isurp-p-joint False $ppat))
    (- (isurp-p-indep False $pindep))))

;; Step 4b: Emit Normalized result when normalize = True (divided by max(pindep, ppat), capped at 1.0)
(exec (freq 083 isurp-emit-true)
  (, (isurp-p-joint True $ppat)
     (isurp-p-indep True $pindep))
  (O
    (pure
      ($res)
      $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $pindep)
                  (f64_from_string $pindep))))
            (max_f64 (f64_from_string $pindep) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp-p-joint True $ppat))
    (- (isurp-p-indep True $pindep))))

;; Preserved tests for isurp-old:
(isurp-old (, (Inheritance $a man) (Inheritance $a ugly)) &test-space False) ; expected: (0.1111111111111111)
(isurp-old (, (Inheritance $b man) (Inheritance $b ugly)) &test-space True)  ; expected: (0.3333333333333333)
