(ql:quickload '(:cffi))

(cffi:load-foreign-library "librun-cocoa.dylib")

(cffi:defcallback dispatch-callback :void nil
  (room))


(cffi:foreign-funcall "run_event_loop" :pointer (cffi:callback dispatch-callback))


