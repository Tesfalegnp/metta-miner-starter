;; ================================================================
;; Python-list MM2/MORK Educational Module: Recursive Operations
;;
;; Implements recursive state machines using verified MM2 DEF template
;; definitions and dynamic rule instantiation:
;;   - count:  counts occurrences of target in a list
;;   - map:    transforms elements via (LIST-MAP-RULE $from $to)
;;   - filter: filters elements via (LIST-FILTER-PREDICATE $item keep|drop)
;; ================================================================


;; ================================================================
;; 11. COUNT OCCURRENCES
;; ================================================================

;; Empty list -> count is 0
(exec (freq 110 list-count-init-empty)
  (, (LIST-REQUEST count $id $target ()))
  (O
    (+ (LIST-RESULT count $id 0))
    (- (LIST-REQUEST count $id $target ()))))

;; Non-empty list -> initialize working state and start step
(exec (freq 111 list-count-init)
  (, (LIST-REQUEST count $id $target $list)
     (DEF list-count-step $step-p $step-t))
  (O
    (+ (list-count-work $id $target $list ()))
    (+ (exec (freq 112 list-count-step) $step-p $step-t))
    (- (LIST-REQUEST count $id $target $list))))

;; Decompose current list into head and tail
(DEF list-count-step
  (, (list-count-work $id $target $list $acc)
     (DEF list-count-match $m-p $m-t)
     (DEF list-count-nomatch $nm-p $nm-t))
  (O
    (pure (list-count-head $id $head) $head (car-atom (' $list)))
    (pure (list-count-tail $id $tail) $tail (cdr-atom (' $list)))
    (+ (list-count-curr $id $target $list $acc))
    (+ (exec (freq 113 list-count-match) $m-p $m-t))
    (+ (exec (freq 114 list-count-nomatch) $nm-p $nm-t))
    (- (list-count-work $id $target $list $acc))))

;; Match case: Head == Target, Tail == () -> finish with length of (cons $head acc)
(DEF list-count-match
  (, (list-count-curr $id $target $list $acc)
     (list-count-head $id $target)
     (list-count-tail $id ())
     (DEF list-count-finalize $fin-p $fin-t))
  (O
    (pure (list-count-final-acc $id $new-acc) $new-acc (cons $target (' $acc)))
    (+ (list-count-finalize $id))
    (+ (exec (freq 115 list-count-finalize) $fin-p $fin-t))
    (- (list-count-curr $id $target $list $acc))
    (- (list-count-head $id $target))
    (- (list-count-tail $id ()))))

(DEF list-count-finalize
  (, (list-count-finalize $id)
     (list-count-final-acc $id $new-acc))
  (O
    (pure (LIST-RESULT count $id $count) $count (length (' $new-acc)))
    (- (list-count-finalize $id))
    (- (list-count-final-acc $id $new-acc))))

;; Match case: Head == Target, Tail != () -> add to acc and recurse
(DEF list-count-match
  (, (list-count-curr $id $target $list $acc)
     (list-count-head $id $target)
     (list-count-tail $id $tail)
     (DEF list-count-resume $res-p $res-t))
  (O
    (pure (list-count-next-acc $id $new-acc) $new-acc (cons $target (' $acc)))
    (+ (list-count-resume-stage $id $target $tail))
    (+ (exec (freq 116 list-count-resume) $res-p $res-t))
    (- (list-count-curr $id $target $list $acc))
    (- (list-count-head $id $target))
    (- (list-count-tail $id $tail))))

(DEF list-count-resume
  (, (list-count-resume-stage $id $target $tail)
     (list-count-next-acc $id $new-acc)
     (DEF list-count-step $step-p $step-t))
  (O
    (+ (list-count-work $id $target $tail $new-acc))
    (+ (exec (freq 112 list-count-step) $step-p $step-t))
    (- (list-count-resume-stage $id $target $tail))
    (- (list-count-next-acc $id $new-acc))))

;; No-match terminal: Tail == () -> return length of acc directly
(DEF list-count-nomatch
  (, (list-count-curr $id $target $list $acc)
     (list-count-head $id $head)
     (list-count-tail $id ()))
  (O
    (pure (LIST-RESULT count $id $count) $count (length (' $acc)))
    (- (list-count-curr $id $target $list $acc))
    (- (list-count-head $id $head))
    (- (list-count-tail $id ()))))

;; No-match non-terminal: Tail != () -> continue with existing acc
(DEF list-count-nomatch
  (, (list-count-curr $id $target $list $acc)
     (list-count-head $id $head)
     (list-count-tail $id $tail)
     (DEF list-count-step $step-p $step-t))
  (O
    (+ (list-count-work $id $target $tail $acc))
    (+ (exec (freq 112 list-count-step) $step-p $step-t))
    (- (list-count-curr $id $target $list $acc))
    (- (list-count-head $id $head))
    (- (list-count-tail $id $tail))))


;; ================================================================
;; 12. MAP (Symbolic Rule Mapping)
;; ================================================================

;; Empty list -> ()
(exec (freq 120 list-map-init-empty)
  (, (LIST-REQUEST map $id ()))
  (O
    (+ (LIST-RESULT map $id ()))
    (- (LIST-REQUEST map $id ()))))

;; Non-empty list -> initialize and start step
(exec (freq 121 list-map-init)
  (, (LIST-REQUEST map $id $list)
     (DEF list-map-step $step-p $step-t))
  (O
    (+ (list-map-work $id $list ()))
    (+ (exec (freq 122 list-map-step) $step-p $step-t))
    (- (LIST-REQUEST map $id $list))))

(DEF list-map-step
  (, (list-map-work $id $list $acc)
     (DEF list-map-apply $apply-p $apply-t))
  (O
    (pure (list-map-head $id $list $acc $head) $head (car-atom (' $list)))
    (pure (list-map-tail $id $list $acc $tail) $tail (cdr-atom (' $list)))
    (+ (list-map-apply $id $list $acc))
    (+ (exec (freq 123 list-map-apply) $apply-p $apply-t))
    (- (list-map-work $id $list $acc))))

;; Terminal: tail is empty -> finish: map head, add to acc, reverse
(DEF list-map-apply
  (, (list-map-apply $id $list $acc)
     (list-map-head $id $list $acc $head)
     (list-map-tail $id $list $acc ())
     (LIST-MAP-RULE $head $mapped)
     (DEF list-map-finalize $fin-p $fin-t))
  (O
    (pure (list-map-final-acc $id $new-acc) $new-acc (cons $mapped (' $acc)))
    (+ (list-map-finalize $id))
    (+ (exec (freq 124 list-map-finalize) $fin-p $fin-t))
    (- (list-map-apply $id $list $acc))
    (- (list-map-head $id $list $acc $head))
    (- (list-map-tail $id $list $acc ()))))

(DEF list-map-finalize
  (, (list-map-finalize $id)
     (list-map-final-acc $id $new-acc))
  (O
    (pure (LIST-RESULT map $id $result) $result (reverse (' $new-acc)))
    (- (list-map-finalize $id))
    (- (list-map-final-acc $id $new-acc))))

;; Non-terminal: tail is not empty -> map head, add to acc, recurse
(DEF list-map-apply
  (, (list-map-apply $id $list $acc)
     (list-map-head $id $list $acc $head)
     (list-map-tail $id $list $acc $tail)
     (LIST-MAP-RULE $head $mapped)
     (DEF list-map-resume $res-p $res-t))
  (O
    (pure (list-map-next-acc $id $tail $new-acc) $new-acc (cons $mapped (' $acc)))
    (+ (list-map-resume-stage $id $tail))
    (+ (exec (freq 125 list-map-resume) $res-p $res-t))
    (- (list-map-apply $id $list $acc))
    (- (list-map-head $id $list $acc $head))
    (- (list-map-tail $id $list $acc $tail))))

(DEF list-map-resume
  (, (list-map-resume-stage $id $tail)
     (list-map-next-acc $id $tail $new-acc)
     (DEF list-map-step $step-p $step-t))
  (O
    (+ (list-map-work $id $tail $new-acc))
    (+ (exec (freq 122 list-map-step) $step-p $step-t))
    (- (list-map-resume-stage $id $tail))
    (- (list-map-next-acc $id $tail $new-acc))))


;; ================================================================
;; 13. FILTER (Symbolic Predicate Filtering)
;; ================================================================

;; Empty list -> ()
(exec (freq 130 list-filter-init-empty)
  (, (LIST-REQUEST filter $id ()))
  (O
    (+ (LIST-RESULT filter $id ()))
    (- (LIST-REQUEST filter $id ()))))

;; Non-empty list -> initialize and start step
(exec (freq 131 list-filter-init)
  (, (LIST-REQUEST filter $id $list)
     (DEF list-filter-step $step-p $step-t))
  (O
    (+ (list-filter-work $id $list ()))
    (+ (exec (freq 132 list-filter-step) $step-p $step-t))
    (- (LIST-REQUEST filter $id $list))))

(DEF list-filter-step
  (, (list-filter-work $id $list $acc)
     (DEF list-filter-decide $decide-p $decide-t))
  (O
    (pure (list-filter-head $id $list $acc $head) $head (car-atom (' $list)))
    (pure (list-filter-tail $id $list $acc $tail) $tail (cdr-atom (' $list)))
    (+ (list-filter-decide $id $list $acc))
    (+ (exec (freq 133 list-filter-decide) $decide-p $decide-t))
    (- (list-filter-work $id $list $acc))))

;; Keep item - tail is empty -> finish: add to acc, then reverse
(DEF list-filter-decide
  (, (list-filter-decide $id $list $acc)
     (list-filter-head $id $list $acc $head)
     (list-filter-tail $id $list $acc ())
     (LIST-FILTER-PREDICATE $head keep)
     (DEF list-filter-finalize $fin-p $fin-t))
  (O
    (pure (list-filter-final-acc $id $new-acc) $new-acc (cons $head (' $acc)))
    (+ (list-filter-finalize $id))
    (+ (exec (freq 134 list-filter-finalize) $fin-p $fin-t))
    (- (list-filter-decide $id $list $acc))
    (- (list-filter-head $id $list $acc $head))
    (- (list-filter-tail $id $list $acc ()))))

(DEF list-filter-finalize
  (, (list-filter-finalize $id)
     (list-filter-final-acc $id $new-acc))
  (O
    (pure (LIST-RESULT filter $id $result) $result (reverse (' $new-acc)))
    (- (list-filter-finalize $id))
    (- (list-filter-final-acc $id $new-acc))))

;; Drop item - tail is empty -> finish: reverse acc
(DEF list-filter-decide
  (, (list-filter-decide $id $list $acc)
     (list-filter-head $id $list $acc $head)
     (list-filter-tail $id $list $acc ())
     (LIST-FILTER-PREDICATE $head drop))
  (O
    (pure (LIST-RESULT filter $id $result) $result (reverse (' $acc)))
    (- (list-filter-decide $id $list $acc))
    (- (list-filter-head $id $list $acc $head))
    (- (list-filter-tail $id $list $acc ()))))

;; Keep item - tail is not empty -> recurse
(DEF list-filter-decide
  (, (list-filter-decide $id $list $acc)
     (list-filter-head $id $list $acc $head)
     (list-filter-tail $id $list $acc $tail)
     (LIST-FILTER-PREDICATE $head keep)
     (DEF list-filter-resume $res-p $res-t))
  (O
    (pure (list-filter-next-acc $id $tail $new-acc) $new-acc (cons $head (' $acc)))
    (+ (list-filter-resume-stage $id $tail))
    (+ (exec (freq 135 list-filter-resume) $res-p $res-t))
    (- (list-filter-decide $id $list $acc))
    (- (list-filter-head $id $list $acc $head))
    (- (list-filter-tail $id $list $acc $tail))))

(DEF list-filter-resume
  (, (list-filter-resume-stage $id $tail)
     (list-filter-next-acc $id $tail $new-acc)
     (DEF list-filter-step $step-p $step-t))
  (O
    (+ (list-filter-work $id $tail $new-acc))
    (+ (exec (freq 132 list-filter-step) $step-p $step-t))
    (- (list-filter-resume-stage $id $tail))
    (- (list-filter-next-acc $id $tail $new-acc))))

;; Drop item - tail is not empty -> recurse with existing acc
(DEF list-filter-decide
  (, (list-filter-decide $id $list $acc)
     (list-filter-head $id $list $acc $head)
     (list-filter-tail $id $list $acc $tail)
     (LIST-FILTER-PREDICATE $head drop)
     (DEF list-filter-step $step-p $step-t))
  (O
    (+ (list-filter-work $id $tail $acc))
    (+ (exec (freq 132 list-filter-step) $step-p $step-t))
    (- (list-filter-decide $id $list $acc))
    (- (list-filter-head $id $list $acc $head))
    (- (list-filter-tail $id $list $acc $tail))))
