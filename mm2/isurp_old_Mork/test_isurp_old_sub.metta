;; =============================================================================
;; Targeted Test Suite for isurp-old_ and Partition Helpers
;; =============================================================================

;; TEST-AUX mm2/isurp_old_Mork/isurp-old-helpers.metta
;; TEST-AUX mm2/isurp_old_Mork/isurp-old.metta

;; 1. Empty partition list
(isurp-old_ () &test-space 4)
;; Expected: ()

;; 2. One partition with one block
(isurp-old_ ((Inheritance $m man)) &test-space 4)
;; Expected: (0.5)

;; 3. One partition with two blocks
(isurp-old_ (((Inheritance $x man) (Inheritance $x ugly))) &test-space 4)
;; Expected: (0.25)

;; 4. Multiple partitions: 2 partitions each with 1 block
(isurp-old_ (((Inheritance $m man)) ((Inheritance $m ugly))) &test-space 4)
;; Expected: ((0.5 0.25))

;; 5. Multiple partitions: 2 partitions with mixed blocks
;; P1: 2 blocks ((Inheritance $x man) (Inheritance $x ugly)) -> 2/4 * 1/4 = 0.125
;; P2: 1 block ((Inheritance $x man)) -> 2/4 = 0.5
(isurp-old_ (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x man))) &test-space 4)
;; Expected: ((0.125 0.5))

;; 6. Multiple partitions: 3 partitions
(isurp-old_ (((Inheritance $x man)) ((Inheritance $x ugly)) ((Inheritance $x man))) &test-space 4)
;; Expected: ((0.5 0.25 0.5))

;; 7. Zero-support block (pattern not in database)
(isurp-old_ (((Inheritance $x nonexistent))) &test-space 4)
;; Expected: (0.0)

;; 8. Repeated invocations to verify clean state (no accumulation across calls)
(isurp-old_ ((Inheritance $m man)) &test-space 4)
;; Expected: (0.5)

(isurp-old_ ((Inheritance $m man)) &test-space 4)
;; Expected: (0.5)
