;; =============================================================================
;;      Converted isurp-old.metta ALGORITHM (MM2 / MORK)
;; ============================================================================

  ;; isurp-old_ with empty case
(exec (freq 047 isurp-old-sub-empty)
  (, (isurp-old_ () $db $total_count))
  (O
    (+ ())
    (- (isurp-old_ () $db $total_count))))

    ;; Single partition with 2 blocks (nested or direct)
(exec (freq 047 isurp-old-sub-1-two-blk-direct)
  (, (isurp-old_ (($b1 $b2)) $db $total_count))
  (O
    (+ (iprob ($b1 $b2) $db $total_count))
    (- (isurp-old_ (($b1 $b2)) $db $total_count))))

(exec (freq 047 isurp-old-sub-1-two-blk)
  (, (isurp-old_ ((($c1) ($c2))) $db $total_count))
  (O
    (+ (iprob (($c1) ($c2)) $db $total_count))
    (- (isurp-old_ ((($c1) ($c2))) $db $total_count))))

    ;; Single partition with single block: ($p1)
(exec (freq 048 isurp-old-sub-1-single)
  (, (isurp-old_ ($p1) $db $total_count))
  (O
    (+ (prob $p1 $db $total_count))
    (- (isurp-old_ ($p1) $db $total_count))))

      ;; Two partitions: ($p1 $p2)
