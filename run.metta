; ============================================================
; Pattern Miner Mini Project - Demo
; ============================================================

!(bind! &kb (new-space))

!(load "data.metta" &kb)
!(load "miner.metta" &kb)


!(println "")
!(println "==========================================")
!(println "PATTERN MINER MINI PROJECT")
!(println "==========================================")


; ------------------------------------------------------------
; Pattern 1: Humans who like Soda
; ------------------------------------------------------------

!(println "")
!(println "--- Pattern 1: Humans who like Soda ---")

!(human-soda-pattern &kb)


; ------------------------------------------------------------
; Support: Human + Soda
; ------------------------------------------------------------

!(println "")
!(println "--- Support: Human AND Likes Soda ---")

!(count-list (human-soda-pattern &kb))


; ------------------------------------------------------------
; Pattern 2: Humans who like Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Pattern 2: Humans who like Pizza ---")

!(human-pizza-pattern &kb)


; ------------------------------------------------------------
; Support: Human + Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Support: Human AND Likes Pizza ---")

!(count-list (human-pizza-pattern &kb))


; ------------------------------------------------------------
; Pattern 3: Human + Soda + Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Pattern 3: Human + Soda + Pizza ---")

!(human-soda-pizza-pattern &kb)


; ------------------------------------------------------------
; Support: Human + Soda + Pizza
; ------------------------------------------------------------

!(println "")
!(println "--- Support: Human + Soda + Pizza ---")

!(count-list (human-soda-pizza-pattern &kb))


; ------------------------------------------------------------
; Minimum Support = 2
; ------------------------------------------------------------

!(println "")
!(println "--- Minimum Support = 2 ---")

!(mine-pattern &kb Soda 2)

!(mine-pattern &kb Water 2)


!(println "")
!(println "==========================================")
!(println "MINING COMPLETE")
!(println "==========================================")