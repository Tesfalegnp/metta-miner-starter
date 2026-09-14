; Runner for MeTTa recursion examples.

!(load "recursion_lib.metta")

!(println "--- Factorial examples (Peano) ---")
!(println (fact Zero))
!(println (fact (Succ Zero)))
!(println (fact (Succ (Succ Zero))))

!(println "--- Fibonacci examples (Peano) ---")
!(println (fib Zero))
!(println (fib (Succ Zero)))
!(println (fib (Succ (Succ Zero))))

!(println "--- Sum of list ---")
!(println (sum_list (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- Reverse list ---")
!(println (reverse (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- Preorder tree traversal ---")
!(println (preorder (Node 1 (Node 2 (Nil) (Nil)) (Node 3 (Nil) (Nil)))))
