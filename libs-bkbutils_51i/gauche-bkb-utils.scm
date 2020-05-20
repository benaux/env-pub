;; Define the module interface
(define-module bkb.utils
  (export echo )
  (export die )
  (export table )
  (export put )
  (export get )
  (export for-each-line )
  )
;; Enter the module
(select-module bkb.utils)

(define echo display)

(define (die msg)
  (format (current-error-port)
          "~a\n" msg)
  (exit 2))

(define (usage program-name)
  (format (current-error-port)
          "Usage: ~a regexp file ...\n" program-name)
  (exit 2))

(define (table)
	(make-hash-table 'eq?))

(define get hash-table-get) 

(define put hash-table-put! )


(define (for-each-line filename proc )
  "call PROC for each line in FILENAME"
  (with-input-from-file filename
    (lambda ()
      (do ((line (read-line) (read-line)))
          ((eof-object? line))
        (proc line)))))
