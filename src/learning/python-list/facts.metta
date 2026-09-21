;; ================================================================
;; Python-list MM2/MORK Educational Module: List to Facts & Queries
;;
;; Demonstrates decomposing symbolic list expressions into individual
;; AtomSpace facts, and querying those generated facts.
;;
;; Example:
;;     Input:  (LIST-REQUEST to-facts facts-1 (Alice Bob Carol))
;;     Emits:  (LIST-FACT facts-1 Alice)
;;             (LIST-FACT facts-1 Bob)
;;             (LIST-FACT facts-1 Carol)
;;             (LIST-RESULT to-facts facts-1 done)
;;
;; Query:
;;     Input:  (LIST-QUERY facts-1 Bob)
;;     Emits:  (LIST-QUERY-RESULT facts-1 Bob)
;; ================================================================

;; ----------------------------------------------------------------
;; 14. LIST -> FACTS
;; ----------------------------------------------------------------

;; Empty list -> done immediately
(exec (freq 140 list-to-facts-init-empty)
  (, (LIST-REQUEST to-facts $id ()))
  (O
    (+ (LIST-RESULT to-facts $id done))
    (- (LIST-REQUEST to-facts $id ()))))

;; Non-empty list -> initialize and start decomposition step
(exec (freq 141 list-to-facts-init)
  (, (LIST-REQUEST to-facts $id $list)
     (DEF list-to-facts-step $step-p $step-t))
  (O
    (+ (list-fact-work $id $list))
    (+ (exec (freq 142 list-to-facts-step) $step-p $step-t))
    (- (LIST-REQUEST to-facts $id $list))))

(DEF list-to-facts-step
  (, (list-fact-work $id $list)
     (DEF list-to-facts-emit $emit-p $emit-t))
  (O
    (pure (list-fact-head $id $list $head) $head (car-atom (' $list)))
    (pure (list-fact-tail $id $list $tail) $tail (cdr-atom (' $list)))
    (+ (list-fact-emit $id $list))
    (+ (exec (freq 143 list-to-facts-emit) $emit-p $emit-t))
    (- (list-fact-work $id $list))))

;; Terminal: Tail is empty () -> emit fact and finish
(DEF list-to-facts-emit
  (, (list-fact-emit $id $list)
     (list-fact-head $id $list $head)
     (list-fact-tail $id $list ()))
  (O
    (+ (LIST-FACT $id $head))
    (+ (LIST-RESULT to-facts $id done))
    (- (list-fact-emit $id $list))
    (- (list-fact-head $id $list $head))
    (- (list-fact-tail $id $list ()))))

;; Non-terminal: Tail is not empty -> emit fact and recurse with tail
(DEF list-to-facts-emit
  (, (list-fact-emit $id $list)
     (list-fact-head $id $list $head)
     (list-fact-tail $id $list $tail)
     (DEF list-to-facts-step $step-p $step-t))
  (O
    (+ (LIST-FACT $id $head))
    (+ (list-fact-work $id $tail))
    (+ (exec (freq 142 list-to-facts-step) $step-p $step-t))
    (- (list-fact-emit $id $list))
    (- (list-fact-head $id $list $head))
    (- (list-fact-tail $id $list $tail))))


;; ----------------------------------------------------------------
;; 15. QUERY GENERATED FACTS
;; ----------------------------------------------------------------

(exec (freq 150 list-fact-query)
  (, (LIST-QUERY $id $item)
     (LIST-FACT $id $item))
  (O
    (+ (LIST-QUERY-RESULT $id $item))))
