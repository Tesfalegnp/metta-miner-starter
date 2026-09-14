; Derive transitive closure for Edge via exec rule
(exec Transit
   (, (Edge $a $b) (Edge $b $c))
   (, (Edge $a $c)))
