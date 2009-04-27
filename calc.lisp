(in-package :number-one)

(defun process-file (fname)
  (destructuring-bind (xs ys)
      (read-file fname)
    (let* ((x-mean (mean xs))
	   (y-mean (mean ys))
	   (x-var (variance xs x-mean))
	   (y-var (variance ys y-mean))
	   (xy-v (covariance xs ys x-mean y-mean))
	   (m (make-marray 'double-float
			   :initial-contents `((,x-var ,xy-v)
					       (,xy-v  ,y-var))))
	   (ev (multiple-value-list
		(eigenvalues-eigenvectors m))))
      (values x-mean y-mean x-var y-var xy-v ev))))
