(in-package :cl-user)

(defpackage :number-one-system
  (:use :cl :asdf))

(in-package :number-one-system)

(defsystem :number-one
  :author "Ann Statyvka"
  :version "0.0.1"
  :serial t
  :depends-on (:gsll :cffi :cl-fad :cl-utilities :lisp-magick)
  :components ((:file "packages")
	       (:file "macros")
	       (:file "magick-ext")
	       (:file "io")
	       (:file "calc")))
