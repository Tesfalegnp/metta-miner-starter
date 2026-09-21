;; ================================================================
;; Python-list MM2/MORK Educational Module: AtomSpace Reasoning
;;
;; Demonstrates pattern matching and relational rule derivation
;; over domain knowledge facts in the AtomSpace.
;;
;; Rule:
;;     If (PERSON $p) and (LIKES $p Coffee), derive (REASONING-RESULT $p).
;; ================================================================

;; 17. ATOMSPACE REASONING QUERY
(exec (freq 160 reasoning-query)
  (, (PERSON $person)
     (LIKES $person Coffee))
  (O
    (+ (REASONING-RESULT $person))))
