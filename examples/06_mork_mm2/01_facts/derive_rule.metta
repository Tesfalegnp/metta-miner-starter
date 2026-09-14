; Derive a HumanLike-style fact from Person + Likes
(exec DeriveLikes
   (, (: $p Person)
      (Likes $p Soda))
   (, (PersonLikes Soda $p)))
