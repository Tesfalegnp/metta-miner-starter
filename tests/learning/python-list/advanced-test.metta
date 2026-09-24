;; ================================================================
;; Python-list MM2/MORK Educational Tests: Advanced Operations
;; ================================================================

;; TEST-AUX src/learning/python-list/advanced.metta


;; Empty input
(LIST-REQUEST partition partition-empty ())
(EXPECTED-RESULT partition-empty (LIST-RESULT partition partition-empty (() ())))


;; Mixed input preserves order in both output lists
(LIST-FILTER-PREDICATE Alice keep)
(LIST-FILTER-PREDICATE Bob drop)
(LIST-FILTER-PREDICATE Carol keep)
(LIST-FILTER-PREDICATE Daniel drop)
(LIST-REQUEST partition partition-mixed (Alice Bob Carol Daniel))
(EXPECTED-RESULT partition-mixed (LIST-RESULT partition partition-mixed ((Alice Carol) (Bob Daniel))))


;; All items kept
(LIST-FILTER-PREDICATE Red keep)
(LIST-FILTER-PREDICATE Green keep)
(LIST-REQUEST partition partition-keep (Red Green))
(EXPECTED-RESULT partition-keep (LIST-RESULT partition partition-keep ((Red Green) ())))


;; All items dropped
(LIST-FILTER-PREDICATE Cyan drop)
(LIST-FILTER-PREDICATE Magenta drop)
(LIST-REQUEST partition partition-drop (Cyan Magenta))
(EXPECTED-RESULT partition-drop (LIST-RESULT partition partition-drop (() (Cyan Magenta))))


;; Repeated items are handled independently
(LIST-FILTER-PREDICATE A keep)
(LIST-FILTER-PREDICATE B drop)
(LIST-REQUEST partition partition-repeated (A B A B))
(EXPECTED-RESULT partition-repeated (LIST-RESULT partition partition-repeated ((A A) (B B))))