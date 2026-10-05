;; ==============================================================================
;; ISurp-Old MM2 / MORK Execution Rules
;; Path: src/isurp_old.metta
;;
;; Purpose:
;;   Deterministic, independent MM2 implementation of the original `isurp-old`
;;   algorithm for 3-conjunct patterns: (c1 c2 c3).
;;
;; Specification:
;;   - Evaluates the 4 independent partition products:
;;       P1 = P(c1)    * P(c2, c3)
;;       P2 = P(c1,c3) * P(c2)
;;       P3 = P(c1,c2) * P(c3)
;;       P4 = P(c1)    * P(c2) * P(c3)
;;   - Computes emin = min(P1, P2, P3, P4) and emax = max(P1, P2, P3, P4)
;;   - Computes interval distance: max(0.0, emin - emp, emp - emax)
;;   - Normalizes if NORMALIZATION = TRUE: min(distance / max(emax, emp), 1.0)
;;   - Raw bounded if NORMALIZATION = FALSE: min(distance, 1.0)
;;   - Denominator rule: Block probabilities use the full pattern total count.
;; ==============================================================================


;; ==============================================================================
;; 1. DIRECT COMPONENT RULES (Independently Testable Primitives)
;; ==============================================================================

;; 1.1 Interval Distance: max(0.0, emin - emp, emp - emax)
(exec (freq 010 interval-distance)
  (, (INTERVAL-DISTANCE-REQUEST $id $emin $emax $emp))
  (O
    (pure
      (INTERVAL-DISTANCE-RESULT $id $dist)
      $dist
      (f64_to_string
        (max_f64
          (sub_f64 (f64_from_string $emin) (f64_from_string $emp))
          (sub_f64 (f64_from_string $emp) (f64_from_string $emax))
          (f64_from_string 0.0))))))

;; 1.2 Normalization: min(distance / max(emax, emp), 1.0)
(exec (freq 020 normalization)
  (, (NORMALIZATION-REQUEST $id $dist $emax $emp))
  (O
    (pure
      (NORMALIZATION-RESULT $id $result)
      $result
      (f64_to_string
        (min_f64
          (div_f64
            (f64_from_string $dist)
            (max_f64
              (f64_from_string $emax)
              (f64_from_string $emp)))
          (f64_from_string 1.0))))))

;; 1.3 Raw Bounding: min(distance, 1.0)
(exec (freq 030 raw-bound)
  (, (RAW-BOUND-REQUEST $id $dist))
  (O
    (pure
      (RAW-BOUND-RESULT $id $result)
      $result
      (f64_to_string
        (min_f64
          (f64_from_string $dist)
          (f64_from_string 1.0))))))


;; ==============================================================================
;; 2. PATTERN UNPACKING & BRIDGING
;; ==============================================================================

;; Handle conjunctive tuple (, c1 c2 c3) by unpacking into (c1 c2 c3)
(exec (freq 040 unpack-conjunction)
  (, (ISURP-REQUEST $id (, $c1 $c2 $c3) $support))
  (O
    (+ (ISURP-REQUEST $id ($c1 $c2 $c3) $support))))

;; Compatibility bridge: (INPUT PATTERN ...) style
(exec (freq 041 bridge-input-pattern)
  (, (INPUT PATTERN ($c1 $c2 $c3) $support))
  (O
    (+ (ISURP-REQUEST isurp-default ($c1 $c2 $c3) $support))))

(exec (freq 042 bridge-input-db-size)
  (, (INPUT DB-SIZE $db-size))
  (O
    (+ (ISURP-DB-SIZE isurp-default $db-size))))

(exec (freq 043 bridge-input-norm)
  (, (INPUT NORMALIZATION $mode))
  (O
    (+ (ISURP-NORMALIZATION isurp-default $mode))))

(exec (freq 044 bridge-input-block-support)
  (, (INPUT BLOCK-SUPPORT $block $support))
  (O
    (+ (ISURP-BLOCK-SUPPORT isurp-default $block $support))))


