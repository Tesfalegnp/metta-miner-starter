; Count how many distinct people like Soda and emit Support facts
(exec CountSoda
   (, (: $p Person)
      (Likes $p Soda))
   (O (count (Support Soda $count) $count $p)))
