; Runner for the MeTTa functions examples.

!(load "function_lib.metta")

!(println "--- Demonstrate basic function: inc 1 -> 2 ---")
!(println (inc 1))

!(println "--- Demonstrate multiple params: add 1 2 -> 3 ---")
!(println (add 1 2))

!(println "--- Demonstrate nested call: inc (inc 1) ---")
!(println (inc (inc 1)))

!(println "--- Demonstrate doubleinc via function ---")
!(println (doubleinc 1))

!(println "--- Demonstrate compose inc ∘ inc on 1 ---")
!(println (compose inc inc 1))

!(println "--- Demonstrate higher-order map with inc ---")
!(println (map inc (Cons 1 (Cons 2 Nil))))

!(println "--- Demonstrate pair and selectors ---")
!(println (pair 1 2))
!(println (fst (pair 1 2)))
!(println (snd (pair 1 2)))
