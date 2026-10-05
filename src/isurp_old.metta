```lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Independent ISURP-OLD implementation
;;
;; Purpose:
;;   Re-implement the original PeTTa/MeTTa isurp-old algorithm in MM2.
;;
;; IMPORTANT DESIGN DIFFERENCE:
;;   This implementation does NOT use the mentor/reference architecture:
;;
;;       partitions-of
;;       emit-partition
;;       copy-partition
;;       emit-block
;;
;;   Instead, for the validated 3-conjunct case, it directly constructs the
;;   four required independent partition products:
;;
;;       P(c1)       * P(c2,c3)
;;       P(c1,c3)    * P(c2)
;;       P(c1,c2)    * P(c3)
;;       P(c1)       * P(c2) * P(c3)
;;
;;   Then:
;;
;;       emin = min(P1,P2,P3,P4)
;;       emax = max(P1,P2,P3,P4)
;;       dst  = distance(emp, [emin,emax])
;;
;;   Finally:
;;
;;       normalized = min(dst / max(emax,emp), 1.0)
;;
;;       raw = min(dst, 1.0)
;;
;; Mathematical source:
;;   Original MeTTa:
;;
;;       total_counts
;;       prob
;;       partitions-wout-pattern
;;       iprob
;;       isurp-old_
;;       min-max
;;       dst_from_interval
;;       normalization
;;
;; MM2 architecture:
;;
;;       INPUT PATTERN
;;            |
;;       pattern decomposition
;;            |
;;       total_counts
;;            |
;;       empirical prob
;;            |
;;       six direct block support probes
;;            |
;;       six block probabilities
;;            |
;;       four direct partition products
;;            |
;;       min/max
;;            |
;;       interval distance
;;            |
;;       normalization/raw result
;;            |
;;       cleanup
;;
;; Scope:
;;   Validated 3-conjunct ISurp-old path.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 0. INPUT / CONTEXT INITIALIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original MeTTa entry:
;;
;;   isurp-old $pattern $db $normalize
;;
;; MM2 receives:
;;
;;   (INPUT PATTERN ($pattern $support))
;;   (INPUT DB-SIZE $db-size)
;;   (INPUT NORMALIZATION TRUE/FALSE)
;;
;; We keep `isurp-old` as the public result predicate.

(exec (surp s010 isurp-old)
    (, (INPUT PATTERN ($pattern $support)))
    (O
        (pure
            (isurp-old-context $ctx $pattern $support)
            $ctx
            (vars_to_indices
                (cdr-atom (' $pattern))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. n_conjuncts_new
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   (n_conjuncts_new $pattern)
;;
;; Equivalent MM2 operation:
;;
;;   size-atom(cdr(pattern))

(exec (surp s020 n_conjuncts_new)
    (, (isurp-old-context $ctx $pattern $support))
    (O
        (pure
            (n_conjuncts_new $ctx $count)
            $count
            (size-atom
                (cdr-atom (' $pattern))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. total_counts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   total_counts =
;;       C(DB-SIZE, number-of-conjuncts)
;;
;; The falling-factorial form is:
;;
;;   N * (N-1) * ... * (N-k+1) / k!
;;
;; which is C(N,k).

(exec (surp s030 total_counts)
    (, (INPUT DB-SIZE $db-size)
       (n_conjuncts_new $ctx $k))
    (O
        (pure
            (total_counts $ctx $total)
            $total
            (i64_to_string
                (div_i64
                    (falling_factorial
                        (i64_from_string $db-size)
                        (i64_from_string $k))
                    (factorial
                        (i64_from_string $k)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. prob
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   prob(pattern, db, total_count)
;;       = support(pattern) / total_count
;;
;; For the full input pattern, the support is supplied by INPUT PATTERN.
;;
;; IMPORTANT:
;;   Block probabilities later use the SAME total_counts of the FULL pattern.
;;
;; This matches the validated PeTTa behavior:
;;
;;   block-prob = block-support / full-pattern-total-count
;;
;; and NOT:
;;
;;   block-support / DB-SIZE
;;
;; This distinction is required for validation.

(exec (surp s040 prob)
    (, (isurp-old-context $ctx $pattern $support)
       (total_counts $ctx $total))
    (O
        (pure
            (prob $ctx $pattern $emp-prob)
            $emp-prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. Direct pattern decomposition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Unlike the mentor implementation, we do NOT generate a partition list.
;;
;; We directly extract the three conjuncts required by the validated
;; 3-conjunct ISurp path.

(exec (surp s050 decompose-pattern)
    (, (isurp-old-context $ctx $pattern $support))
    (O
        (let* (
            ($clauses
                (cdr-atom (' $pattern)))

            (($c1 $c2 $c3)
                $clauses)
        )
        (O
            (pure
                (isurp-old-clauses
                    $ctx
                    $c1
                    $c2
                    $c3)
                ($c1 $c2 $c3))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. add-pattern
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original MeTTa:
;;
;;   add-pattern($blocks,$db)
;;
;; converts a list of blocks into a conjunction.
;;
;; In this implementation the actual database query is constructed directly
;; from an indexed block, so we retain the same conceptual operation as a
;; compatibility predicate.

(exec (surp s060 add-pattern)
    (, (isurp-old-clauses
            $ctx
            $c1
            $c2
            $c3))
    (O
        (pure
            (add-pattern $ctx ($c1 $c2 $c3) $pattern)
            $pattern
            (cons-atom
                ,
                ('$c1 '$c2 '$c3))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. compute-component-support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Compatibility representation of the original helper.
;;
;; The optimized ISurp path does NOT need to recursively superpose every
;; component. Each required block is queried directly below.
;;
;; Therefore this predicate is retained as the old function-name equivalent,
;; while the production path uses the direct block probes.

(exec (surp s070 compute-component-support)
    (, (isurp-old-context $ctx $pattern $support))
    (O
        (pure
            (compute-component-support $ctx $pattern $support)
            $support)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. ptrn-support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   ptrn-support =
;;       product(component supports)
;;
;; Keep the old name for compatibility.
;;
;; The actual old isurp probability path uses `prob` based on the observed
;; pattern support, so ptrn-support is not used for the final empirical
;; probability.

(exec (surp s080 ptrn-support)
    (, (isurp-old-context $ctx $pattern $support))
    (O
        (pure
            (ptrn-support $ctx $pattern $value)
            $value
            $support)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8. Direct block-support construction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This is the key architectural difference.
;;
;; We materialize exactly six required block probes:
;;
;;   singleton:
;;       c1
;;       c2
;;       c3
;;
;;   pairs:
;;       c1,c2
;;       c1,c3
;;       c2,c3
;;
;; No partition objects are generated.
;; No partition list is recursively walked.
;; No copy-of-partition is created.
;; No emit-block recursion is used.

(exec (surp s090 prepare-blocks)
    (, (isurp-old-clauses
            $ctx
            $c1
            $c2
            $c3))
    (O
        (+ (direct-block $ctx b1 ($c1)))
        (+ (direct-block $ctx b2 ($c2)))
        (+ (direct-block $ctx b3 ($c3)))
        (+ (direct-block $ctx b12 ($c1 $c2)))
        (+ (direct-block $ctx b13 ($c1 $c3)))
        (+ (direct-block $ctx b23 ($c2 $c3))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 9. count direct blocks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Singleton c1

(exec (surp s100 count-block-c1)
    (, (direct-block $ctx b1 ($c1)))
    (O
        (pure
            (block-support $ctx b1 $support)
            $support
            (count
                (block-support-query $ctx b1 $support)
                (indices_to_vars
                    (cons , ('$c1))))))))


;; Singleton c2

(exec (surp s101 count-block-c2)
    (, (direct-block $ctx b2 ($c2)))
    (O
        (pure
            (block-support $ctx b2 $support)
            $support
            (count
                (block-support-query $ctx b2 $support)
                (indices_to_vars
                    (cons , ('$c2))))))))


;; Singleton c3

(exec (surp s102 count-block-c3)
    (, (direct-block $ctx b3 ($c3)))
    (O
        (pure
            (block-support $ctx b3 $support)
            $support
            (count
                (block-support-query $ctx b3 $support)
                (indices_to_vars
                    (cons , ('$c3))))))))


;; Pair c1,c2

(exec (surp s103 count-block-c12)
    (, (direct-block $ctx b12 ($c1 $c2)))
    (O
        (pure
            (block-support $ctx b12 $support)
            $support
            (count
                (block-support-query $ctx b12 $support)
                (indices_to_vars
                    (cons , ('$c1 '$c2))))))))


;; Pair c1,c3

(exec (surp s104 count-block-c13)
    (, (direct-block $ctx b13 ($c1 $c3)))
    (O
        (pure
            (block-support $ctx b13 $support)
            $support
            (count
                (block-support-query $ctx b13 $support)
                (indices_to_vars
                    (cons , ('$c1 '$c3))))))))


;; Pair c2,c3

(exec (surp s105 count-block-c23)
    (, (direct-block $ctx b23 ($c2 $c3)))
    (O
        (pure
            (block-support $ctx b23 $support)
            $support
            (count
                (block-support-query $ctx b23 $support)
                (indices_to_vars
                    (cons , ('$c2 '$c3))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 10. blk-prob
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   blk-prob(block, db, total_count)
;;       = prob(block, db, total_count)
;;
;; IMPORTANT:
;;   denominator = total_count of FULL PATTERN.
;;
;; This is one of the confirmed requirements of the original implementation.

;; c1

(exec (surp s110 blk-prob-c1)
    (, (block-support $ctx b1 $support)
       (total_counts $ctx $total))
    (O
        (pure
            (blk-prob $ctx b1 $prob)
            $prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;; c2

(exec (surp s111 blk-prob-c2)
    (, (block-support $ctx b2 $support)
       (total_counts $ctx $total))
    (O
        (pure
            (blk-prob $ctx b2 $prob)
            $prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;; c3

(exec (surp s112 blk-prob-c3)
    (, (block-support $ctx b3 $support)
       (total_counts $ctx $total))
    (O
        (pure
            (blk-prob $ctx b3 $prob)
            $prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;; c1,c2

(exec (surp s113 blk-prob-c12)
    (, (block-support $ctx b12 $support)
       (total_counts $ctx $total))
    (O
        (pure
            (blk-prob $ctx b12 $prob)
            $prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;; c1,c3

(exec (surp s114 blk-prob-c13)
    (, (block-support $ctx b13 $support)
       (total_counts $ctx $total))
    (O
        (pure
            (blk-prob $ctx b13 $prob)
            $prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;; c2,c3

(exec (surp s115 blk-prob-c23)
    (, (block-support $ctx b23 $support)
       (total_counts $ctx $total))
    (O
        (pure
            (blk-prob $ctx b23 $prob)
            $prob
            (f64_to_string
                (div_f64
                    (f64_from_string $support)
                    (f64_from_string $total))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11. iprob
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original MeTTa:
;;
;;   iprob(partition)
;;       = product(block probabilities)
;;
;; Instead of receiving a dynamically generated partition list, we directly
;; calculate the four required products.
;;
;; This preserves the mathematical meaning of iprob while avoiding recursive
;; partition/block traversal.

;; Partition 1:
;;
;;   (c1) | (c2,c3)

(exec (surp s120 iprob-p1)
    (, (blk-prob $ctx b1 $p1)
       (blk-prob $ctx b23 $p23))
    (O
        (pure
            (iprob $ctx p1 $value)
            $value
            (f64_to_string
                (product_f64
                    (f64_from_string $p1)
                    (f64_from_string $p23))))))


;; Partition 2:
;;
;;   (c1,c3) | (c2)

(exec (surp s121 iprob-p2)
    (, (blk-prob $ctx b13 $p13)
       (blk-prob $ctx b2 $p2))
    (O
        (pure
            (iprob $ctx p2 $value)
            $value
            (f64_to_string
                (product_f64
                    (f64_from_string $p13)
                    (f64_from_string $p2))))))


;; Partition 3:
;;
;;   (c1,c2) | (c3)

(exec (surp s122 iprob-p3)
    (, (blk-prob $ctx b12 $p12)
       (blk-prob $ctx b3 $p3))
    (O
        (pure
            (iprob $ctx p3 $value)
            $value
            (f64_to_string
                (product_f64
                    (f64_from_string $p12)
                    (f64_from_string $p3))))))


;; Partition 4:
;;
;;   (c1) | (c2) | (c3)

(exec (surp s123 iprob-p4)
    (, (blk-prob $ctx b1 $p1)
       (blk-prob $ctx b2 $p2)
       (blk-prob $ctx b3 $p3))
    (O
        (pure
            (iprob $ctx p4 $value)
            $value
            (f64_to_string
                (product_f64
                    (product_f64
                        (f64_from_string $p1)
                        (f64_from_string $p2))
                    (f64_from_string $p3))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 12. iprob_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Compatibility predicate for the original recursive helper.
;;
;; Original:
;;
;;   iprob_ partition db total_count
;;
;; recursively returned a list of block probabilities.
;;
;; Our optimized implementation does not need to recursively walk a partition.
;; The four direct iprob products above replace that traversal.

(exec (surp s124 iprob_)
    (, (iprob $ctx p1 $p1)
       (iprob $ctx p2 $p2)
       (iprob $ctx p3 $p3)
       (iprob $ctx p4 $p4))
    (O
        (pure
            (iprob_ $ctx $products)
            $products
            ('$p1 '$p2 '$p3 '$p4))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 13. isurp-old_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   isurp-old_($partitions,$db,$total_count)
;;
;; produced the probability of every partition.
;;
;; Our direct version stores the four independently estimated probabilities.

(exec (surp s130 isurp-old_)
    (, (iprob $ctx p1 $p1)
       (iprob $ctx p2 $p2)
       (iprob $ctx p3 $p3)
       (iprob $ctx p4 $p4))
    (O
        (pure
            (isurp-old_ $ctx $results)
            $results
            ('$p1 '$p2 '$p3 '$p4))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 14. min-max
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   ($emin $emax) = min-max($results)
;;
;; Directly aggregate the four probability estimates.

(exec (surp s140 min-max)
    (, (isurp-old_ $ctx ($p1 $p2 $p3 $p4)))
    (O
        (pure
            (min-max $ctx $emin)
            $emin
            (min-atom
                ('$p1 '$p2 '$p3 '$p4)))

        (pure
            (min-max $ctx $emax)
            $emax
            (max-atom
                ('$p1 '$p2 '$p3 '$p4))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 15. interval
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(exec (surp s150 interval)
    (, (min-max $ctx $emin)
       (min-max $ctx $emax))
    (O
        (pure
            (interval $ctx ($emin $emax))
            ($emin $emax))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 16. dst_from_interval
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   dst_from_interval(emin,emax,emp)
;;
;; Equivalent compact form:
;;
;;   max(emin - emp, emp - emax, 0)
;;
;; This removes the need for three separate above/below/inside rules.

(exec (surp s160 dst_from_interval)
    (, (interval $ctx ($emin $emax))
       (prob $ctx $pattern $emp))
    (O
        (pure
            (dst_from_interval $ctx $dst)
            $dst
            (f64_to_string
                (max_f64
                    (sub_f64
                        (f64_from_string $emin)
                        (f64_from_string $emp))

                    (sub_f64
                        (f64_from_string $emp)
                        (f64_from_string $emax))

                    (f64_from_string 0.0))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 17. Normalized isurp-old
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   min(
;;       dst / max(emax, pattern_prob),
;;       1.0
;;   )

(exec (surp s170 isurp-old-normalized)
    (, (INPUT NORMALIZATION TRUE)
       (isurp-old-context $ctx $pattern $support)
       (prob $ctx $pattern $emp)
       (interval $ctx ($emin $emax))
       (dst_from_interval $ctx $dst))
    (O
        (pure
            (isurp-old-result $ctx $value)
            $value
            (min-atom
                (f64_to_string
                    (div_f64
                        (f64_from_string $dst)
                        (max_f64
                            (f64_from_string $emax)
                            (f64_from_string $emp))))
                1.0)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 18. Raw isurp-old
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original:
;;
;;   min(dst,1.0)
;;
;; This preserves the final upper bound.

(exec (surp s180 isurp-old-raw)
    (, (INPUT NORMALIZATION FALSE)
       (isurp-old-context $ctx $pattern $support)
       (dst_from_interval $ctx $dst))
    (O
        (pure
            (isurp-old-result $ctx $value)
            $value
            (min-atom
                ('$dst 1.0))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 19. accumulator-x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original helper:
;;
;;   accumulator-x(list)
;;       = product(list)
;;
;; The optimized production path uses product_f64 directly.
;;
;; This compatibility implementation remains available for callers that
;; still use the old function name.

(exec (surp s190 accumulator-x)
    (, (product-input $ctx $values))
    (O
        (pure
            (accumulator-x $ctx $product)
            $product
            (product-list-f64 $values))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 20. FINAL PUBLIC RESULT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert the internal result into the same old public function name.

(exec (surp s200 final-isurp-old)
    (, (isurp-old-context $ctx $pattern $support)
       (isurp-old-result $ctx $value))
    (O
        (+ (isurp-old $pattern $value))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 21. CLEANUP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Remove temporary block/support/probability facts.
;;
;; This is deliberately different from the mentor's cleanup-plan mechanism.
;; We directly remove facts owned by the current context.

(exec (surp s900 cleanup-isurp-old)
    (, (isurp-old $pattern $value)
       (isurp-old-context $ctx $pattern $support))
    (O
        (- (isurp-old-context $ctx $pattern $support))
        (- (isurp-old-clauses $ctx $c1 $c2 $c3))

        (- (direct-block $ctx b1 $block))
        (- (direct-block $ctx b2 $block))
        (- (direct-block $ctx b3 $block))
        (- (direct-block $ctx b12 $block))
        (- (direct-block $ctx b13 $block))
        (- (direct-block $ctx b23 $block))

        (- (block-support $ctx b1 $support))
        (- (block-support $ctx b2 $support))
        (- (block-support $ctx b3 $support))
        (- (block-support $ctx b12 $support))
        (- (block-support $ctx b13 $support))
        (- (block-support $ctx b23 $support))

        (- (blk-prob $ctx b1 $prob))
        (- (blk-prob $ctx b2 $prob))
        (- (blk-prob $ctx b3 $prob))
        (- (blk-prob $ctx b12 $prob))
        (- (blk-prob $ctx b13 $prob))
        (- (blk-prob $ctx b23 $prob))

        (- (iprob $ctx p1 $value))
        (- (iprob $ctx p2 $value))
        (- (iprob $ctx p3 $value))
        (- (iprob $ctx p4 $value))

        (- (isurp-old_ $ctx $results))
        (- (min-max $ctx $value))
        (- (interval $ctx $value))
        (- (dst_from_interval $ctx $value))
        (- (isurp-old-result $ctx $value))
    ))
```
