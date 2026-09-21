;; ================================================================
;; Python-list MM2/MORK Educational Module: Basic Operations
;;
;; Implements standard list operations using verified MM2 stdlib
;; primitives (car-atom, cdr-atom, length, is-member, append,
;; reverse, exclude-item, index-atom) and structural matching.
;; ================================================================

;; ----------------------------------------------------------------
;; 2. CHECK EMPTY
;; ----------------------------------------------------------------

;; Empty list () -> true
(exec (freq 020 list-empty-true)
  (, (LIST-REQUEST empty $id ()))
  (O
    (+ (LIST-RESULT empty $id true))
    (- (LIST-REQUEST empty $id ()))))

;; Single-element list -> false
(exec (freq 021 list-empty-single)
  (, (LIST-REQUEST empty $id ($elem)))
  (O
    (+ (LIST-RESULT empty $id false))
    (- (LIST-REQUEST empty $id ($elem)))))

;; Multi-element list -> false
(exec (freq 022 list-empty-multi)
  (, (LIST-REQUEST empty $id ($head $elem2 $tail)))
  (O
    (+ (LIST-RESULT empty $id false))
    (- (LIST-REQUEST empty $id ($head $elem2 $tail)))))


;; ----------------------------------------------------------------
;; 3. FIRST ELEMENT (car-atom)
;; ----------------------------------------------------------------

(exec (freq 030 list-first)
  (, (LIST-REQUEST first $id $list))
  (O
    (pure
      (LIST-RESULT first $id $first)
      $first
      (car-atom (' $list)))
    (- (LIST-REQUEST first $id $list))))


;; ----------------------------------------------------------------
;; 4. TAIL (cdr-atom)
;; ----------------------------------------------------------------

(exec (freq 040 list-tail)
  (, (LIST-REQUEST tail $id $list))
  (O
    (pure
      (LIST-RESULT tail $id $tail)
      $tail
      (cdr-atom (' $list)))
    (- (LIST-REQUEST tail $id $list))))


;; ----------------------------------------------------------------
;; 5. LENGTH (length)
;; ----------------------------------------------------------------

(exec (freq 050 list-length)
  (, (LIST-REQUEST length $id $list))
  (O
    (pure
      (LIST-RESULT length $id $len)
      $len
      (length (' $list)))
    (- (LIST-REQUEST length $id $list))))


;; ----------------------------------------------------------------
;; 6. MEMBERSHIP (is-member)
;; ----------------------------------------------------------------

(exec (freq 060 list-member)
  (, (LIST-REQUEST member $id $item $list))
  (O
    (pure
      (LIST-RESULT member $id $is-member)
      $is-member
      (is-member $item (' $list)))
    (- (LIST-REQUEST member $id $item $list))))


;; ----------------------------------------------------------------
;; 7. APPEND (append)
;; In MM2/MORK, binary list ops take a quoted pair: (' ($left $right))
;; ----------------------------------------------------------------

(exec (freq 070 list-append)
  (, (LIST-REQUEST append $id $left $right))
  (O
    (pure
      (LIST-RESULT append $id $result)
      $result
      (append (' ($left $right))))
    (- (LIST-REQUEST append $id $left $right))))


;; ----------------------------------------------------------------
;; 8. REVERSE (reverse)
;; ----------------------------------------------------------------

(exec (freq 080 list-reverse)
  (, (LIST-REQUEST reverse $id $list))
  (O
    (pure
      (LIST-RESULT reverse $id $result)
      $result
      (reverse (' $list)))
    (- (LIST-REQUEST reverse $id $list))))


;; ----------------------------------------------------------------
;; 9. REMOVE ALL OCCURRENCES (exclude-item)
;; ----------------------------------------------------------------

(exec (freq 090 list-remove)
  (, (LIST-REQUEST remove $id $item $list))
  (O
    (pure
      (LIST-RESULT remove $id $result)
      $result
      (exclude-item $item (' $list)))
    (- (LIST-REQUEST remove $id $item $list))))


;; ----------------------------------------------------------------
;; 10. INDEX / FIND (index-atom)
;; ----------------------------------------------------------------

(exec (freq 100 list-find)
  (, (LIST-REQUEST find $id $index $list))
  (O
    (pure
      (LIST-RESULT find $id $result)
      $result
      (index-atom $index (' $list)))
    (- (LIST-REQUEST find $id $index $list))))
