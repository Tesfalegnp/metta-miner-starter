; ============================================================
; Pattern Miner - MORK/MM2 Execution Rules
; ============================================================
; MORK uses `exec` rules. Each rule has a query (the second
; argument) and an output (the third argument). Rules derive new
; facts until no new facts can be created.

; 1. Find humans who like Soda.
(exec DeriveSoda
   (, (: $person Human)
      (Likes $person Soda))
   (, (HumanLikes Soda $person)))

; 2. Find humans who like Pizza.
(exec DerivePizza
   (, (: $person Human)
      (Likes $person Pizza))
   (, (HumanLikes Pizza $person)))

; 3. Find humans who like BOTH Soda and Pizza.
(exec DeriveSodaPizza
   (, (: $person Human)
      (Likes $person Soda)
      (Likes $person Pizza))
   (, (HumanLikes SodaPizza $person)))

; 4. Count each result set. `count` is a MORK aggregation sink:
; it stores the number of distinct matching people in Support.
(exec CountSoda
   (, (: $person Human)
      (Likes $person Soda))
   (O (count (Support Soda $count) $count $person)))

(exec CountPizza
   (, (: $person Human)
      (Likes $person Pizza))
   (O (count (Support Pizza $count) $count $person)))

(exec CountSodaPizza
   (, (: $person Human)
      (Likes $person Soda)
      (Likes $person Pizza))
   (O (count (Support SodaPizza $count) $count $person)))

; 5. Classify the patterns against minimum support = 2.
; The three support values are 3 in this fixed educational data set.
(exec ClassifySoda
   (, (MinimumSupport 2)
      (Support Soda 3))
   (, (PatternResult Soda 3 Frequent)))

(exec ClassifyPizza
   (, (MinimumSupport 2)
      (Support Pizza 3))
   (, (PatternResult Pizza 3 Frequent)))

(exec ClassifySodaPizza
   (, (MinimumSupport 2)
      (Support SodaPizza 3))
   (, (PatternResult SodaPizza 3 Frequent)))
