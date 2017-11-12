;;; -*- Gerbil -*-
;;; (C) vyzo at hackzen.org
;;; :gerbil/core prelude ssxi
prelude: :gerbil/compiler/ssxi
package: gerbil

;; gx-gambc0: struct-instance? and direct-struct-instance? [pattern matcher]
(declare-type*
 (struct-instance?
  (@lambda 2 inline:
      (ast-rules (%#call)
        ((%#call _ klass obj)
         (%#call (%#ref ##structure-instance-of?)
                 obj
                 (%#call (%#ref ##type-id) klass))))))
 (direct-struct-instance?
  (@lambda 2 inline:
      (ast-rules (%#call)
        ((%#call _ klass obj)
         (%#call (%#ref ##structure-direct-instance-of?)
                 obj
                 (%#call (%#ref ##type-id) klass)))))))

;; gx-gambc0: simple runtime functions that should be inlined
(declare-type*
 (true (@lambda (0) inline:
           (ast-rules (%#call %#ref)
             ((%#call _ (%#ref arg) ...)
              (%#quote #t))
             ((%#call _ arg ...)
              (%#begin arg ... (%#quote #t))))))
 (true? (@lambda 1 inline:
            (ast-rules (%#call)
              ((%#call _ arg)
               (%#call (%#ref eq?) arg (%#quote #t))))))
 (false (@lambda (0) inline:
            (ast-rules (%#call %#ref)
              ((%#call _ (%#ref arg) ...)
               (%#quote #f))
              ((%#call _ arg ...)
               (%#begin arg ... (%#quote #f))))))
 (void (@lambda (0) inline:
           (ast-rules (%#call %#ref)
             ((%#call _ (%#ref arg) ...)
              (%#quote #!void))
             ((%#call _ arg ...)
              (%#begin arg ... (%#quote #!void))))))
 (void? (@lambda 1 inline:
            (ast-rules (%#call)
              ((%#call _ arg)
               (%#call (%#ref eq?) arg (%#quote #!void))))))
 (identity (@lambda 1 inline:
               (ast-rules (%#call)
                 ((%#call _ arg)
                  arg)))))

;; gx-gambc0: simple hash-table ops
(declare-type*
 (make-hash-table (@lambda (0) make-table))
 (list->hash-table (@lambda 1 list->table))
 (hash? (@lambda 1 table?))
 (hash-table? (@lambda 1 table?))
 (hash-length (@lambda 1 table-length))
 (hash-ref (@case-lambda (2 table-ref) (3 table-ref)))
 (hash-get (@lambda 2 inline:
               (ast-rules (%#call)
                 ((%#call _ ht key)
                  (%#call (%#ref table-ref) ht key (%#quote #f))))))
 (hash-put! (@lambda 3 table-set!))
 (hash-remove! (@lambda 2 table-set!))
 (hash->list (@lambda 1 table->list))
 (hash-for-each (@lambda 2 table-for-each))
 (hash-find (@lambda 2 table-search)))

;; gx-gambc0: simple arithmetic
(declare-type*
 (1+ (@lambda 1 inline:
         (ast-rules (%#call)
           ((%#call _ arg)
            (%#call (%#ref +) arg (%#quote 1))))))
 (1- (@lambda 1 inline:
         (ast-rules (%#call)
           ((%#call _ arg)
            (%#call (%#ref -) arg (%#quote 1))))))
 (fx1+ (@lambda 1 inline:
           (ast-rules (%#call)
             ((%#call _ arg)
              (%#call (%#ref fx+) arg (%#quote 1))))))
 (fx1- (@lambda 1 inline:
           (ast-rules (%#call)
             ((%#call _ arg)
              (%#call (%#ref fx-) arg (%#quote 1))))))
 (fx/ (@lambda 2 fxquotient))
 (fxshift (@lambda 2 fxarithmetic-shift)))

;; gx-gambc0: foldings
(declare-type*
 (foldl (@case-lambda (3 foldl1) ((4) #f)))
 (foldr (@case-lambda (3 foldr1) ((4) #f)))
 (andmap (@case-lambda (2 andmap1) ((3) #f)))
 (ormap (@case-lambda (2 ormap1) ((3) #f)))
 (filter-map (@case-lambda (2 filter-map1) ((3) #f))))

;; gx-gambc0: call/cc and friends
(declare-type*
 (call-with-escape (@lambda 1 call-with-current-continuation))
 (with-catch (@lambda 2 with-exception-catcher)))

;; gx-gambc1: AST type for optimizing the expander
(declare-type*
 (AST::t (@struct-type gerbil#AST::t #f 2))
 (AST? (@struct-pred AST::t))
 (AST-e (@struct-getf AST::t 0))
 (AST-source (@struct-getf AST::t 1))
 (make-AST (@struct-cons AST::t)))
