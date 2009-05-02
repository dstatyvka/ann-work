(in-package :lisp-magick)

(defmagickfun "MagickSetImageColorspace" :boolean
  ((wand magick-wand)
   (colorspace colorspace-type)))

(defmagickfun "DrawRotate" :void
  ((dwand drawing-wand)
   (degrees :double)))

(defmagickfun "DrawTranslate" :void
  ((dwand drawing-wand)
   (x :double)
   (y :double)))
