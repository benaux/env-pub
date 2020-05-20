#!/usr/bin/env gosh


(define alph '( a b c d e f g h i j k l m n o p q r s t u v x y z))

(define counter 0)

(define (main args)
  (for-each
    (lambda (x)
      (set! counter (+ counter 1))
      (display counter))
    alph))


