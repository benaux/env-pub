(define-module foo
  ;(use xxx)
  (export foo1 )
  )
;; Enter the module
(select-module foo)

(define (foo1 str)
	(display str))
