
define-record-type point #t #t x y z

define p make-point(55 88 44)


match p   
   | $(point x y z) -> display(z)
   | _ display(99)