(exec (freq 048 isurp-old-sub-2-start)
  (, (isurp-old_ ($p1 $p2) $db $total_count))
  (O
    (pure (isurp-sub2-ctx $ctx ($p1 $p2) $db $total_count) $ctx
      (vars_to_indices (' ($p1 $p2))))
    (- (isurp-old_ ($p1 $p2) $db $total_count))))

(exec (freq 049 isurp-old-sub-2-init)
  (, (isurp-sub2-ctx $ctx ($p1 $p2) $db $total_count))
  (O
    (+ (isurp-sub2-eval $ctx ($p1 $p2) $db $total_count))
    (+ (iprob-tagged $ctx 1 $p1 $db $total_count))
    (+ (iprob-tagged $ctx 2 $p2 $db $total_count))
    (- (isurp-sub2-ctx $ctx ($p1 $p2) $db $total_count))))

(exec (freq 054 isurp-old-sub-2-collect)
  (, (isurp-sub2-eval $ctx ($p1 $p2) $db $total_count)
     (iprob-tag-res $ctx 1 $r1)
     (iprob-tag-res $ctx 2 $r2))
  (O
    (+ (($r1 $r2)))
    (- (isurp-sub2-eval $ctx ($p1 $p2) $db $total_count))
    (- (iprob-tag-res $ctx 1 $r1))
    (- (iprob-tag-res $ctx 2 $r2))))

;; Three partitions: ($p1 $p2 $p3)
(exec (freq 048 isurp-old-sub-3-start)
  (, (isurp-old_ ($p1 $p2 $p3) $db $total_count))
  (O
    (pure (isurp-sub3-ctx $ctx ($p1 $p2 $p3) $db $total_count) $ctx
      (vars_to_indices (' ($p1 $p2 $p3))))
    (- (isurp-old_ ($p1 $p2 $p3) $db $total_count))))

(exec (freq 049 isurp-old-sub-3-init)
  (, (isurp-sub3-ctx $ctx ($p1 $p2 $p3) $db $total_count))
  (O
    (+ (isurp-sub3-eval $ctx ($p1 $p2 $p3) $db $total_count))
    (+ (iprob-tagged $ctx 1 $p1 $db $total_count))
    (+ (iprob-tagged $ctx 2 $p2 $db $total_count))
    (+ (iprob-tagged $ctx 3 $p3 $db $total_count))
    (- (isurp-sub3-ctx $ctx ($p1 $p2 $p3) $db $total_count))))

(exec (freq 054 isurp-old-sub-3-collect)
  (, (isurp-sub3-eval $ctx ($p1 $p2 $p3) $db $total_count)
     (iprob-tag-res $ctx 1 $r1)
     (iprob-tag-res $ctx 2 $r2)
     (iprob-tag-res $ctx 3 $r3))
  (O
    (+ (($r1 $r2 $r3)))
    (- (isurp-sub3-eval $ctx ($p1 $p2 $p3) $db $total_count))
    (- (iprob-tag-res $ctx 1 $r1))
    (- (iprob-tag-res $ctx 2 $r2))
    (- (iprob-tag-res $ctx 3 $r3))))

;; Four partitions: ($p1 $p2 $p3 $p4)
(exec (freq 048 isurp-old-sub-4-start)
  (, (isurp-old_ ($p1 $p2 $p3 $p4) $db $total_count))
  (O
    (pure (isurp-sub4-ctx $ctx ($p1 $p2 $p3 $p4) $db $total_count) $ctx
      (vars_to_indices (' ($p1 $p2 $p3 $p4))))
    (- (isurp-old_ ($p1 $p2 $p3 $p4) $db $total_count))))

(exec (freq 049 isurp-old-sub-4-init)
  (, (isurp-sub4-ctx $ctx ($p1 $p2 $p3 $p4) $db $total_count))
  (O
    (+ (isurp-sub4-eval $ctx ($p1 $p2 $p3 $p4) $db $total_count))
    (+ (iprob-tagged $ctx 1 $p1 $db $total_count))
    (+ (iprob-tagged $ctx 2 $p2 $db $total_count))
    (+ (iprob-tagged $ctx 3 $p3 $db $total_count))
    (+ (iprob-tagged $ctx 4 $p4 $db $total_count))
    (- (isurp-sub4-ctx $ctx ($p1 $p2 $p3 $p4) $db $total_count))))

(exec (freq 054 isurp-old-sub-4-collect)
  (, (isurp-sub4-eval $ctx ($p1 $p2 $p3 $p4) $db $total_count)
     (iprob-tag-res $ctx 1 $r1)
     (iprob-tag-res $ctx 2 $r2)
     (iprob-tag-res $ctx 3 $r3)
     (iprob-tag-res $ctx 4 $r4))
  (O
    (+ (($r1 $r2 $r3 $r4)))
    (- (isurp-sub4-eval $ctx ($p1 $p2 $p3 $p4) $db $total_count))
    (- (iprob-tag-res $ctx 1 $r1))
    (- (iprob-tag-res $ctx 2 $r2))
    (- (iprob-tag-res $ctx 3 $r3))
    (- (iprob-tag-res $ctx 4 $r4))))

;; --- Tagged partition evaluation rules for isurp-old_ ---
;; 1-block partition: ($b1)
(exec (freq 051 iprob-tag-1blk)
  (, (iprob-tagged $ctx $tag ($b1) $db $total_count))
  (O
    (+ (ipt-eval-1 $ctx $tag $db $b1 $total_count))
    (+ (ipt-cnt-1 $ctx $tag 0))
    (- (iprob-tagged $ctx $tag ($b1) $db $total_count))))

(exec (freq 052 ipt-cnt-1-run)
  (, (ipt-eval-1 $ctx $tag $db $b1 $total_count)
     ($db $b1)
     (ipt-cnt-1 $ctx $tag 0))
  (O
    (count (ipt-cnt-1 $ctx $tag $k) $k $b1)
    (- (ipt-cnt-1 $ctx $tag 0))))

(exec (freq 053 ipt-finish-1)
  (, (ipt-eval-1 $ctx $tag $db $b1 $total_count)
     (ipt-cnt-1 $ctx $tag $k))
  (O
    (pure (iprob-tag-res $ctx $tag $res) $res
      (f64_to_string
        (div_f64 (f64_from_string $k) (f64_from_string $total_count))))
    (- (ipt-eval-1 $ctx $tag $db $b1 $total_count))
    (- (ipt-cnt-1 $ctx $tag $k))))

;; 2-block partition: ($b1 $b2)
(exec (freq 051 iprob-tag-2blk)
  (, (iprob-tagged $ctx $tag ($b1 $b2) $db $total_count))
  (O
    (+ (ipt-eval-2 $ctx $tag $db $b1 $b2 $total_count))
    (+ (ipt-cnt-2-1 $ctx $tag 0))
    (+ (ipt-cnt-2-2 $ctx $tag 0))
    (- (iprob-tagged $ctx $tag ($b1 $b2) $db $total_count))))

(exec (freq 052 ipt-cnt-2-run-1)
  (, (ipt-eval-2 $ctx $tag $db $b1 $b2 $total_count)
     ($db $b1)
     (ipt-cnt-2-1 $ctx $tag 0))
  (O
    (count (ipt-cnt-2-1 $ctx $tag $k1) $k1 $b1)
    (- (ipt-cnt-2-1 $ctx $tag 0))))

(exec (freq 052 ipt-cnt-2-run-2)
  (, (ipt-eval-2 $ctx $tag $db $b1 $b2 $total_count)
     ($db $b2)
     (ipt-cnt-2-2 $ctx $tag 0))
  (O
    (count (ipt-cnt-2-2 $ctx $tag $k2) $k2 $b2)
    (- (ipt-cnt-2-2 $ctx $tag 0))))

(exec (freq 053 ipt-finish-2)
  (, (ipt-eval-2 $ctx $tag $db $b1 $b2 $total_count)
     (ipt-cnt-2-1 $ctx $tag $k1)
     (ipt-cnt-2-2 $ctx $tag $k2))
  (O
    (pure (iprob-tag-res $ctx $tag $res) $res
      (f64_to_string
        (product_f64
          (div_f64 (f64_from_string $k1) (f64_from_string $total_count))
          (div_f64 (f64_from_string $k2) (f64_from_string $total_count)))))
    (- (ipt-eval-2 $ctx $tag $db $b1 $b2 $total_count))
    (- (ipt-cnt-2-1 $ctx $tag $k1))
    (- (ipt-cnt-2-2 $ctx $tag $k2))))

;; 3-block partition: ($b1 $b2 $b3)
(exec (freq 051 iprob-tag-3blk)
  (, (iprob-tagged $ctx $tag ($b1 $b2 $b3) $db $total_count))
  (O
    (+ (ipt-eval-3 $ctx $tag $db $b1 $b2 $b3 $total_count))
    (+ (ipt-cnt-3-1 $ctx $tag 0))
    (+ (ipt-cnt-3-2 $ctx $tag 0))
    (+ (ipt-cnt-3-3 $ctx $tag 0))
    (- (iprob-tagged $ctx $tag ($b1 $b2 $b3) $db $total_count))))

(exec (freq 052 ipt-cnt-3-run-1)
  (, (ipt-eval-3 $ctx $tag $db $b1 $b2 $b3 $total_count)
     ($db $b1)
     (ipt-cnt-3-1 $ctx $tag 0))
  (O
    (count (ipt-cnt-3-1 $ctx $tag $k1) $k1 $b1)
    (- (ipt-cnt-3-1 $ctx $tag 0))))

(exec (freq 052 ipt-cnt-3-run-2)
  (, (ipt-eval-3 $ctx $tag $db $b1 $b2 $b3 $total_count)
     ($db $b2)
     (ipt-cnt-3-2 $ctx $tag 0))
  (O
    (count (ipt-cnt-3-2 $ctx $tag $k2) $k2 $b2)
    (- (ipt-cnt-3-2 $ctx $tag 0))))

(exec (freq 052 ipt-cnt-3-run-3)
  (, (ipt-eval-3 $ctx $tag $db $b1 $b2 $b3 $total_count)
     ($db $b3)
     (ipt-cnt-3-3 $ctx $tag 0))
  (O
    (count (ipt-cnt-3-3 $ctx $tag $k3) $k3 $b3)
    (- (ipt-cnt-3-3 $ctx $tag 0))))

(exec (freq 053 ipt-finish-3)
  (, (ipt-eval-3 $ctx $tag $db $b1 $b2 $b3 $total_count)
     (ipt-cnt-3-1 $ctx $tag $k1)
     (ipt-cnt-3-2 $ctx $tag $k2)
     (ipt-cnt-3-3 $ctx $tag $k3))
  (O
    (pure (iprob-tag-res $ctx $tag $res) $res
      (f64_to_string
        (product_f64
          (product_f64
            (div_f64 (f64_from_string $k1) (f64_from_string $total_count))
            (div_f64 (f64_from_string $k2) (f64_from_string $total_count)))
          (div_f64 (f64_from_string $k3) (f64_from_string $total_count)))))
    (- (ipt-eval-3 $ctx $tag $db $b1 $b2 $b3 $total_count))
    (- (ipt-cnt-3-1 $ctx $tag $k1))
    (- (ipt-cnt-3-2 $ctx $tag $k2))
    (- (ipt-cnt-3-3 $ctx $tag $k3))))



;; =============================================================================
;; 2. MAIN FUNCTION: isurp-old (2-Conjunct Pattern)
;; =============================================================================
;; Input: (, $c1 $c2)
;; Generated partition: ((($c1) ($c2)))
;; Interval bounds: emin = emax = P(c1) * P(c2)
;; =============================================================================

(exec (freq 080 isurp-start-2)
  (, (isurp-old (, $c1 $c2) $db $norm))
  (O
    (pure (isurp2-init $ctx (, $c1 $c2) $db $norm) $ctx
      (vars_to_indices (' (, $c1 $c2))))
    (- (isurp-old (, $c1 $c2) $db $norm))))

(exec (freq 081 isurp-init-2-b)
  (, (isurp2-init $ctx (, $c1 $c2) $db $norm))
  (O
    (+ (isurp2-eval $ctx ($c1 $c2) $db $norm))
    (+ (isurp2-cnt-total $ctx $norm 0))
    (+ (isurp2-cnt-j $ctx $norm 0))
    (+ (isurp2-cnt-1 $ctx $norm 0))
    (+ (isurp2-cnt-2 $ctx $norm 0))
    (- (isurp2-init $ctx (, $c1 $c2) $db $norm))))

(exec (freq 082 isurp2-cnt-db)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $atom)
     (isurp2-cnt-total $ctx $norm 0))
  (O
    (count (isurp2-cnt-total $ctx $norm $n) $n $atom)
    (- (isurp2-cnt-total $ctx $norm 0))))

(exec (freq 082 isurp2-cnt-joint)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $c1)
     ($db $c2)
     (isurp2-cnt-j $ctx $norm 0))
  (O
    (count (isurp2-cnt-j $ctx $norm $j) $j ($c1 $c2))
    (- (isurp2-cnt-j $ctx $norm 0))))

(exec (freq 082 isurp2-cnt-one)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $c1)
     (isurp2-cnt-1 $ctx $norm 0))
  (O
    (count (isurp2-cnt-1 $ctx $norm $k1) $k1 $c1)
    (- (isurp2-cnt-1 $ctx $norm 0))))

(exec (freq 082 isurp2-cnt-two)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $c2)
     (isurp2-cnt-2 $ctx $norm 0))
  (O
    (count (isurp2-cnt-2 $ctx $norm $k2) $k2 $c2)
    (- (isurp2-cnt-2 $ctx $norm 0))))

(exec (freq 083 isurp2-calc)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     (isurp2-cnt-total $ctx $norm $n)
     (isurp2-cnt-j $ctx $norm $j)
     (isurp2-cnt-1 $ctx $norm $k1)
     (isurp2-cnt-2 $ctx $norm $k2))
  (O
    (pure (isurp2-p-joint $ctx $norm $ppat) $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (f64_from_string
            (i64_to_string
              (div_i64
                (falling_factorial (i64_from_string $n) (i64_from_string 2))
                (factorial (i64_from_string 2))))))))
    (pure (isurp2-p-indep $ctx $norm $pindep) $pindep
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k1)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 2))
                  (factorial (i64_from_string 2))))))
          (div_f64
            (f64_from_string $k2)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 2))
                  (factorial (i64_from_string 2)))))))))
    (- (isurp2-eval $ctx ($c1 $c2) $db $norm))
    (- (isurp2-cnt-total $ctx $norm $n))
    (- (isurp2-cnt-j $ctx $norm $j))
    (- (isurp2-cnt-1 $ctx $norm $k1))
    (- (isurp2-cnt-2 $ctx $norm $k2))))

