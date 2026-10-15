;; =============================================================================
;; Comprehensive Test Suite for isurp-old.metta and isurp-old-helpers.metta
;; Path: mm2/isurp_old_conversion/test_suite.metta
;;
;; Uses the exact function names from src/isurp_old.metta and src/collect_metta-MM.metta
;; =============================================================================

;; TEST-AUX mm2/isurp_old_conversion/isurp-old-helpers.metta
;; TEST-AUX mm2/isurp_old_conversion/isurp-old.metta

;; -----------------------------------------------------------------------------
;; 1. Main Algorithm Tests: isurp-old (2-conjunct on Atomspace)
;; -----------------------------------------------------------------------------
;; Raw mode (bounded to 1.0)
(isurp-old  (, (Inheritance $a man) (Inheritance $a ugly)) &test-space False)
;; Expected: (0.1111111111111111)

;; Normalized mode
(isurp-old (, (Inheritance $b man) (Inheritance $b ugly)) &test-space True)
;; Expected: (0.3333333333333333)

;; -----------------------------------------------------------------------------
;; 2. Recursive Partition Evaluation: isurp-old_
;; -----------------------------------------------------------------------------
(isurp-old_ (((((Inheritance $m man))))) &test-space 4)
;; Expected: (0.5)

(isurp-old_ () &test-space 4)
;; Expected: ()

;; -----------------------------------------------------------------------------
;; 3. Extremum Utilities: max, min, min-max
;; -----------------------------------------------------------------------------
(max (4 2 8 1 5))
;; Expected: (8)

(min (4 2 8 1 5))
;; Expected: (1)

(min-max (4 2 8 1 5))
;; Expected: (1 8)

;; -----------------------------------------------------------------------------
;; 4. Math Utilities: //, cal_binomial, accumulator-x
;; -----------------------------------------------------------------------------
(// 5 2)
;; Expected: (2.5)

(cal_binomial 5 2)
;; Expected: (10)

(accumulator-x (2 3 4))
;; Expected: (24)

;; -----------------------------------------------------------------------------
;; 5. Database, Pattern & Probability Utilities
;; -----------------------------------------------------------------------------
(n_conjuncts_new (, A B C D))
;; Expected: (4)

(n_conjuncts_new (Inheritance $x man))
;; Expected: (1)

(db_size &test-space)
;; Expected: (3)

(total_counts (Item $x) &space)
;; Expected: (5)

(total_counts (, (Item $x) (Item $y)) &space)
;; Expected: (10)

(prob (Inheritance $x man) &test-space 4)
;; Expected: (0.5)

(blk-prob ((Inheritance $x man)) &test-space 4)
;; Expected: (0.5)

(iprob (((Inheritance $x man))) &test-space 4)
;; Expected: (0.5)

(iprob () &test-space 4)
;; Expected: (1)

;; -----------------------------------------------------------------------------
;; 6. Interval Distance Utility: dst_from_interval
;; -----------------------------------------------------------------------------
;; Above interval: 0.70 > 0.50 -> distance = 0.20
(dst_from_interval 0.2 0.5 0.7)
;; Expected: (0.19999999999999996)

;; Inside interval: 0.20 <= 0.30 <= 0.50 -> distance = 0.0
(dst_from_interval 0.2 0.5 0.3)
;; Expected: (0.0)

;; Below interval: 0.10 < 0.40 -> distance = 0.30
(dst_from_interval 0.4 0.7 0.1)
;; Expected: (0.30000000000000004)

;; -----------------------------------------------------------------------------
;; 7. Set & Partition Utilities
;; -----------------------------------------------------------------------------
(all-in (a b) (a b c))
;; Expected: (True)

(all-in (a d) (a b c))
;; Expected: (False)

(valid-subset (a b) (a b c))
;; Expected: (True)

(valid-subset () (a b))
;; Expected: (False)
