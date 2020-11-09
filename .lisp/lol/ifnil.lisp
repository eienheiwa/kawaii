
(defvar *number-was-odd* nil)

(defvar *number-is-odd* nil)


(defvar *arch-enemy* nil)

(defun pudding-eater (person)
  (cond ((eq person 'henry) (setf *arch-enemy* 'stupid-lisp-alien)
         '(curse you lisp alien - you ate my pudding))
        ((eq person 'johnny) (setf *arch-enemy* 'useless-old-johnny)
         '(i hope you choked on my pudding johnny))
        (t  '(why you eat my pudding stranger ?))))


(defun pudding-eater (person)
  (case person
    ((henry) (setf *arch-enemy* 'stupid-lisp-alien)
     '(curse you lisp alien - you ate my pudding))
    ((johnny) (setf *arch-enemy* 'useless-old-johnny)
     '(i hope you choked on my pudding johnny))
    (kakoi-chan '(why you eat my pudding stranger ?))))


(defparameter *fruit* 'apple)

(cond ((eq *fruit* 'apple) 'its-an-apple)
      ((eq *fruit* 'banana) 'its-an-banana))
