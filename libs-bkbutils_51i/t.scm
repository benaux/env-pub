(use bkb.utils)


(define t (table))


(put t :hello "this is me")

(echo (get t :hello))

(for-each-line "bla.txt" 
  (lambda (x)
    (display x)))
