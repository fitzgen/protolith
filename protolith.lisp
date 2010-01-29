(defpackage :protolith
  (:use :common-lisp)
  (:export :defobj))

(in-package :protolith)

(defun new-object (&optional proto)
  "Create a new object"
  ;; TODO: use (string sdflkfj) to save and get things from the hash, that way
  ;; both :keys and 'symbols, as well as whatever else, can be used.

  ;; TODO: s/proto/protos !

  ;; TODO: Factor out all of the lets to the top level
  (let ((dict (make-hash-table)))
    (labels ((object (&rest args)
                     (cond ((null args)
                            (funcall (gethash 'call dict) #'object))
                           ((eq (car args) 'set)
                            (let ((slot (cadr args))
                                  (val (caddr args)))
                              (setf (gethash slot dict) val)))
                           ((eq (car args) 'get)
                            (let ((slot (cadr args)))
                              (or (gethash slot dict)
                                  (if proto
                                      (funcall proto 'get slot)
                                    nil))))
                           ((eq (car args) 'proto)
                            proto)
                           ((eq (car args) 'slots)
                            (let ((slots ()))
                              (progn
                                (maphash #'(lambda (k v)
                                             (setf slots (cons (cons k v) slots)))
                                         dict)
                                slots)))
                           (t (let ((slot (funcall #'object 'get (car args)))
                                    (slot-args (cdr args)))
                                (if (typep slot 'function)
                                    (apply slot #'object slot-args)
                                  slot))))))
      #'object)))

(defmacro defobj (name proto &rest attrs)
  "Define a new protolith object."
  (let ((obj (gensym)))
    `(let ((,obj (new-object ,@proto)))
       (prog1
           (defun ,name (&rest args)
             (apply ,obj args))
         (defvar ,name #',name)
         (loop for attr-pair in ',attrs
               do (funcall ,obj 'set (car attr-pair) (eval (cadr attr-pair))))))))