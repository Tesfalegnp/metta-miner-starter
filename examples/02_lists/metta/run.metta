; Runner for the MeTTa list examples.
; Loads the list library and demonstrates several operations.

!(load "list_lib.metta")

!(println "--- Demonstrate head on (Cons 1 2 3) ---")
!(println (head (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- Demonstrate tail ---")
!(println (tail (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- Demonstrate append ---")
!(println (append (Cons 1 (Cons 2 Nil)) (Cons 3 (Cons 4 Nil))))

!(println "--- Demonstrate member (2 in list) ---")
!(println (member 2 (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- Demonstrate length (Peano) ---")
!(println (length (Cons 1 (Cons 2 (Cons 3 Nil)))))

!(println "--- Demonstrate map inc ---")
!(println (map inc (Cons 1 (Cons 2 (Cons 3 Nil)))))