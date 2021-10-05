(ql:quickload '(:cffi))

(defun shm-open (name flag mode)
  (cffi:foreign-funcall-varargs "shm_open" (:string name :int flag) :short mode :int 0 :int))

(cffi:defcfun (shm-unlink "shm_unlink") :int
  (name :string))

(defvar *fd*)

;; it perfectly
(setf *fd*
  (alien-funcall (extern-alien "shm_open"
                               (function int c-string int &optional int))
		 "/tmp/foo"
		 (logior sb-posix:o-creat sb-posix:o-rdwr)
		 #o664))


(setf *fd*
  (let* ((fd
	   (shm-open "/tmp/shm-foo"
		     (logior sb-posix:o-creat sb-posix:o-rdwr) 
		     #o664)))
    (assert (> fd 0) nil "shm_open failed: ~d" fd)
    fd))



;; (shm-unlink "/tmp/shm-foo")

(sb-posix:ftruncate *fd* 1024)

(defparameter *memory* (sb-posix:mmap (cffi:null-pointer) 1024 (logior sb-posix:prot-read sb-posix:prot-write)
				     sb-posix:map-shared *fd* 0))