(exec (freq 084 isurp2-emit-false)
  (, (isurp2-p-joint $ctx False $ppat)
     (isurp2-p-indep $ctx False $pindep))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $pindep)
                (f64_from_string $pindep))))
          (f64_from_string 1.0))))
    (- (isurp2-p-joint $ctx False $ppat))
    (- (isurp2-p-indep $ctx False $pindep))))

(exec (freq 084 isurp2-emit-true)
  (, (isurp2-p-joint $ctx True $ppat)
     (isurp2-p-indep $ctx True $pindep))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $pindep)
                  (f64_from_string $pindep))))
            (max_f64 (f64_from_string $pindep) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp2-p-joint $ctx True $ppat))
    (- (isurp2-p-indep $ctx True $pindep))))


;; =============================================================================
;; 3. MAIN FUNCTION: isurp-old (3-Conjunct Pattern)
;; =============================================================================
;; Input: (, $c1 $c2 $c3)
;; Generates 4 partitions:
;;   P1: (($c1 $c2) ($c3))   -> P(c1 c2) * P(c3)
;;   P2: (($c1 $c3) ($c2))   -> P(c1 c3) * P(c2)
;;   P3: (($c1) ($c2 $c3))   -> P(c1) * P(c2 c3)
;;   P4: (($c1) ($c2) ($c3)) -> P(c1) * P(c2) * P(c3)
;; Total counts: binom(db_size, 3)
;; Interval bounds: emin = min(P1..P4), emax = max(P1..P4)
;; Distance: dst_from_interval emin emax pattern_prob
;; =============================================================================

