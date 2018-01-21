#!/usr/bin/env gxi-build-script
;; -*- Gerbil -*-
;; build-deps depgraph generator
(import "make" "build-config")

(include "build-spec.ss")

(let (srcdir (path-normalize (path-directory (this-source-file))))
  (cons-load-path (path-normalize (path-expand ".." srcdir))))

(displayln "... generate stdlib depgraph")
(let (depgraph (make-depgraph/spec build-spec))
  (call-with-output-file "build-deps" (cut pretty-print depgraph <>)))