;; ==============================================================================
;; 3. TOTAL COUNTS (Binomial Coefficient C(N, 3))
;; ==============================================================================

(exec (freq 050 total-counts-3conjunct)
  (, (ISURP-REQUEST $id ($c1 $c2 $c3) $support)
     (ISURP-DB-SIZE $id $db-size))
  (O
    (pure
      (ISURP-TOTAL-COUNT $id $total)
      $total
      (i64_to_string
        (div_i64
          (falling_factorial
            (i64_from_string $db-size)
            (i64_from_string 3))
          (factorial
            (i64_from_string 3)))))))


;; ==============================================================================
;; 4. EMPIRICAL PATTERN PROBABILITY
;; ==============================================================================

(exec (freq 060 empirical-probability)
  (, (ISURP-REQUEST $id $pattern $support)
     (ISURP-TOTAL-COUNT $id $total))
  (O
    (pure
      (ISURP-EMP-PROB $id $prob)
      $prob
      (f64_to_string
        (div_f64
          (f64_from_string $support)
          (f64_from_string $total))))))


;; ==============================================================================
;; 5. BLOCK PROBABILITIES
;;
;; Denominator rule: Block probabilities must use the total count of the full
;; pattern (matching original prob / blk-prob behavior).
;; ==============================================================================

;; Singleton blocks: (c)
(exec (freq 070 block-prob-singleton)
  (, (ISURP-BLOCK-SUPPORT $id ($c) $support)
     (ISURP-TOTAL-COUNT $id $total))
  (O
    (pure
      (ISURP-BLOCK-PROB $id ($c) $prob)
      $prob
      (f64_to_string
        (div_f64
          (f64_from_string $support)
          (f64_from_string $total))))))

;; Pair blocks: (c1 c2)
(exec (freq 072 block-prob-pair)
  (, (ISURP-BLOCK-SUPPORT $id ($c1 $c2) $support)
     (ISURP-TOTAL-COUNT $id $total))
  (O
    (pure
      (ISURP-BLOCK-PROB $id ($c1 $c2) $prob)
      $prob
      (f64_to_string
        (div_f64
          (f64_from_string $support)
          (f64_from_string $total))))))


;; ==============================================================================
;; 6. PARTITION PROBABILITIES (4 Independent Partitions)
;; ==============================================================================

;; Partition 1: P(c1) * P(c2, c3)
(exec (freq 080 partition-p1)
  (, (ISURP-REQUEST $id ($c1 $c2 $c3) $support)
     (ISURP-BLOCK-PROB $id ($c1) $p1)
     (ISURP-BLOCK-PROB $id ($c2 $c3) $p23))
  (O
    (pure
      (ISURP-PARTITION-PROB $id p1 $p1-val)
      $p1-val
      (f64_to_string
        (product_f64
          (f64_from_string $p1)
          (f64_from_string $p23))))))

;; Partition 2: P(c1, c3) * P(c2)
(exec (freq 081 partition-p2)
  (, (ISURP-REQUEST $id ($c1 $c2 $c3) $support)
     (ISURP-BLOCK-PROB $id ($c1 $c3) $p13)
     (ISURP-BLOCK-PROB $id ($c2) $p2))
  (O
    (pure
      (ISURP-PARTITION-PROB $id p2 $p2-val)
      $p2-val
      (f64_to_string
        (product_f64
          (f64_from_string $p13)
          (f64_from_string $p2))))))

;; Partition 3: P(c1, c2) * P(c3)
(exec (freq 082 partition-p3)
  (, (ISURP-REQUEST $id ($c1 $c2 $c3) $support)
     (ISURP-BLOCK-PROB $id ($c1 $c2) $p12)
     (ISURP-BLOCK-PROB $id ($c3) $p3))
  (O
    (pure
      (ISURP-PARTITION-PROB $id p3 $p3-val)
      $p3-val
      (f64_to_string
        (product_f64
          (f64_from_string $p12)
          (f64_from_string $p3))))))

