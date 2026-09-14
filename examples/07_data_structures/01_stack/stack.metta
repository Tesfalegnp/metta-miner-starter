; Symbolic stack represented as nested StackCons/StackNil atoms
(StackNil)
(StackCons 1 (StackCons 2 (StackCons 3 StackNil)))

; Example rule: peek returns the top element
(= (peek-stack (StackCons $x $xs)) $x)
