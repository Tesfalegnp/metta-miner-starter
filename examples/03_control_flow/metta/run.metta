; Demo runner for control-flow MeTTa examples.
!(load "loop_lib.metta")

!(println "--- range 1..3 ---")
!(println (range 1 3))

!(println "--- for_each inc over range 1..3 ---")
!(println (for_each inc (range 1 3)))

!(println "--- while_do: start=1 cond: lt <4 body: inc ---")
!(println (while_do lt inc 1))

!(println "--- nested_iter: pair every from 1..2 with 10..11 ---")
!(println (nested_iter (range 1 2) (Cons 10 (Cons 11 Nil))))