(exec (freq 080 isurp-start-3)
  (, (isurp-old (, $c1 $c2 $c3) $db $norm))
  (O
    (pure (isurp3-init $ctx (, $c1 $c2 $c3) $db $norm) $ctx
      (vars_to_indices (' (, $c1 $c2 $c3))))
    (- (isurp-old (, $c1 $c2 $c3) $db $norm))))

(exec (freq 081 isurp-init-3-b)
  (, (isurp3-init $ctx (, $c1 $c2 $c3) $db $norm))
  (O
    (+ (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm))
    (+ (isurp3-cnt-total $ctx $norm 0))
    (+ (isurp3-cnt-j $ctx $norm 0))
    (+ (isurp3-cnt-1 $ctx $norm 0))
    (+ (isurp3-cnt-2 $ctx $norm 0))
    (+ (isurp3-cnt-3 $ctx $norm 0))
    (+ (isurp3-cnt-12 $ctx $norm 0))
    (+ (isurp3-cnt-13 $ctx $norm 0))
    (+ (isurp3-cnt-23 $ctx $norm 0))
    (- (isurp3-init $ctx (, $c1 $c2 $c3) $db $norm))))

(exec (freq 082 isurp3-cnt-total)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $atom)
     (isurp3-cnt-total $ctx $norm 0))
  (O
    (count (isurp3-cnt-total $ctx $norm $n) $n $atom)
    (- (isurp3-cnt-total $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-j)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     ($db $c2)
     ($db $c3)
     (isurp3-cnt-j $ctx $norm 0))
  (O
    (count (isurp3-cnt-j $ctx $norm $j) $j ($c1 $c2 $c3))
    (- (isurp3-cnt-j $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-1)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     (isurp3-cnt-1 $ctx $norm 0))
  (O
    (count (isurp3-cnt-1 $ctx $norm $k1) $k1 $c1)
    (- (isurp3-cnt-1 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-2)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c2)
     (isurp3-cnt-2 $ctx $norm 0))
  (O
    (count (isurp3-cnt-2 $ctx $norm $k2) $k2 $c2)
    (- (isurp3-cnt-2 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-3)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c3)
     (isurp3-cnt-3 $ctx $norm 0))
  (O
    (count (isurp3-cnt-3 $ctx $norm $k3) $k3 $c3)
    (- (isurp3-cnt-3 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-12)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     ($db $c2)
     (isurp3-cnt-12 $ctx $norm 0))
  (O
    (count (isurp3-cnt-12 $ctx $norm $k12) $k12 ($c1 $c2))
    (- (isurp3-cnt-12 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-13)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     ($db $c3)
     (isurp3-cnt-13 $ctx $norm 0))
  (O
    (count (isurp3-cnt-13 $ctx $norm $k13) $k13 ($c1 $c3))
    (- (isurp3-cnt-13 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-23)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c2)
     ($db $c3)
     (isurp3-cnt-23 $ctx $norm 0))
  (O
    (count (isurp3-cnt-23 $ctx $norm $k23) $k23 ($c2 $c3))
    (- (isurp3-cnt-23 $ctx $norm 0))))

(exec (freq 083 isurp3-calc)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     (isurp3-cnt-total $ctx $norm $n)
     (isurp3-cnt-j $ctx $norm $j)
     (isurp3-cnt-1 $ctx $norm $k1)
     (isurp3-cnt-2 $ctx $norm $k2)
     (isurp3-cnt-3 $ctx $norm $k3)
     (isurp3-cnt-12 $ctx $norm $k12)
     (isurp3-cnt-13 $ctx $norm $k13)
     (isurp3-cnt-23 $ctx $norm $k23))
  (O
    (pure (isurp3-pj $ctx $norm $ppat) $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (f64_from_string
            (i64_to_string
              (div_i64
                (falling_factorial (i64_from_string $n) (i64_from_string 3))
                (factorial (i64_from_string 3))))))))
    (pure (isurp3-p1 $ctx $norm $p1) $p1
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k12)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3))))))
          (div_f64
            (f64_from_string $k3)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (pure (isurp3-p2 $ctx $norm $p2) $p2
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k13)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3))))))
          (div_f64
            (f64_from_string $k2)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (pure (isurp3-p3 $ctx $norm $p3) $p3
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k1)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3))))))
          (div_f64
            (f64_from_string $k23)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (pure (isurp3-p4 $ctx $norm $p4) $p4
      (f64_to_string
        (product_f64
          (product_f64
            (div_f64
              (f64_from_string $k1)
              (f64_from_string
                (i64_to_string
                  (div_i64
                    (falling_factorial (i64_from_string $n) (i64_from_string 3))
                    (factorial (i64_from_string 3))))))
            (div_f64
              (f64_from_string $k2)
              (f64_from_string
                (i64_to_string
                  (div_i64
                    (falling_factorial (i64_from_string $n) (i64_from_string 3))
                    (factorial (i64_from_string 3)))))))
          (div_f64
            (f64_from_string $k3)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (- (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm))
    (- (isurp3-cnt-total $ctx $norm $n))
    (- (isurp3-cnt-j $ctx $norm $j))
    (- (isurp3-cnt-1 $ctx $norm $k1))
    (- (isurp3-cnt-2 $ctx $norm $k2))
    (- (isurp3-cnt-3 $ctx $norm $k3))
    (- (isurp3-cnt-12 $ctx $norm $k12))
    (- (isurp3-cnt-13 $ctx $norm $k13))
    (- (isurp3-cnt-23 $ctx $norm $k23))))

(exec (freq 084 isurp3-minmax)
  (, (isurp3-pj $ctx $norm $ppat)
     (isurp3-p1 $ctx $norm $p1)
     (isurp3-p2 $ctx $norm $p2)
     (isurp3-p3 $ctx $norm $p3)
     (isurp3-p4 $ctx $norm $p4))
  (O
    (pure (isurp3-emin $ctx $norm $emin) $emin (min-atom (' ($p1 $p2 $p3 $p4))))
    (pure (isurp3-emax $ctx $norm $emax) $emax (max-atom (' ($p1 $p2 $p3 $p4))))
    (- (isurp3-p1 $ctx $norm $p1))
    (- (isurp3-p2 $ctx $norm $p2))
    (- (isurp3-p3 $ctx $norm $p3))
    (- (isurp3-p4 $ctx $norm $p4))))

(exec (freq 085 isurp3-emit-raw)
  (, (isurp3-pj $ctx False $ppat)
     (isurp3-emin $ctx False $emin)
     (isurp3-emax $ctx False $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $emin)
                (f64_from_string $emax))))
          (f64_from_string 1.0))))
    (- (isurp3-pj $ctx False $ppat))
    (- (isurp3-emin $ctx False $emin))
    (- (isurp3-emax $ctx False $emax))))

(exec (freq 085 isurp3-emit-norm)
  (, (isurp3-pj $ctx True $ppat)
     (isurp3-emin $ctx True $emin)
     (isurp3-emax $ctx True $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $emin)
                  (f64_from_string $emax))))
            (max_f64 (f64_from_string $emax) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp3-pj $ctx True $ppat))
    (- (isurp3-emin $ctx True $emin))
    (- (isurp3-emax $ctx True $emax))))


