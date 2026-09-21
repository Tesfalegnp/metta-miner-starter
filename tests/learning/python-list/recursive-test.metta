;; ================================================================
;; Python-list MM2/MORK Educational Tests: Recursive Operations
;; ================================================================

;; TEST-AUX src/learning/python-list/recursive.metta


;; ------------------------------------------------
;; Count occurrences
;; ------------------------------------------------

(LIST-REQUEST count cnt-1 Alice (Alice Bob Alice Carol Alice))
(EXPECTED-RESULT cnt-1 (LIST-RESULT count cnt-1 3))

(LIST-REQUEST count cnt-2 Daniel (Alice Bob Carol))
(EXPECTED-RESULT cnt-2 (LIST-RESULT count cnt-2 0))

(LIST-REQUEST count cnt-3 Alice ())
(EXPECTED-RESULT cnt-3 (LIST-RESULT count cnt-3 0))


;; ------------------------------------------------
;; Map (symbolic rules)
;; ------------------------------------------------

(LIST-MAP-RULE Alice Person-Alice)
(LIST-MAP-RULE Bob Person-Bob)
(LIST-MAP-RULE Carol Person-Carol)

(LIST-REQUEST map map-1 (Alice Bob Carol))
(EXPECTED-RESULT map-1 (LIST-RESULT map map-1 (Person-Alice Person-Bob Person-Carol)))

(LIST-REQUEST map map-empty ())
(EXPECTED-RESULT map-empty (LIST-RESULT map map-empty ()))


;; ------------------------------------------------
;; Filter (symbolic predicates)
;; ------------------------------------------------

(LIST-FILTER-PREDICATE Alice keep)
(LIST-FILTER-PREDICATE Bob drop)
(LIST-FILTER-PREDICATE Carol keep)

(LIST-REQUEST filter filter-1 (Alice Bob Carol))
(EXPECTED-RESULT filter-1 (LIST-RESULT filter filter-1 (Alice Carol)))

(LIST-REQUEST filter filter-empty ())
(EXPECTED-RESULT filter-empty (LIST-RESULT filter filter-empty ()))
