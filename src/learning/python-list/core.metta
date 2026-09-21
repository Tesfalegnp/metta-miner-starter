;; ================================================================
;; Python-list MM2/MORK Educational Module: Core
;;
;; Defines the common request/response conventions for list
;; operations in the AtomSpace.
;;
;; Representation:
;;     Symbolic lists are represented as expressions:
;;         (Alice Bob Carol)
;;     The empty list is:
;;         ()
;;
;; Protocol:
;;     Request: (LIST-REQUEST <operation> <id> <args...>)
;;     Result:  (LIST-RESULT  <operation> <id> <value>)
;; ================================================================

;; 1. CONSTRUCT
;; Directly materializes a list construction request into a result fact.
(exec (freq 010 list-construct)
  (, (LIST-REQUEST construct $id $list))
  (O
    (+ (LIST-RESULT construct $id $list))
    (- (LIST-REQUEST construct $id $list))))
