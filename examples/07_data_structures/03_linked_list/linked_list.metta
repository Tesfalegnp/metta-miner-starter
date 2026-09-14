; Simple linked-list representation
(Nil)
(Cons 1 (Cons 2 (Cons 3 Nil)))

(= (member $e (Cons $e $xs)) $e)
(= (member $e (Cons $x $xs)) (member $e $xs))
