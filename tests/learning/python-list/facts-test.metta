;; ================================================================
;; Python-list MM2/MORK Educational Tests: List to Facts & Queries
;; ================================================================

;; TEST-AUX src/learning/python-list/facts.metta


;; ------------------------------------------------
;; List -> AtomSpace facts
;; ------------------------------------------------

(LIST-REQUEST to-facts facts-1 (Alice Bob Carol))

(EXPECTED-RESULT facts-1 (LIST-RESULT to-facts facts-1 done))
(EXPECTED-RESULT fact-alice (LIST-FACT facts-1 Alice))
(EXPECTED-RESULT fact-bob (LIST-FACT facts-1 Bob))
(EXPECTED-RESULT fact-carol (LIST-FACT facts-1 Carol))


;; ------------------------------------------------
;; Empty list -> Facts
;; ------------------------------------------------

(LIST-REQUEST to-facts facts-empty ())
(EXPECTED-RESULT facts-empty (LIST-RESULT to-facts facts-empty done))


;; ------------------------------------------------
;; Query generated facts
;; ------------------------------------------------

(LIST-QUERY facts-1 Bob)
(EXPECTED-RESULT query-bob (LIST-QUERY-RESULT facts-1 Bob))
