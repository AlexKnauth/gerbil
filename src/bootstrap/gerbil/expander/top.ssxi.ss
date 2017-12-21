prelude: :gerbil/compiler/ssxi
package: gerbil/expander

(begin
  (declare-type
   gx#core-expand-lambda%
   (@case-lambda
    (1 gx#core-expand-lambda%__0)
    (2 gx#core-expand-lambda%__opt-lambda8127)))
  (declare-type
   gx#core-expand-letrec-values%
   (@case-lambda
    (1 gx#core-expand-letrec-values%__0)
    (2 gx#core-expand-letrec-values%__opt-lambda7990)))
  (declare-type
   gx#core-expand-let-bind-syntax!
   (@case-lambda
    (2 gx#core-expand-let-bind-syntax!__0)
    (3 gx#core-expand-let-bind-syntax!__opt-lambda7582)))
  (declare-type
   gx#macro-expand-let-values
   (@case-lambda
    (1 gx#macro-expand-let-values__0)
    (2 gx#macro-expand-let-values__opt-lambda6733)))
  (declare-type
   gx#check-duplicate-identifiers
   (@case-lambda
    (1 gx#check-duplicate-identifiers__0)
    (2 gx#check-duplicate-identifiers__opt-lambda6531)))
  (declare-type
   gx#core-bind-values!
   (@case-lambda
    (1 gx#core-bind-values!__0)
    (2 gx#core-bind-values!__1)
    (3 gx#core-bind-values!__2)
    (4 gx#core-bind-values!__opt-lambda6487)))
  (declare-type
   gx#core-bind-runtime!
   (@case-lambda
    (1 gx#core-bind-runtime!__0)
    (2 gx#core-bind-runtime!__1)
    (3 gx#core-bind-runtime!__2)
    (4 gx#core-bind-runtime!__opt-lambda6426)))
  (declare-type
   gx#core-bind-runtime-reference!
   (@case-lambda
    (2 gx#core-bind-runtime-reference!__0)
    (3 gx#core-bind-runtime-reference!__1)
    (4 gx#core-bind-runtime-reference!__2)
    (5 gx#core-bind-runtime-reference!__opt-lambda6381)))
  (declare-type
   gx#core-bind-extern!
   (@case-lambda
    (2 gx#core-bind-extern!__0)
    (3 gx#core-bind-extern!__1)
    (4 gx#core-bind-extern!__2)
    (5 gx#core-bind-extern!__opt-lambda6341)))
  (declare-type
   gx#core-bind-syntax!
   (@case-lambda
    (2 gx#core-bind-syntax!__0)
    (3 gx#core-bind-syntax!__1)
    (4 gx#core-bind-syntax!__2)
    (5 gx#core-bind-syntax!__opt-lambda6295)))
  (declare-type
   gx#core-bind-root-syntax!
   (@case-lambda
    (2 gx#core-bind-root-syntax!__0)
    (3 gx#core-bind-root-syntax!__opt-lambda6278)))
  (declare-type
   gx#core-bind-alias!
   (@case-lambda
    (2 gx#core-bind-alias!__0)
    (3 gx#core-bind-alias!__1)
    (4 gx#core-bind-alias!__2)
    (5 gx#core-bind-alias!__opt-lambda6236)))
  (declare-type
   gx#make-binding-id
   (@case-lambda
    (1 gx#make-binding-id__0)
    (2 gx#make-binding-id__1)
    (3 gx#make-binding-id__2)
    (4 gx#make-binding-id__opt-lambda6193))))
