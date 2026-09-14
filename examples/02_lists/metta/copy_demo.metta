; Demonstrate copy semantics in a symbolic language.
; In MeTTa, symbolic structures are immutable values. "Copying" means
; constructing a new structure; there is no in-place alias mutation as in
; Python. This demo shows transforming a nested list yields a new structure
; while the original atom remains available.

(define OriginalList (Cons (Cons 1 Nil) (Cons 2 Nil)))

!(println "--- OriginalList ---")
!(println OriginalList)

!(println "--- Mapped inner list via map inc (constructs a new structure) ---")
!(println (Cons (map inc (Cons 1 Nil)) (Cons 2 Nil)))

!(println "--- OriginalList still remains unchanged ---")
!(println OriginalList)

; Note: MeTTa atoms are values; "aliasing" in the Python sense does not
; generally apply. To 'mutate', you derive new atoms or replace facts in the
; space through rewrite rules; the original facts remain unless removed.
