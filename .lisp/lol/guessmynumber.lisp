
(defparameter *small* 1)
(defparameter *big* 100)

(defun guess-my-number ()
  (ash (+ *small* *big*) -1))


;;return only five
(defun return-five ()
  (+ 1 1 1 1 1))


(defun smaller ()
  (setf *big* (1- (guess-my-number)))
  (guess-my-number))

(defun bigger ()
  (setf *small* (1+ (guess-my-number)))
  (guess-my-number))

(defun start-over ()
  (defparameter *small* 1)
  (defparameter *big* 100)
  (guess-my-number))




;;;LET

(let ((a 5)
      (b 320))
  (+ a b))

;;;FLET

(flet ((f (n)
         (+ n 10)))

  (f 5))

;;;localfunction*2

(flet ((f (n)
         (+ n 10))
       (g (n)
         (- n 3)))
  (g (f 5)))

;;;labels

(labels ((a (n)
           (+ n 5))
        (b (n)
           (+ (a n) 6)))
       (b 10))