;; Partition 4: P(c1) * P(c2) * P(c3)
(exec (freq 083 partition-p4)
  (, (ISURP-REQUEST $id ($c1 $c2 $c3) $support)
     (ISURP-BLOCK-PROB $id ($c1) $p1)
     (ISURP-BLOCK-PROB $id ($c2) $p2)
     (ISURP-BLOCK-PROB $id ($c3) $p3))
  (O
    (pure
      (ISURP-PARTITION-PROB $id p4 $p4-val)
      $p4-val
      (f64_to_string
        (product_f64
          (f64_from_string $p1)
          (f64_from_string $p2)
          (f64_from_string $p3))))))


;; ==============================================================================
;; 7. INTERVAL BOUNDS: emin & emax
;; ==============================================================================

(exec (freq 090 interval-bounds)
  (, (ISURP-PARTITION-PROB $id p1 $p1)
     (ISURP-PARTITION-PROB $id p2 $p2)
     (ISURP-PARTITION-PROB $id p3 $p3)
     (ISURP-PARTITION-PROB $id p4 $p4))
  (O
    (pure
      (ISURP-INTERVAL-EMIN $id $emin)
      $emin
      (f64_to_string
        (min_f64
          (f64_from_string $p1)
          (f64_from_string $p2)
          (f64_from_string $p3)
          (f64_from_string $p4))))
    (pure
      (ISURP-INTERVAL-EMAX $id $emax)
      $emax
      (f64_to_string
        (max_f64
          (f64_from_string $p1)
          (f64_from_string $p2)
          (f64_from_string $p3)
          (f64_from_string $p4))))))


;; ==============================================================================
;; 8. DISTANCE FROM INTERVAL
;; ==============================================================================

(exec (freq 100 pattern-distance)
  (, (ISURP-INTERVAL-EMIN $id $emin)
     (ISURP-INTERVAL-EMAX $id $emax)
     (ISURP-EMP-PROB $id $emp))
  (O
    (pure
      (ISURP-DISTANCE $id $dist)
      $dist
      (f64_to_string
        (max_f64
          (sub_f64 (f64_from_string $emin) (f64_from_string $emp))
          (sub_f64 (f64_from_string $emp) (f64_from_string $emax))
          (f64_from_string 0.0))))))


;; ==============================================================================
;; 9. FINAL ISURP-OLD RESULTS (Normalized & Raw)
;; ==============================================================================

;; Case A: Normalization = TRUE
(exec (freq 110 result-normalized)
  (, (ISURP-REQUEST $id $pattern $support)
     (ISURP-NORMALIZATION $id TRUE)
     (ISURP-DISTANCE $id $dist)
     (ISURP-INTERVAL-EMAX $id $emax)
     (ISURP-EMP-PROB $id $emp))
  (O
    (pure
      (ISURP-RESULT $id $pattern normalized $result)
      $result
      (f64_to_string
        (min_f64
          (div_f64
            (f64_from_string $dist)
            (max_f64
              (f64_from_string $emax)
              (f64_from_string $emp)))
          (f64_from_string 1.0))))))

;; Case B: Normalization = FALSE (Raw mode)
(exec (freq 111 result-raw)
  (, (ISURP-REQUEST $id $pattern $support)
     (ISURP-NORMALIZATION $id FALSE)
     (ISURP-DISTANCE $id $dist))
  (O
    (pure
      (ISURP-RESULT $id $pattern raw $result)
      $result
      (f64_to_string
        (min_f64
          (f64_from_string $dist)
          (f64_from_string 1.0))))))

;; Public aliases
(exec (freq 120 public-isurp-old)
  (, (ISURP-RESULT $id $pattern $mode $result))
  (O (+ (isurp-old $pattern $result))))

(exec (freq 121 public-isurp-result-id)
  (, (ISURP-RESULT $id $pattern $mode $result))
  (O (+ (ISURP-RESULT $id $result))))
