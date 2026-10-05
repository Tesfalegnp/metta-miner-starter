;; ==============================================================================
;; ISurp-Old MM2 Test: Integration Suite (All Cases)
;; Path: tests/isurp_old/test_all.metta
;; ==============================================================================

;; TEST-AUX src/isurp_old.metta

;; ------------------------------------------------------------------------------
;; Part 1: Interval Distance Verification
;; ------------------------------------------------------------------------------

(INTERVAL-DISTANCE-REQUEST all-dist-inside 0.20 0.50 0.30)
(EXPECTED-RESULT all-dist-inside (INTERVAL-DISTANCE-RESULT all-dist-inside 0.0))

(INTERVAL-DISTANCE-REQUEST all-dist-above 0.20 0.50 0.70)
(EXPECTED-RESULT all-dist-above (INTERVAL-DISTANCE-RESULT all-dist-above 0.19999999999999996))

(INTERVAL-DISTANCE-REQUEST all-dist-below 0.40 0.70 0.10)
(EXPECTED-RESULT all-dist-below (INTERVAL-DISTANCE-RESULT all-dist-below 0.30000000000000004))

;; ------------------------------------------------------------------------------
;; Part 2: Normalization Verification
;; ------------------------------------------------------------------------------

(NORMALIZATION-REQUEST all-norm-std 0.20 0.50 0.70)
(EXPECTED-RESULT all-norm-std (NORMALIZATION-RESULT all-norm-std 0.28571428571428575))

(NORMALIZATION-REQUEST all-norm-cap 2.0 0.50 0.20)
(EXPECTED-RESULT all-norm-cap (NORMALIZATION-RESULT all-norm-cap 1.0))

;; ------------------------------------------------------------------------------
;; Part 3: Raw Bounding Verification
;; ------------------------------------------------------------------------------

(RAW-BOUND-REQUEST all-raw-std 0.35)
(EXPECTED-RESULT all-raw-std (RAW-BOUND-RESULT all-raw-std 0.35))

(RAW-BOUND-REQUEST all-raw-cap 1.5)
(EXPECTED-RESULT all-raw-cap (RAW-BOUND-RESULT all-raw-cap 1.0))

;; ------------------------------------------------------------------------------
;; Part 4: End-to-End 3-Conjunct ISurp-Old
;; ------------------------------------------------------------------------------

(ISURP-REQUEST all-e2e-raw (A B C) 2)
(ISURP-DB-SIZE all-e2e-raw 10)
(ISURP-NORMALIZATION all-e2e-raw FALSE)

(ISURP-BLOCK-SUPPORT all-e2e-raw (A) 5)
(ISURP-BLOCK-SUPPORT all-e2e-raw (B) 4)
(ISURP-BLOCK-SUPPORT all-e2e-raw (C) 3)
(ISURP-BLOCK-SUPPORT all-e2e-raw (A B) 2)
(ISURP-BLOCK-SUPPORT all-e2e-raw (A C) 1)
(ISURP-BLOCK-SUPPORT all-e2e-raw (B C) 2)

(EXPECTED-RESULT all-total-count (ISURP-TOTAL-COUNT all-e2e-raw 120))
(EXPECTED-RESULT all-emp-prob    (ISURP-EMP-PROB all-e2e-raw 0.016666666666666666))
(EXPECTED-RESULT all-emin        (ISURP-INTERVAL-EMIN all-e2e-raw 3.472222222222222e-5))
(EXPECTED-RESULT all-emax        (ISURP-INTERVAL-EMAX all-e2e-raw 0.0006944444444444444))
(EXPECTED-RESULT all-dist        (ISURP-DISTANCE all-e2e-raw 0.01597222222222222))
(EXPECTED-RESULT all-raw-res     (ISURP-RESULT all-e2e-raw (A B C) raw 0.01597222222222222))
(EXPECTED-RESULT all-raw-pub     (isurp-old (A B C) 0.01597222222222222))
