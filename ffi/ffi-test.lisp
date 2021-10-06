(in-package :cl-user)
(load-shared-object "libffitest.dylib")

;; sbcl native ffi
(alien-funcall 
 (extern-alien "test_fun" (function void int int int int int int int int int int int int))
 0 1 2 3 4 5 6 7 8 9 10 11)





