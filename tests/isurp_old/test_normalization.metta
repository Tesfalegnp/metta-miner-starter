;; ==============================================================================
;; ISurp-Old MM2 Test: Normalization Cases
;; Path: tests/isurp_old/test_normalization.metta
;; ==============================================================================

;; TEST-AUX src/isurp_old.metta

;; ------------------------------------------------------------------------------
;; Test 01: Standard normalization
;; Distance: 0.20, emax: 0.50, emp: 0.70 -> Denominator = max(0.50, 0.70) = 0.70
;; Normalized = 0.20 / 0.70 = 0.28571428571428575
;; ------------------------------------------------------------------------------

(NORMALIZATION-REQUEST norm-standard 0.20 0.50 0.70)
(EXPECTED-RESULT norm-standard (NORMALIZATION-RESULT norm-standard 0.28571428571428575))

;; ------------------------------------------------------------------------------
;; Test 02: Normalization capped at 1.0
;; Distance: 2.0, emax: 0.50, emp: 0.20 -> Denominator = max(0.50, 0.20) = 0.50
;; Ratio = 2.0 / 0.50 = 4.0 -> Capped at 1.0
;; ------------------------------------------------------------------------------

(NORMALIZATION-REQUEST norm-capped 2.0 0.50 0.20)
(EXPECTED-RESULT norm-capped (NORMALIZATION-RESULT norm-capped 1.0))
