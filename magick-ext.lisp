(in-package :lisp-magick)

(defmagickfun "MagickSetImageColorspace" :boolean
  ((wand magick-wand)
   (colorspace colorspace-type)))