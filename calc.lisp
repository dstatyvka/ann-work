(in-package :number-one)

(defun axes (x-mean y-mean xs ys ev)
  (loop
     with xvec = (make-marray 'double-float
			      :initial-contents (list (maref ev 0 0)
						      (maref ev 0 1)))
     with yvec = (make-marray 'double-float
			      :initial-contents (list (maref ev 1 0)
						      (maref ev 1 1)))
     for x across (cl-array xs)
     for y across (cl-array ys)
     for vec = (make-marray 'double-float
			    :initial-contents (list (- x x-mean)
						    (- y y-mean)))
     maximize (abs (dot vec xvec)) into x-max
     maximize (abs (dot vec yvec)) into y-max
     finally (return (list x-max y-max))))

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
					       (,xy-v  ,y-var)))))
      (multiple-value-bind (eigens vecs)
	  (eigenvalues-eigenvectors m)
	(declare (ignore eigens))
	(axes x-mean y-mean xs ys vecs)))))