;; =============================================================================
;; 4. MAIN FUNCTION: isurp-old (4-Conjunct Pattern)
;; =============================================================================
;; Input: (, $c1 $c2 $c3 $c4)
;; Generates 14 partitions across 4 subsets:
;;   - 4 partitions of type 3+1
;;   - 3 partitions of type 2+2
;;   - 6 partitions of type 2+1+1
;;   - 1 partition of type 1+1+1+1
;; Total count: binom(db_size, 4)
;; =============================================================================

(exec (freq 080 isurp-start-4)
  (, (isurp-old (, $c1 $c2 $c3 $c4) $db $norm))
  (O
    (pure (isurp4-init $ctx (, $c1 $c2 $c3 $c4) $db $norm) $ctx
      (vars_to_indices (' (, $c1 $c2 $c3 $c4))))
    (- (isurp-old (, $c1 $c2 $c3 $c4) $db $norm))))

(exec (freq 081 isurp-init-4-b)
  (, (isurp4-init $ctx (, $c1 $c2 $c3 $c4) $db $norm))
  (O
    (+ (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm))
    (+ (isurp4-cnt-total $ctx $norm 0))
    (+ (isurp4-cnt-j $ctx $norm 0))
    (+ (isurp4-cnt-1 $ctx $norm 0))
    (+ (isurp4-cnt-2 $ctx $norm 0))
    (+ (isurp4-cnt-3 $ctx $norm 0))
    (+ (isurp4-cnt-4 $ctx $norm 0))
    (+ (isurp4-cnt-12 $ctx $norm 0))
    (+ (isurp4-cnt-13 $ctx $norm 0))
    (+ (isurp4-cnt-14 $ctx $norm 0))
    (+ (isurp4-cnt-23 $ctx $norm 0))
    (+ (isurp4-cnt-24 $ctx $norm 0))
    (+ (isurp4-cnt-34 $ctx $norm 0))
    (+ (isurp4-cnt-123 $ctx $norm 0))
    (+ (isurp4-cnt-124 $ctx $norm 0))
    (+ (isurp4-cnt-134 $ctx $norm 0))
    (+ (isurp4-cnt-234 $ctx $norm 0))
    (- (isurp4-init $ctx (, $c1 $c2 $c3 $c4) $db $norm))))

(exec (freq 082 isurp4-cnt-total)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $atom)
     (isurp4-cnt-total $ctx $norm 0))
  (O
    (count (isurp4-cnt-total $ctx $norm $n) $n $atom)
    (- (isurp4-cnt-total $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-j)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) ($db $c3) ($db $c4)
     (isurp4-cnt-j $ctx $norm 0))
  (O
    (count (isurp4-cnt-j $ctx $norm $j) $j ($c1 $c2 $c3 $c4))
    (- (isurp4-cnt-j $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-1)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) (isurp4-cnt-1 $ctx $norm 0))
  (O (count (isurp4-cnt-1 $ctx $norm $k) $k $c1) (- (isurp4-cnt-1 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-2)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) (isurp4-cnt-2 $ctx $norm 0))
  (O (count (isurp4-cnt-2 $ctx $norm $k) $k $c2) (- (isurp4-cnt-2 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-3)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c3) (isurp4-cnt-3 $ctx $norm 0))
  (O (count (isurp4-cnt-3 $ctx $norm $k) $k $c3) (- (isurp4-cnt-3 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-4)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c4) (isurp4-cnt-4 $ctx $norm 0))
  (O (count (isurp4-cnt-4 $ctx $norm $k) $k $c4) (- (isurp4-cnt-4 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-12)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) (isurp4-cnt-12 $ctx $norm 0))
  (O (count (isurp4-cnt-12 $ctx $norm $k) $k ($c1 $c2)) (- (isurp4-cnt-12 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-13)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c3) (isurp4-cnt-13 $ctx $norm 0))
  (O (count (isurp4-cnt-13 $ctx $norm $k) $k ($c1 $c3)) (- (isurp4-cnt-13 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-14)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c4) (isurp4-cnt-14 $ctx $norm 0))
  (O (count (isurp4-cnt-14 $ctx $norm $k) $k ($c1 $c4)) (- (isurp4-cnt-14 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-23)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) ($db $c3) (isurp4-cnt-23 $ctx $norm 0))
  (O (count (isurp4-cnt-23 $ctx $norm $k) $k ($c2 $c3)) (- (isurp4-cnt-23 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-24)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) ($db $c4) (isurp4-cnt-24 $ctx $norm 0))
  (O (count (isurp4-cnt-24 $ctx $norm $k) $k ($c2 $c4)) (- (isurp4-cnt-24 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-34)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c3) ($db $c4) (isurp4-cnt-34 $ctx $norm 0))
  (O (count (isurp4-cnt-34 $ctx $norm $k) $k ($c3 $c4)) (- (isurp4-cnt-34 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-123)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) ($db $c3) (isurp4-cnt-123 $ctx $norm 0))
  (O (count (isurp4-cnt-123 $ctx $norm $k) $k ($c1 $c2 $c3)) (- (isurp4-cnt-123 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-124)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) ($db $c4) (isurp4-cnt-124 $ctx $norm 0))
  (O (count (isurp4-cnt-124 $ctx $norm $k) $k ($c1 $c2 $c4)) (- (isurp4-cnt-124 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-134)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c3) ($db $c4) (isurp4-cnt-134 $ctx $norm 0))
  (O (count (isurp4-cnt-134 $ctx $norm $k) $k ($c1 $c3 $c4)) (- (isurp4-cnt-134 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-234)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) ($db $c3) ($db $c4) (isurp4-cnt-234 $ctx $norm 0))
  (O (count (isurp4-cnt-234 $ctx $norm $k) $k ($c2 $c3 $c4)) (- (isurp4-cnt-234 $ctx $norm 0))))

(exec (freq 083 isurp4-calc)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     (isurp4-cnt-total $ctx $norm $n)
     (isurp4-cnt-j $ctx $norm $j)
     (isurp4-cnt-1 $ctx $norm $k1)
     (isurp4-cnt-2 $ctx $norm $k2)
     (isurp4-cnt-3 $ctx $norm $k3)
     (isurp4-cnt-4 $ctx $norm $k4)
     (isurp4-cnt-12 $ctx $norm $k12)
     (isurp4-cnt-13 $ctx $norm $k13)
     (isurp4-cnt-14 $ctx $norm $k14)
     (isurp4-cnt-23 $ctx $norm $k23)
     (isurp4-cnt-24 $ctx $norm $k24)
     (isurp4-cnt-34 $ctx $norm $k34)
     (isurp4-cnt-123 $ctx $norm $k123)
     (isurp4-cnt-124 $ctx $norm $k124)
     (isurp4-cnt-134 $ctx $norm $k134)
     (isurp4-cnt-234 $ctx $norm $k234))
  (O
    (pure (isurp4-pj $ctx $norm $ppat) $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (f64_from_string
            (i64_to_string
              (div_i64
                (falling_factorial (i64_from_string $n) (i64_from_string 4))
                (factorial (i64_from_string 4))))))))
    ;; 4 partitions of type 3+1
    (pure (isurp4-p1 $ctx $norm $p1) $p1
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k123) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p2 $ctx $norm $p2) $p2
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k124) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p3 $ctx $norm $p3) $p3
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k134) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p4 $ctx $norm $p4) $p4
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k234) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    ;; 3 partitions of type 2+2
    (pure (isurp4-p5 $ctx $norm $p5) $p5
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k12) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k34) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p6 $ctx $norm $p6) $p6
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k13) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k24) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p7 $ctx $norm $p7) $p7
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k14) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k23) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    ;; 6 partitions of type 2+1+1
    (pure (isurp4-p8 $ctx $norm $p8) $p8
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k12) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p9 $ctx $norm $p9) $p9
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k13) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p10 $ctx $norm $p10) $p10
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k14) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p11 $ctx $norm $p11) $p11
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k23) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p12 $ctx $norm $p12) $p12
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k24) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p13 $ctx $norm $p13) $p13
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k34) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    ;; 1 partition of type 1+1+1+1
    (pure (isurp4-p14 $ctx $norm $p14) $p14
      (f64_to_string (product_f64 (product_f64 (product_f64 (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (- (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm))
    (- (isurp4-cnt-total $ctx $norm $n))
    (- (isurp4-cnt-j $ctx $norm $j))
    (- (isurp4-cnt-1 $ctx $norm $k1))
    (- (isurp4-cnt-2 $ctx $norm $k2))
    (- (isurp4-cnt-3 $ctx $norm $k3))
    (- (isurp4-cnt-4 $ctx $norm $k4))
    (- (isurp4-cnt-12 $ctx $norm $k12))
    (- (isurp4-cnt-13 $ctx $norm $k13))
    (- (isurp4-cnt-14 $ctx $norm $k14))
    (- (isurp4-cnt-23 $ctx $norm $k23))
    (- (isurp4-cnt-24 $ctx $norm $k24))
    (- (isurp4-cnt-34 $ctx $norm $k34))
    (- (isurp4-cnt-123 $ctx $norm $k123))
    (- (isurp4-cnt-124 $ctx $norm $k124))
    (- (isurp4-cnt-134 $ctx $norm $k134))
    (- (isurp4-cnt-234 $ctx $norm $k234))))

(exec (freq 084 isurp4-minmax)
  (, (isurp4-pj $ctx $norm $ppat)
     (isurp4-p1 $ctx $norm $p1)
     (isurp4-p2 $ctx $norm $p2)
     (isurp4-p3 $ctx $norm $p3)
     (isurp4-p4 $ctx $norm $p4)
     (isurp4-p5 $ctx $norm $p5)
     (isurp4-p6 $ctx $norm $p6)
     (isurp4-p7 $ctx $norm $p7)
     (isurp4-p8 $ctx $norm $p8)
     (isurp4-p9 $ctx $norm $p9)
     (isurp4-p10 $ctx $norm $p10)
     (isurp4-p11 $ctx $norm $p11)
     (isurp4-p12 $ctx $norm $p12)
     (isurp4-p13 $ctx $norm $p13)
     (isurp4-p14 $ctx $norm $p14))
  (O
    (pure (isurp4-emin $ctx $norm $emin) $emin
      (min-atom (' ($p1 $p2 $p3 $p4 $p5 $p6 $p7 $p8 $p9 $p10 $p11 $p12 $p13 $p14))))
    (pure (isurp4-emax $ctx $norm $emax) $emax
      (max-atom (' ($p1 $p2 $p3 $p4 $p5 $p6 $p7 $p8 $p9 $p10 $p11 $p12 $p13 $p14))))
    (- (isurp4-p1 $ctx $norm $p1))
    (- (isurp4-p2 $ctx $norm $p2))
    (- (isurp4-p3 $ctx $norm $p3))
    (- (isurp4-p4 $ctx $norm $p4))
    (- (isurp4-p5 $ctx $norm $p5))
    (- (isurp4-p6 $ctx $norm $p6))
    (- (isurp4-p7 $ctx $norm $p7))
    (- (isurp4-p8 $ctx $norm $p8))
    (- (isurp4-p9 $ctx $norm $p9))
    (- (isurp4-p10 $ctx $norm $p10))
    (- (isurp4-p11 $ctx $norm $p11))
    (- (isurp4-p12 $ctx $norm $p12))
    (- (isurp4-p13 $ctx $norm $p13))
    (- (isurp4-p14 $ctx $norm $p14))))

(exec (freq 085 isurp4-emit-raw)
  (, (isurp4-pj $ctx False $ppat)
     (isurp4-emin $ctx False $emin)
     (isurp4-emax $ctx False $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $emin)
                (f64_from_string $emax))))
          (f64_from_string 1.0))))
    (- (isurp4-pj $ctx False $ppat))
    (- (isurp4-emin $ctx False $emin))
    (- (isurp4-emax $ctx False $emax))))

(exec (freq 085 isurp4-emit-norm)
  (, (isurp4-pj $ctx True $ppat)
     (isurp4-emin $ctx True $emin)
     (isurp4-emax $ctx True $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $emin)
                  (f64_from_string $emax))))
            (max_f64 (f64_from_string $emax) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp4-pj $ctx True $ppat))
    (- (isurp4-emin $ctx True $emin))
    (- (isurp4-emax $ctx True $emax))))
