; MM2 rule to count distinct Element facts and produce a ListLength atom.
(exec CountElements
   (, (Element $x))
   (O (count (ListLength $count) $count $x)))
