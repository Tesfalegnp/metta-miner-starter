;; ================================================================
;; Python-list MM2/MORK Educational Tests: AtomSpace Reasoning
;; ================================================================

;; TEST-AUX src/learning/python-list/reasoning.metta


;; ------------------------------------------------
;; AtomSpace reasoning
;; ------------------------------------------------

;; Alice matches rule: (PERSON Alice) and (LIKES Alice Coffee)
(PERSON Alice)
(LIKES Alice Coffee)

;; Bob does NOT match: (PERSON Bob) likes Tea, not Coffee
(PERSON Bob)
(LIKES Bob Tea)

(EXPECTED-RESULT reasoning-alice (REASONING-RESULT Alice))
