; ============================================================
; Pattern Miner Mini Project - Demo
; ============================================================


; ------------------------------------------------------------
; Load knowledge base and mining logic
; ------------------------------------------------------------

!(load "data.metta")
!(load "miner.metta")


; ------------------------------------------------------------
; Header
; ------------------------------------------------------------

!(println "")
!(println "==========================================")
!(println "PATTERN MINER MINI PROJECT")
!(println "==========================================")


; ------------------------------------------------------------
; Pattern 1: Humans who like Soda
; ------------------------------------------------------------

!(println "")
!(println "--- Pattern 1: Humans who like Soda ---")

!(match &self
   (Inheritance $x Human)
   (match &self
      (Evaluation (Likes $x Soda))
      $x))


; ------------------------------------------------------------
; Support: Human + Soda
; ------------------------------------------------------------

!(println "")
!(println "--- Support: Human AND Likes Soda ---")

!(size
   (match &self
      (Inheritance $x Human)
      (match &self
         (Evaluation (Likes $x Soda))
         $x)))


; ------------------------------------------------------------
; Pattern 2: Humans who like Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Pattern 2: Humans who like Pizza ---")

!(match &self
   (Inheritance $x Human)
   (match &self
      (Evaluation (Likes $x Pizza))
      $x))


; ------------------------------------------------------------
; Support: Human + Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Support: Human AND Likes Pizza ---")

!(size
   (match &self
      (Inheritance $x Human)
      (match &self
         (Evaluation (Likes $x Pizza))
         $x)))


; ------------------------------------------------------------
; Pattern 3: Human + Soda + Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Pattern 3: Human + Soda + Pizza ---")

!(match &self
   (Inheritance $x Human)
   (match &self
      (Evaluation (Likes $x Soda))
      (match &self
         (Evaluation (Likes $x Pizza))
         $x)))


; ------------------------------------------------------------
; Support: Human + Soda + Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Support: Human + Soda + Pizza ---")

!(size
   (match &self
      (Inheritance $x Human)
      (match &self
         (Evaluation (Likes $x Soda))
         (match &self
            (Evaluation (Likes $x Pizza))
            $x))))


; ------------------------------------------------------------
; Minimum Support = 2
; ------------------------------------------------------------

!(println "")
!(println "--- Minimum Support = 2 ---")

!(mine-pattern &self Soda 2)

!(mine-pattern &self Water 2)


; ------------------------------------------------------------
; Footer
; ------------------------------------------------------------

!(println "")
!(println "==========================================")
!(println "MINING COMPLETE")
!(println "==========================================")