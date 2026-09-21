;; ================================================================
;; Python-list MM2/MORK Educational Tests: Basic Operations
;; ================================================================

;; TEST-AUX src/learning/python-list/basic.metta


;; ------------------------------------------------
;; Empty list checks
;; ------------------------------------------------

(LIST-REQUEST empty empty-1 ())
(EXPECTED-RESULT empty-1 (LIST-RESULT empty empty-1 true))

(LIST-REQUEST empty empty-2 (Alice))
(EXPECTED-RESULT empty-2 (LIST-RESULT empty empty-2 false))

(LIST-REQUEST empty empty-3 (Alice Bob Carol))
(EXPECTED-RESULT empty-3 (LIST-RESULT empty empty-3 false))


;; ------------------------------------------------
;; First element (car-atom)
;; ------------------------------------------------

(LIST-REQUEST first first-1 (Alice Bob Carol))
(EXPECTED-RESULT first-1 (LIST-RESULT first first-1 Alice))

(LIST-REQUEST first nested-first (Alice (Likes Bob Coffee) Carol))
(EXPECTED-RESULT nested-first (LIST-RESULT first nested-first Alice))


;; ------------------------------------------------
;; Tail (cdr-atom)
;; ------------------------------------------------

(LIST-REQUEST tail tail-1 (Alice Bob Carol))
(EXPECTED-RESULT tail-1 (LIST-RESULT tail tail-1 (Bob Carol)))


;; ------------------------------------------------
;; Length
;; ------------------------------------------------

(LIST-REQUEST length length-1 (Alice Bob Carol))
(EXPECTED-RESULT length-1 (LIST-RESULT length length-1 3))

(LIST-REQUEST length length-2 (Alice))
(EXPECTED-RESULT length-2 (LIST-RESULT length length-2 1))

(LIST-REQUEST length length-3 ())
(EXPECTED-RESULT length-3 (LIST-RESULT length length-3 0))

(LIST-REQUEST length nested-length (Alice (Likes Bob Coffee) Carol))
(EXPECTED-RESULT nested-length (LIST-RESULT length nested-length 3))

(LIST-REQUEST length duplicate-length (Alice Bob Alice Carol Alice))
(EXPECTED-RESULT duplicate-length (LIST-RESULT length duplicate-length 5))


;; ------------------------------------------------
;; Membership (is-member)
;; ------------------------------------------------

(LIST-REQUEST member member-1 Bob (Alice Bob Carol))
(EXPECTED-RESULT member-1 (LIST-RESULT member member-1 true))

(LIST-REQUEST member member-2 Daniel (Alice Bob Carol))
(EXPECTED-RESULT member-2 (LIST-RESULT member member-2 false))

(LIST-REQUEST member duplicate-member Alice (Alice Bob Alice Carol Alice))
(EXPECTED-RESULT duplicate-member (LIST-RESULT member duplicate-member true))


;; ------------------------------------------------
;; Append
;; ------------------------------------------------

(LIST-REQUEST append append-1 (Alice Bob) (Carol Daniel))
(EXPECTED-RESULT append-1 (LIST-RESULT append append-1 (Alice Bob Carol Daniel)))

(LIST-REQUEST append append-empty-left () (Alice Bob))
(EXPECTED-RESULT append-empty-left (LIST-RESULT append append-empty-left (Alice Bob)))

(LIST-REQUEST append append-empty-right (Alice Bob) ())
(EXPECTED-RESULT append-empty-right (LIST-RESULT append append-empty-right (Alice Bob)))


;; ------------------------------------------------
;; Reverse
;; ------------------------------------------------

(LIST-REQUEST reverse reverse-1 (Alice Bob Carol))
(EXPECTED-RESULT reverse-1 (LIST-RESULT reverse reverse-1 (Carol Bob Alice)))


;; ------------------------------------------------
;; Remove all occurrences (exclude-item)
;; ------------------------------------------------

(LIST-REQUEST remove remove-1 Alice (Alice Bob Alice Carol))
(EXPECTED-RESULT remove-1 (LIST-RESULT remove remove-1 (Bob Carol)))


;; ------------------------------------------------
;; Index / Find (index-atom)
;; ------------------------------------------------

(LIST-REQUEST find find-0 0 (Alice Bob Carol))
(EXPECTED-RESULT find-0 (LIST-RESULT find find-0 Alice))

(LIST-REQUEST find find-1 1 (Alice Bob Carol))
(EXPECTED-RESULT find-1 (LIST-RESULT find find-1 Bob))

(LIST-REQUEST find find-2 2 (Alice Bob Carol))
(EXPECTED-RESULT find-2 (LIST-RESULT find find-2 Carol))
