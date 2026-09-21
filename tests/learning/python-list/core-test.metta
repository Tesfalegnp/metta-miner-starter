;; ================================================================
;; Python-list MM2/MORK Educational Tests: Core
;; ================================================================

;; TEST-AUX src/learning/python-list/core.metta

;; ------------------------------------------------
;; Construction
;; ------------------------------------------------

(LIST-REQUEST construct construct-1 (Alice Bob Carol))
(EXPECTED-RESULT construct-1 (LIST-RESULT construct construct-1 (Alice Bob Carol)))
