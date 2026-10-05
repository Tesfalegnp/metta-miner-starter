;; ==============================================================================
;; ISurp-Old MM2 Test: Raw Bounding Cases
;; Path: tests/isurp_old/test_raw.metta
;; ==============================================================================

;; TEST-AUX src/isurp_old.metta

;; ------------------------------------------------------------------------------
;; Test 01: Raw distance < 1.0
;; Distance: 0.35 -> Expected raw result: min(0.35, 1.0) = 0.35
;; ------------------------------------------------------------------------------

(RAW-BOUND-REQUEST raw-below-cap 0.35)
(EXPECTED-RESULT raw-below-cap (RAW-BOUND-RESULT raw-below-cap 0.35))

;; ------------------------------------------------------------------------------
;; Test 02: Raw distance >= 1.0
;; Distance: 1.5 -> Expected raw result: min(1.5, 1.0) = 1.0
;; ------------------------------------------------------------------------------

(RAW-BOUND-REQUEST raw-above-cap 1.5)
(EXPECTED-RESULT raw-above-cap (RAW-BOUND-RESULT raw-above-cap 1.0))
