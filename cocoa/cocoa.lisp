(ql:quickload '(:cffi))

(cffi:load-foreign-library "librun-cocoa.dylib")

(cffi:defcallback dispatch-callback :void nil
  (room))

;; Cocoa function should be run on main-thread
(sb-thread:interrupt-thread
 (sb-thread:main-thread)
 (lambda ()
   (cffi:foreign-funcall "run_event_loop" :pointer (cffi:callback dispatch-callback))))


