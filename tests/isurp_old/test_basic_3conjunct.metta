;; ==============================================================================
;; ISurp-Old MM2 Test: Basic 3-Conjunct Deterministic Calculation
;; Path: tests/isurp_old/test_basic_3conjunct.metta
;;
;; Purpose:
;;   Deterministic end-to-end verification of the independent MM2 implementation
;;   of isurp-old for pattern (A B C) with database size 10 and support 2.
;; ==============================================================================

;; TEST-AUX src/isurp_old.metta

;; ------------------------------------------------------------------------------
;; Input configuration: Raw mode
;; ------------------------------------------------------------------------------

(ISURP-REQUEST basic-3conj-raw (A B C) 2)
(ISURP-DB-SIZE basic-3conj-raw 10)
(ISURP-NORMALIZATION basic-3conj-raw FALSE)

(ISURP-BLOCK-SUPPORT basic-3conj-raw (A) 5)
(ISURP-BLOCK-SUPPORT basic-3conj-raw (B) 4)
(ISURP-BLOCK-SUPPORT basic-3conj-raw (C) 3)
(ISURP-BLOCK-SUPPORT basic-3conj-raw (A B) 2)
(ISURP-BLOCK-SUPPORT basic-3conj-raw (A C) 1)
(ISURP-BLOCK-SUPPORT basic-3conj-raw (B C) 2)

;; ------------------------------------------------------------------------------
;; Input configuration: Normalized mode
;; ------------------------------------------------------------------------------

(ISURP-REQUEST basic-3conj-norm (A B C) 2)
(ISURP-DB-SIZE basic-3conj-norm 10)
(ISURP-NORMALIZATION basic-3conj-norm TRUE)

(ISURP-BLOCK-SUPPORT basic-3conj-norm (A) 5)
(ISURP-BLOCK-SUPPORT basic-3conj-norm (B) 4)
(ISURP-BLOCK-SUPPORT basic-3conj-norm (C) 3)
(ISURP-BLOCK-SUPPORT basic-3conj-norm (A B) 2)
(ISURP-BLOCK-SUPPORT basic-3conj-norm (A C) 1)
(ISURP-BLOCK-SUPPORT basic-3conj-norm (B C) 2)

;; ------------------------------------------------------------------------------
;; Expected Mathematical Assertions
;; ------------------------------------------------------------------------------

;; 1. Total count: C(10, 3) = 120
(EXPECTED-RESULT total-count (ISURP-TOTAL-COUNT basic-3conj-raw 120))

;; 2. Empirical pattern probability: 2 / 120 = 0.016666...
(EXPECTED-RESULT emp-prob (ISURP-EMP-PROB basic-3conj-raw 0.016666666666666666))

;; 3. Block probabilities (denominator = 120)
(EXPECTED-RESULT blk-prob-A  (ISURP-BLOCK-PROB basic-3conj-raw (A) 0.041666666666666664))
(EXPECTED-RESULT blk-prob-B  (ISURP-BLOCK-PROB basic-3conj-raw (B) 0.03333333333333333))
(EXPECTED-RESULT blk-prob-C  (ISURP-BLOCK-PROB basic-3conj-raw (C) 0.025))
(EXPECTED-RESULT blk-prob-AB (ISURP-BLOCK-PROB basic-3conj-raw (A B) 0.016666666666666666))
(EXPECTED-RESULT blk-prob-AC (ISURP-BLOCK-PROB basic-3conj-raw (A C) 0.008333333333333333))
(EXPECTED-RESULT blk-prob-BC (ISURP-BLOCK-PROB basic-3conj-raw (B C) 0.016666666666666666))

;; 4. Partition probabilities
;; P1 = P(A) * P(B C) = (5/120) * (2/120) = 0.000694444...
(EXPECTED-RESULT part-p1 (ISURP-PARTITION-PROB basic-3conj-raw p1 0.0006944444444444444))

;; P2 = P(A C) * P(B) = (1/120) * (4/120) = 0.000277777...
(EXPECTED-RESULT part-p2 (ISURP-PARTITION-PROB basic-3conj-raw p2 0.0002777777777777778))

;; P3 = P(A B) * P(C) = (2/120) * (3/120) = 0.000416666...
(EXPECTED-RESULT part-p3 (ISURP-PARTITION-PROB basic-3conj-raw p3 0.0004166666666666667))

;; P4 = P(A) * P(B) * P(C) = (5/120) * (4/120) * (3/120) = 0.000034722...
(EXPECTED-RESULT part-p4 (ISURP-PARTITION-PROB basic-3conj-raw p4 3.472222222222222e-5))

;; 5. Interval bounds: emin and emax
(EXPECTED-RESULT interval-emin (ISURP-INTERVAL-EMIN basic-3conj-raw 3.472222222222222e-5))
(EXPECTED-RESULT interval-emax (ISURP-INTERVAL-EMAX basic-3conj-raw 0.0006944444444444444))

;; 6. Distance: pattern_prob > emax -> pattern_prob - emax = 0.01597222...
(EXPECTED-RESULT distance (ISURP-DISTANCE basic-3conj-raw 0.01597222222222222))

;; 7. Raw result: min(distance, 1.0) = 0.01597222...
(EXPECTED-RESULT raw-final (ISURP-RESULT basic-3conj-raw (A B C) raw 0.01597222222222222))
(EXPECTED-RESULT raw-public (isurp-old (A B C) 0.01597222222222222))

;; 8. Normalized result: min(distance / max(emax, emp), 1.0) = 0.958333...
(EXPECTED-RESULT norm-final (ISURP-RESULT basic-3conj-norm (A B C) normalized 0.9583333333333333))
(EXPECTED-RESULT norm-public (isurp-old (A B C) 0.9583333333333333))
