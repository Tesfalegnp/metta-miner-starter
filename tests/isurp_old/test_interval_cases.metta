;; ==============================================================================
;; ISurp-Old MM2 Test: Interval Distance Cases
;; Path: tests/isurp_old/test_interval_cases.metta
;; ==============================================================================

;; TEST-AUX src/isurp_old.metta

;; ------------------------------------------------------------------------------
;; Test 01: Empirical probability inside interval
;; Interval: [0.20, 0.50], Empirical: 0.30 -> Expected distance: 0.0
;; ------------------------------------------------------------------------------

(INTERVAL-DISTANCE-REQUEST interval-inside 0.20 0.50 0.30)
(EXPECTED-RESULT interval-inside (INTERVAL-DISTANCE-RESULT interval-inside 0.0))

;; ------------------------------------------------------------------------------
;; Test 02: Empirical probability above interval
;; Interval: [0.20, 0.50], Empirical: 0.70 -> Expected distance: 0.20
;; ------------------------------------------------------------------------------

(INTERVAL-DISTANCE-REQUEST interval-above 0.20 0.50 0.70)
(EXPECTED-RESULT interval-above (INTERVAL-DISTANCE-RESULT interval-above 0.19999999999999996))

;; ------------------------------------------------------------------------------
;; Test 03: Empirical probability below interval
;; Interval: [0.40, 0.70], Empirical: 0.10 -> Expected distance: 0.30
;; ------------------------------------------------------------------------------

(INTERVAL-DISTANCE-REQUEST interval-below 0.40 0.70 0.10)
(EXPECTED-RESULT interval-below (INTERVAL-DISTANCE-RESULT interval-below 0.30000000000000004))
