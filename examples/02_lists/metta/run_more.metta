; Additional demos for MeTTa list operations: indexing, take/drop, insert/remove, pop
!(load "list_lib.metta")

!(println "--- nth Zero (first element) ---")
!(println (nth Zero (Cons 9 (Cons 8 (Cons 7 Nil)))))

!(println "--- nth Succ Zero (second element) ---")
!(println (nth (Succ Zero) (Cons 9 (Cons 8 (Cons 7 Nil)))))

!(println "--- take Succ (Succ Zero) first 2 elements ---")
!(println (take (Succ (Succ Zero)) (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- drop Succ Zero drop first element ---")
!(println (drop (Succ Zero) (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- insert_at Zero insert 99 at head ---")
!(println (insert_at Zero 99 (Cons 1 (Cons 2 Nil))))

!(println "--- remove_first 2 from list ---")
!(println (remove_first 2 (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- pop_head from list ---")
!(println (pop_head (Cons 5 (Cons 6 Nil))))

!(println "--- clear is Nil ---")
!(println (Nil))
