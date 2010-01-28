(in-package :nisp.github-system)

(defpackage #:nisp.github
  (:use :cl :json))

(in-package :nisp.github)

(defparameter +github-api-url+ "https://github.com/api/v2/"
  ;; Use only the json interface, we do not want to implement the xml or
  ;; yaml interfaces.
  "Github api location.
This is the same for every call.")


(defun github-request (uri login token &rest parameters)
  "Ask github about URI using LOGIN and TOKEN."
  (declare (type string login token))
  (drakma:http-request uri :method :post
                       :parameters
                       `(("login" . ,login)
                         ("token" . ,token)
                         ,@parameters)))


(defun set-prototype (key)
  "Make KEY the json `*PROTOTYPE*'."
  (setq json::*prototype* key))

(defun key-add-or-set (key)
  "Mark KEY a prototype if it is, and add it to the accumulator."
  (let ((key (funcall json::*json-identifier-name-to-lisp* key)))
    (print key)
    (if (and (not json::*prototype*)
             (or (string= key "USER")
                 (string= key "PLAN")))
        (progn (setq json::*accumulator-last*
                     (setf (cdr json::*accumulator-last*) (cons (cons key nil) nil)))
               (setq *prot* key)
              #+ () (pushnew (cons "PROTOTYPE" key) (cddr json::*accumulator*))
               (set-prototype t))
        (setq json::*accumulator-last*
              (setf (cdr json::*accumulator-last*) (cons (cons key nil) nil))))
    json::*accumulator*))


;;; End file
