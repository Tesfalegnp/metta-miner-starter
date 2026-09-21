;; ================================================================
;; Python-List Interactive Educational Demo in MM2 / MORK
;;
;; Run directly with:
;;     mork run src/learning/python-list/demo.metta
;; ================================================================

;; ----------------------------------------------------------------
;; 1. INPUT REQUESTS
;; ----------------------------------------------------------------

(LIST-REQUEST construct c1 (Alice Bob Carol))
(LIST-REQUEST empty e1 ())
(LIST-REQUEST empty e2 (Alice))
(LIST-REQUEST first f1 (Alice Bob Carol))
(LIST-REQUEST tail t1 (Alice Bob Carol))
(LIST-REQUEST length l1 (Alice Bob Carol Daniel))
(LIST-REQUEST member m1 Bob (Alice Bob Carol))
(LIST-REQUEST member m2 Daniel (Alice Bob Carol))
(LIST-REQUEST append a1 (Alice Bob) (Carol Daniel))
(LIST-REQUEST reverse r1 (Alice Bob Carol))
(LIST-REQUEST remove rm1 Alice (Alice Bob Alice Carol))
(LIST-REQUEST find fd1 1 (Alice Bob Carol))

;; Reasoning input
(PERSON Alice)
(LIKES Alice Coffee)
(PERSON Bob)
(LIKES Bob Tea)


;; ----------------------------------------------------------------
;; 2. MM2 EXECUTION RULES
;; ----------------------------------------------------------------

;; Construct
(exec (freq 010 list-construct)
  (, (LIST-REQUEST construct $id $list))
  (O (+ (LIST-RESULT construct $id $list))
     (- (LIST-REQUEST construct $id $list))))

;; Empty check
(exec (freq 020 list-empty-true)
  (, (LIST-REQUEST empty $id ()))
  (O (+ (LIST-RESULT empty $id true))
     (- (LIST-REQUEST empty $id ()))))

(exec (freq 021 list-empty-single)
  (, (LIST-REQUEST empty $id ($elem)))
  (O (+ (LIST-RESULT empty $id false))
     (- (LIST-REQUEST empty $id ($elem)))))

(exec (freq 022 list-empty-multi)
  (, (LIST-REQUEST empty $id ($head $elem2 $tail)))
  (O (+ (LIST-RESULT empty $id false))
     (- (LIST-REQUEST empty $id ($head $elem2 $tail)))))

;; First
(exec (freq 030 list-first)
  (, (LIST-REQUEST first $id $list))
  (O (pure (LIST-RESULT first $id $first) $first (car-atom (' $list)))
     (- (LIST-REQUEST first $id $list))))

;; Tail
(exec (freq 040 list-tail)
  (, (LIST-REQUEST tail $id $list))
  (O (pure (LIST-RESULT tail $id $tail) $tail (cdr-atom (' $list)))
     (- (LIST-REQUEST tail $id $list))))

;; Length
(exec (freq 050 list-length)
  (, (LIST-REQUEST length $id $list))
  (O (pure (LIST-RESULT length $id $len) $len (length (' $list)))
     (- (LIST-REQUEST length $id $list))))

;; Membership
(exec (freq 060 list-member)
  (, (LIST-REQUEST member $id $item $list))
  (O (pure (LIST-RESULT member $id $is-member) $is-member (is-member $item (' $list)))
     (- (LIST-REQUEST member $id $item $list))))

;; Append
(exec (freq 070 list-append)
  (, (LIST-REQUEST append $id $left $right))
  (O (pure (LIST-RESULT append $id $result) $result (append (' ($left $right))))
     (- (LIST-REQUEST append $id $left $right))))

;; Reverse
(exec (freq 080 list-reverse)
  (, (LIST-REQUEST reverse $id $list))
  (O (pure (LIST-RESULT reverse $id $result) $result (reverse (' $list)))
     (- (LIST-REQUEST reverse $id $list))))

;; Remove
(exec (freq 090 list-remove)
  (, (LIST-REQUEST remove $id $item $list))
  (O (pure (LIST-RESULT remove $id $result) $result (exclude-item $item (' $list)))
     (- (LIST-REQUEST remove $id $item $list))))

;; Find
(exec (freq 100 list-find)
  (, (LIST-REQUEST find $id $index $list))
  (O (pure (LIST-RESULT find $id $result) $result (index-atom $index (' $list)))
     (- (LIST-REQUEST find $id $index $list))))

;; Reasoning query
(exec (freq 160 reasoning-query)
  (, (PERSON $person)
     (LIKES $person Coffee))
  (O (+ (REASONING-RESULT $person))))
