;; ================================================================
;; Python-list MM2/MORK Educational Tests (Integration Entry Point)
;; ================================================================

;; TEST-AUX src/learning/python-list/core.metta
;; TEST-AUX src/learning/python-list/basic.metta
;; TEST-AUX src/learning/python-list/recursive.metta
;; TEST-AUX src/learning/python-list/facts.metta
;; TEST-AUX src/learning/python-list/reasoning.metta


;; ------------------------------------------------
;; 1. Construction
;; ------------------------------------------------

(LIST-REQUEST construct construct-1 (Alice Bob Carol))
(EXPECTED-RESULT construct-1 (LIST-RESULT construct construct-1 (Alice Bob Carol)))


;; ------------------------------------------------
;; 2. Empty list
;; ------------------------------------------------

(LIST-REQUEST empty empty-1 ())
(EXPECTED-RESULT empty-1 (LIST-RESULT empty empty-1 true))

(LIST-REQUEST empty empty-2 (Alice))
(EXPECTED-RESULT empty-2 (LIST-RESULT empty empty-2 false))


;; ------------------------------------------------
;; 3. First
;; ------------------------------------------------

(LIST-REQUEST first first-1 (Alice Bob Carol))
(EXPECTED-RESULT first-1 (LIST-RESULT first first-1 Alice))


;; ------------------------------------------------
;; 4. Tail
;; ------------------------------------------------

(LIST-REQUEST tail tail-1 (Alice Bob Carol))
(EXPECTED-RESULT tail-1 (LIST-RESULT tail tail-1 (Bob Carol)))


;; ------------------------------------------------
;; 5. Length
;; ------------------------------------------------

(LIST-REQUEST length length-1 (Alice Bob Carol))
(EXPECTED-RESULT length-1 (LIST-RESULT length length-1 3))

(LIST-REQUEST length length-2 (Alice))
(EXPECTED-RESULT length-2 (LIST-RESULT length length-2 1))


;; ------------------------------------------------
;; 6. Membership
;; ------------------------------------------------

(LIST-REQUEST member member-1 Bob (Alice Bob Carol))
(EXPECTED-RESULT member-1 (LIST-RESULT member member-1 true))

(LIST-REQUEST member member-2 Daniel (Alice Bob Carol))
(EXPECTED-RESULT member-2 (LIST-RESULT member member-2 false))


;; ------------------------------------------------
;; 7. Append
;; ------------------------------------------------

(LIST-REQUEST append append-1 (Alice Bob) (Carol Daniel))
(EXPECTED-RESULT append-1 (LIST-RESULT append append-1 (Alice Bob Carol Daniel)))


;; ------------------------------------------------
;; 8. Reverse
;; ------------------------------------------------

(LIST-REQUEST reverse reverse-1 (Alice Bob Carol))
(EXPECTED-RESULT reverse-1 (LIST-RESULT reverse reverse-1 (Carol Bob Alice)))


;; ------------------------------------------------
;; 9. Remove
;; ------------------------------------------------

(LIST-REQUEST remove remove-1 Alice (Alice Bob Alice Carol))
(EXPECTED-RESULT remove-1 (LIST-RESULT remove remove-1 (Bob Carol)))


;; ------------------------------------------------
;; 10. Index / Find
;; ------------------------------------------------

(LIST-REQUEST find find-1 1 (Alice Bob Carol))
(EXPECTED-RESULT find-1 (LIST-RESULT find find-1 Bob))


;; ------------------------------------------------
;; 11. Count occurrences
;; ------------------------------------------------

(LIST-REQUEST count cnt-1 Alice (Alice Bob Alice Carol Alice))
(EXPECTED-RESULT cnt-1 (LIST-RESULT count cnt-1 3))


;; ------------------------------------------------
;; 12. Symbolic MAP
;; ------------------------------------------------

(LIST-MAP-RULE Alice Person-Alice)
(LIST-MAP-RULE Bob Person-Bob)
(LIST-MAP-RULE Carol Person-Carol)

(LIST-REQUEST map map-1 (Alice Bob Carol))
(EXPECTED-RESULT map-1 (LIST-RESULT map map-1 (Person-Alice Person-Bob Person-Carol)))


;; ------------------------------------------------
;; 13. Symbolic FILTER
;; ------------------------------------------------

(LIST-FILTER-PREDICATE Alice keep)
(LIST-FILTER-PREDICATE Bob drop)
(LIST-FILTER-PREDICATE Carol keep)

(LIST-REQUEST filter filter-1 (Alice Bob Carol))
(EXPECTED-RESULT filter-1 (LIST-RESULT filter filter-1 (Alice Carol)))


;; ------------------------------------------------
;; 14. List -> AtomSpace facts
;; ------------------------------------------------

(LIST-REQUEST to-facts facts-1 (Alice Bob Carol))

(EXPECTED-RESULT facts-1 (LIST-RESULT to-facts facts-1 done))
(EXPECTED-RESULT fact-alice (LIST-FACT facts-1 Alice))
(EXPECTED-RESULT fact-bob (LIST-FACT facts-1 Bob))
(EXPECTED-RESULT fact-carol (LIST-FACT facts-1 Carol))


;; ------------------------------------------------
;; 15. Query generated facts
;; ------------------------------------------------

(LIST-QUERY facts-1 Bob)
(EXPECTED-RESULT query-bob (LIST-QUERY-RESULT facts-1 Bob))


;; ------------------------------------------------
;; 16. AtomSpace reasoning
;; ------------------------------------------------

(PERSON Alice)
(LIKES Alice Coffee)

(EXPECTED-RESULT reasoning-alice (REASONING-RESULT Alice))