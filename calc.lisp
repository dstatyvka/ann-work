(in-package :number-one)

(defun axes (x-mean y-mean xs ys ev)
  (loop
     with xvec = (make-marray 'double-float
			      :initial-contents (list (maref ev 0 0)
						      (maref ev 0 1)))
     with yvec = (make-marray 'double-float
			      :initial-contents (list (maref ev 1 0)
						      (maref ev 1 1)))
     for x in xs
     for y in ys
     for vec = (make-marray 'double-float
			    :initial-contents (list (- x x-mean)
						    (- y y-mean)))
     maximize (abs (dot vec xvec)) into x-max
     maximize (abs (dot vec yvec)) into y-max
     finally (return (list x-max y-max))))

(defun calc-eigens (xs ys)
  (let* ((xsm (make-marray 'double-float :initial-contents xs))
	 (ysm (make-marray 'double-float :initial-contents ys))
	 (x-mean (mean xsm))
	 (y-mean (mean ysm))
	 (x-var (variance xsm x-mean))
	 (y-var (variance ysm y-mean))
	 (xy-cv (covariance xsm ysm x-mean y-mean))
	 (m (make-marray 'double-float
			 :initial-contents `((,x-var ,xy-cv)
					     (,xy-cv  ,y-var)))))
    (multiple-value-bind (eigens vecs)
	(eigenvalues-eigenvectors m)
      (declare (ignore eigens))
      (list
       x-mean y-mean 
       (axes x-mean y-mean xs ys vecs)
       vecs))))

(defmacro with-filter ((wand x-list-var y-list-var threshold) &body body)
  (once-only (wand threshold)
    (with-gensyms (p i x y suitable width collect-x collect-y)
      `(let ((,i 0))
	 (multiple-value-bind (,x-list-var ,y-list-var)
	     (with-collectors (,collect-x ,collect-y)
	       (do-intensities (,p ,wand :width-var ,width)
		 (let ((,x (mod ,i ,width))
		       (,y (truncate (/ ,i ,width)))
		       (,suitable (< ,threshold ,p)))
		   (when ,suitable
		     (,collect-x ,x)
		     (,collect-y ,y)))
		 (incf ,i)))
	   (progn ,@body))))))

(defun to-degrees (radians)
  (/ radians pi (/ 1d0 180d0)))

(defun angle-from-vecs (vecs)
  (let* ((x1 (maref vecs 0 0))
	 (y1 (maref vecs 0 1))
	 ;; (x2 (maref vecs 1 0))
;; 	 (y2 (maref vecs 1 1))
	 (alpha1 (acos x1))
	 ;; (alpha2 (asin y1))
	 )
    (* (signum (- y1)) (to-degrees alpha1))))

(defun point (min max p)
  (+ min (* p (- max min))))

(defun threshold (wand coeff)
  (let (p-min p-max)
    (do-intensities (p wand)
      (setf p-min (or (and p-min (min p-min p)) p)
	    p-max (or (and p-max (max p-max p))
		      p)))
    (point p-min p-max coeff)))

(defun draw-results (wand x-mean y-mean sizes vecs)
  (with-drawing-wand (dw)
    (with-pixel-wand (pw :comp (0 0 0 0))
      (draw-set-fill-color dw pw))
    (with-pixel-wand (pw :comp (0 0 0))
      (draw-set-stroke-color dw pw))
    (draw-translate dw x-mean y-mean)
    (draw-rotate dw (angle-from-vecs vecs))
    (destructuring-bind (x-size y-size) sizes
      (draw-ellipse dw 0.0d0 0.0d0 x-size y-size 0.0d0 360.0d0))
    (magick-draw-image wand dw)))

(defun test ()
  (with-source (www "../9_19/00000006.png")
    (with-filter (www xs ys (threshold www 0.6d0))
      (apply #'draw-results www (calc-eigens xs ys))
      (magick-display-image www ":0"))))

(defun process-file (source target)
  (with-source (www (namestring source))
    (with-filter (www xs ys (threshold www 0.6d0))
      (apply #'draw-results www (calc-eigens xs ys))
      (magick-write-image www (namestring target)))))

(defun process-directory (sources-dir target-dir)
  (ensure-directories-exist target-dir)
  (dolist (source (list-directory sources-dir))
    (let ((target (merge-pathnames (file-namestring source) target-dir)))
      (process-file source target))))
