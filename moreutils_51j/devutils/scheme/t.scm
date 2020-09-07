(use file.util)

(define path "/Users/bkb/r/tools/moreutils/langs/gauche")
(directory-fold path cons '()
  :lister (lambda (path seed)
            (values (directory-list path :add-path? #t :children? #t)
                    (display seed))))
