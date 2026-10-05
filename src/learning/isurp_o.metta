(exec (freq 176 total_count)
    (,  (db_size $db) 
        (n_conjuncts_new $pattern))
    (0
     (pure (database_size $db) $db_size (length (' $db)))
     (pure (count_conjuncts $pattern) $n_conjuncts_new (length (' $pattern)))
     (+ (cal_binomial $db_size $n_conjuncts_new))
     (- (db_size $db) )
     (- (n_conjuncts_new $pattern))
     )
)

(exec (freq 177 accumulator-x)
    (,  (accumulator-x $num_list)
        (DEF accumulator-x $num_list 1))
    (0
        (pure (accumulator-x $num_list $prev_value) $prev_value (car-atom (' $num_list)))
     (+ (exec (freq 177 accumulator-x) (cdr-atom (' $num_list)) $prev_value))
     (- (accumulator-x $num_list))
     )

)
(DEF accumulator-x
    (, 
        ($num_list ())
    )
    (0 
        (+ ($prev_value))
    )
)(DEF accumulator-x
    (, 
        (not ($num_list ()))
    )
    (0 
        (pure (list-fact-rebuilt $new_list) $new_list (dcons-atom (' $head) (' $tail)))
        (exec (freq 177 accumulator-x) $tail (* $head $prev_value))
        (- (accumulator-x $num_list $prev_value))
    )
)