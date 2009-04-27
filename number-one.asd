(in-package :cl-user)

(defpackage :number-one-system
  (:use :cl :asdf))

(in-package :number-one-system)

(defsystem :number-one
  :author "Ann Statyvka"
  :version "0.0.1"
  :serial t
  :depends-on (:gsll :cl-gd :cl-fad :cl-utilities)
  :components ((:file "packages")
	       (:file "io")))
