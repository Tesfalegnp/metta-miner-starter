; Simple tree and preorder rule (similar to recursion examples)
(Node 1 (Node 2 (Node 4 (Nil) (Nil)) (Node 5 (Nil) (Nil))) (Node 3 (Node 6 (Nil) (Nil)) (Node 7 (Nil) (Nil))))

(= (preorder (Node $v $l $r)) (Cons $v (append (preorder $l) (preorder $r))))
(= (preorder (Nil)) Nil)
