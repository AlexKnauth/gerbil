prelude: :gerbil/compiler/ssxi
package: gerbil/expander

(begin
  (declare-type
   gx#identifier-wrap::t
   (@struct-type gx#identifier-wrap::t AST::t 1 #f ((final: . #t))))
  (declare-type gx#identifier-wrap? (@struct-pred gx#identifier-wrap::t))
  (declare-type gx#make-identifier-wrap (@struct-cons gx#identifier-wrap::t))
  (declare-type
   gx#identifier-wrap-marks
   (@struct-getf gx#identifier-wrap::t 0 #f))
  (declare-type
   gx#identifier-wrap-marks-set!
   (@struct-setf gx#identifier-wrap::t 0 #f))
  (declare-type
   gx#syntax-wrap::t
   (@struct-type gx#syntax-wrap::t AST::t 1 #f ((final: . #t))))
  (declare-type gx#syntax-wrap? (@struct-pred gx#syntax-wrap::t))
  (declare-type gx#make-syntax-wrap (@struct-cons gx#syntax-wrap::t))
  (declare-type gx#syntax-wrap-mark (@struct-getf gx#syntax-wrap::t 0 #f))
  (declare-type gx#syntax-wrap-mark-set! (@struct-setf gx#syntax-wrap::t 0 #f))
  (declare-type
   gx#syntax-quote::t
   (@struct-type gx#syntax-quote::t AST::t 2 #f ((final: . #t))))
  (declare-type gx#syntax-quote? (@struct-pred gx#syntax-quote::t))
  (declare-type gx#make-syntax-quote (@struct-cons gx#syntax-quote::t))
  (declare-type gx#syntax-quote-context (@struct-getf gx#syntax-quote::t 0 #f))
  (declare-type gx#syntax-quote-marks (@struct-getf gx#syntax-quote::t 1 #f))
  (declare-type
   gx#syntax-quote-context-set!
   (@struct-setf gx#syntax-quote::t 0 #f))
  (declare-type
   gx#syntax-quote-marks-set!
   (@struct-setf gx#syntax-quote::t 1 #f))
  (declare-type
   gx#datum->syntax
   (@case-lambda
    (2 gx#datum->syntax__0)
    (3 gx#datum->syntax__1)
    (4 gx#datum->syntax__opt-lambda4370)))
  (declare-type
   gx#stx-unwrap
   (@case-lambda (1 gx#stx-unwrap__0) (2 gx#stx-unwrap__opt-lambda4346)))
  (declare-type
   gx#genident
   (@case-lambda
    (0 gx#genident__0)
    (1 gx#genident__1)
    (2 gx#genident__opt-lambda4108)))
  (declare-type
   gx#stx-for-each
   (@case-lambda (2 gx#stx-for-each1) (3 gx#stx-for-each2)))
  (declare-type gx#stx-map (@case-lambda (2 gx#stx-map1) (3 gx#stx-map2)))
  (declare-type
   gx#stx-plist?
   (@case-lambda (1 gx#stx-plist?__0) (2 gx#stx-plist?__opt-lambda3354)))
  (declare-type
   gx#stx-getq
   (@case-lambda (2 gx#stx-getq__0) (3 gx#stx-getq__opt-lambda3272))))
