;; ================================================================
;; Python-list MM2/MORK Educational Module: Advanced Operations
;;
;; Partition a list into kept and dropped items using a recursive
;; state machine with two accumulators.
;; ================================================================

;; Empty list -> two empty result lists.
(exec (freq 170 list-partition-init-empty)
  (, (LIST-REQUEST partition $id ()))
  (O
    (+ (LIST-RESULT partition $id (() ())))
    (- (LIST-REQUEST partition $id ()))))

;; Non-empty list -> initialize both accumulators and start the step.
;; The two empty lists are the initial keep and drop accumulators.
(exec (freq 171 list-partition-init)
  (, (LIST-REQUEST partition $id $list)
     (DEF list-partition-step $step-p $step-t))
  (O
    (+ (list-partition-work $id $list () ()))
    (+ (exec (freq 172 list-partition-step) $step-p $step-t))
    (- (LIST-REQUEST partition $id $list))))

(DEF list-partition-step
  (, (list-partition-work $id $list $keep-acc $drop-acc)
     (DEF list-partition-decide $decide-p $decide-t))
  (O
    ;; Materialize the current head and tail before choosing a branch.
    (pure (list-partition-head $id $list $head) $head (car-atom (' $list)))
    (pure (list-partition-tail $id $list $tail) $tail (cdr-atom (' $list)))
    ;; Create a decision rule instance for this particular request.
    (+ (list-partition-decide $id $list $keep-acc $drop-acc))
    (+ (exec (freq 173 list-partition-decide) $decide-p $decide-t))
    (- (list-partition-work $id $list $keep-acc $drop-acc))))

;; Keep terminal item: add it and finalize both accumulators.
;; A terminal item has an empty tail, so no recursive step is needed.
(DEF list-partition-decide
  (, (list-partition-decide $id $list $keep-acc $drop-acc)
     (list-partition-head $id $list $head)
     (list-partition-tail $id $list ())
     (LIST-FILTER-PREDICATE $head keep)
    )
  (O
      (pure (list-partition-final-keep-acc $id $new-keep)
        $new-keep
        (cons $head (' $keep-acc)))
      ;; The drop accumulator is already complete in this branch.
      (+ (list-partition-final-drop-acc $id $drop-acc))
      (+ (list-partition-reverse $id))
    (- (list-partition-decide $id $list $keep-acc $drop-acc))
    (- (list-partition-head $id $list $head))
      (- (list-partition-tail $id $list ()))))

;; Drop terminal item: add it and finalize both accumulators.
;; This is the symmetric terminal case for an item marked `drop`.
(DEF list-partition-decide
  (, (list-partition-decide $id $list $keep-acc $drop-acc)
     (list-partition-head $id $list $head)
     (list-partition-tail $id $list ())
     (LIST-FILTER-PREDICATE $head drop)
    )
  (O
      (+ (list-partition-final-keep-acc $id $keep-acc))
      (pure (list-partition-final-drop-acc $id $new-drop)
        $new-drop
        (cons $head (' $drop-acc)))
      (+ (list-partition-reverse $id))
    (- (list-partition-decide $id $list $keep-acc $drop-acc))
    (- (list-partition-head $id $list $head))
      (- (list-partition-tail $id $list ()))))

;; Keep non-terminal item: recurse with the updated keep accumulator.
;; `pure` must materialize the new list before the resume state consumes it.
(DEF list-partition-decide
  (, (list-partition-decide $id $list $keep-acc $drop-acc)
     (list-partition-head $id $list $head)
     (list-partition-tail $id $list $tail)
     (LIST-FILTER-PREDICATE $head keep)
     (DEF list-partition-resume $resume-p $resume-t))
  (O
    (pure (list-partition-next-keep $id $tail $drop-acc $new-keep)
          $new-keep
          (cons $head (' $keep-acc)))
    (+ (list-partition-resume-stage $id $tail))
    (+ (exec (freq 176 list-partition-resume) $resume-p $resume-t))
    (- (list-partition-decide $id $list $keep-acc $drop-acc))
    (- (list-partition-head $id $list $head))
    (- (list-partition-tail $id $list $tail))))

;; Drop non-terminal item: recurse with the updated drop accumulator.
;; The keep accumulator stays unchanged while the drop accumulator grows.
(DEF list-partition-decide
  (, (list-partition-decide $id $list $keep-acc $drop-acc)
     (list-partition-head $id $list $head)
     (list-partition-tail $id $list $tail)
     (LIST-FILTER-PREDICATE $head drop)
     (DEF list-partition-resume $resume-p $resume-t))
  (O
    (pure (list-partition-next-drop $id $tail $keep-acc $new-drop)
          $new-drop
          (cons $head (' $drop-acc)))
    (+ (list-partition-resume-stage $id $tail))
    (+ (exec (freq 177 list-partition-resume) $resume-p $resume-t))
    (- (list-partition-decide $id $list $keep-acc $drop-acc))
    (- (list-partition-head $id $list $head))
    (- (list-partition-tail $id $list $tail))))

(DEF list-partition-resume
  (, (list-partition-resume-stage $id $tail)
     (list-partition-next-keep $id $tail $drop-acc $new-keep)
     (DEF list-partition-step $step-p $step-t))
  (O
    ;; Continue with the updated keep list and the old drop list.
    (+ (list-partition-work $id $tail $new-keep $drop-acc))
    (+ (exec (freq 172 list-partition-step) $step-p $step-t))
    (- (list-partition-resume-stage $id $tail))
    (- (list-partition-next-keep $id $tail $drop-acc $new-keep))))

(DEF list-partition-resume
  (, (list-partition-resume-stage $id $tail)
     (list-partition-next-drop $id $tail $keep-acc $new-drop)
     (DEF list-partition-step $step-p $step-t))
  (O
    ;; Continue with the old keep list and the updated drop list.
    (+ (list-partition-work $id $tail $keep-acc $new-drop))
    (+ (exec (freq 172 list-partition-step) $step-p $step-t))
    (- (list-partition-resume-stage $id $tail))
    (- (list-partition-next-drop $id $tail $keep-acc $new-drop))))

      ;; Accumulators are built by cons, so they are reversed before returning.
      ;; This restores the order from the original input list.
      (exec (freq 178 list-partition-reverse)
      (, (list-partition-reverse $id)
         (list-partition-final-keep-acc $id $raw-keep)
          (list-partition-final-drop-acc $id $raw-drop))
      (O
        (pure (list-partition-final-state $id $keep-result $drop-result)
          $keep-result
          (reverse (' $raw-keep)))
        (pure (list-partition-final-state-drop $id $drop-result)
          $drop-result
          (reverse (' $raw-drop)))
        (+ (list-partition-finish $id))
        (- (list-partition-reverse $id))
        (- (list-partition-final-keep-acc $id $raw-keep))
        (- (list-partition-final-drop-acc $id $raw-drop))))

(exec (freq 179 list-partition-finalize)
  (, (list-partition-finish $id)
     (list-partition-final-state $id $keep-result $drop-result)
     (list-partition-final-state-drop $id $drop-result))
  (O
    ;; Emit one result containing the keep list and the drop list.
    (+ (LIST-RESULT partition $id ($keep-result $drop-result)))
    (- (list-partition-final-state $id $keep-result $drop-result))
    (- (list-partition-final-state-drop $id $drop-result))))