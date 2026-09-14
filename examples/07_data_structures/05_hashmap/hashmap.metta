; Key-value facts
(KV a 1)
(KV b 2)

(= (get $k)
   (match (KV $k $v)
      (KV $k $v)
      $v))
