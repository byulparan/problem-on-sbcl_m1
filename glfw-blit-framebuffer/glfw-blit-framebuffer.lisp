(ql:quickload :cl-glfw3-examples)
(in-package :cl-user)

(glfw:def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close)))



(defun set-viewport (width height)
  (gl:viewport 0 0 width height))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (set-viewport w h))

(defvar *render-fbo* nil)
(defvar *screen-fbo* nil)

(defun render ()
  (let* ((width 800)
	 (height 600))
    (gl:viewport 0 0 width height)
    (gl:clear-color .0 .0 .0 1.0)
    (gl:clear :color-buffer-bit :depth-buffer-bit)
    (gl:bind-framebuffer :framebuffer *render-fbo*)
    (gl:clear-color .0 .0 .0 1.0)
    (gl:clear :color-buffer-bit :depth-buffer-bit)
    (gl:enable :depth-test)
    (gl:disable :depth-test)
    (gl:bind-framebuffer :read-framebuffer *render-fbo*)
    (gl:bind-framebuffer :draw-framebuffer *screen-fbo*)
    (%gl:blit-framebuffer 0 0 width height 0 0 width height
			  (+
			   (cffi:foreign-enum-value '%gl:enum :color-buffer-bit)
			   (cffi:foreign-enum-value '%gl:enum :depth-buffer-bit))
			  :nearest)
    (gl:bind-framebuffer :framebuffer 0)))


(defun basic-window-example ()
  ;; Graphics calls on OS X must occur in the main thread
  (trivial-main-thread:with-body-in-main-thread ()
    (glfw:with-init-window (:title "Window test" :width 600 :height 400
			    :context-version-major 3
			    :context-version-minor 3
			    :opengl-forward-compat t
			    :opengl-profile :opengl-core-profile)
      (setf %gl:*gl-get-proc-address* #'glfw:get-proc-address)
      (glfw:set-key-callback 'quit-on-escape)
      (glfw:set-window-size-callback 'update-viewport)
      (gl:clear-color 0 0 0 0)
      (let* ((width 600)
	     (height 400))
	(let* ((framebuffer (gl:gen-framebuffer))
	       (colorbuffer (gl:gen-renderbuffer))
	       (depthbuffer (gl:gen-renderbuffer)))
	  (gl:bind-framebuffer :framebuffer framebuffer)
	  (gl:bind-renderbuffer :renderbuffer colorbuffer)
	  (gl:renderbuffer-storage-multisample :renderbuffer 4 :rgb8 width height) ;; 반드시 rgb8. rgba8 은 invalid operation
	  (gl:bind-renderbuffer :renderbuffer 0)
	  (gl:framebuffer-renderbuffer :framebuffer :color-attachment0 :renderbuffer colorbuffer)
	  (gl:bind-renderbuffer :renderbuffer depthbuffer)
	  (gl:renderbuffer-storage-multisample :renderbuffer 4 :depth-component width height)
	  (gl:bind-renderbuffer :renderbuffer 0)
	  (gl:framebuffer-renderbuffer :framebuffer :depth-attachment :renderbuffer depthbuffer)
	  (unless (eql :framebuffer-complete-oes (gl:check-framebuffer-status-ext :framebuffer))
	    (error "can't (re)initialize multisample-framebuffer"))
	  (gl:bind-framebuffer :framebuffer 0)
	  (setf *render-fbo* framebuffer)
	  (let* ((framebuffer (gl:gen-framebuffer))
		 (color-texture nil)
		 (depthbuffer nil))
	    (gl:bind-framebuffer :framebuffer framebuffer)
	    (setf color-texture (gl:gen-texture))
	    (gl:bind-texture :texture-rectangle color-texture)
	    (gl:tex-image-2d :texture-rectangle 0 :rgb width height 0 :rgb :unsigned-byte (cffi:null-pointer))
	    (gl:tex-parameter :texture-rectangle :texture-min-filter :linear)
	    (gl:tex-parameter :texture-rectangle :texture-mag-filter :linear)
	    (gl:framebuffer-texture-2d :framebuffer :color-attachment0 :texture-rectangle color-texture 0)
	    (setf depthbuffer (gl:gen-renderbuffer))
	    (gl:bind-renderbuffer :renderbuffer depthbuffer)
	    (gl:renderbuffer-storage :renderbuffer :depth-component width height)
	    (gl:bind-renderbuffer :renderbuffer 0)
	    (gl:framebuffer-renderbuffer :framebuffer :depth-attachment :renderbuffer depthbuffer)
	    (unless (eql :framebuffer-complete-oes (gl:check-framebuffer-status-ext :framebuffer))
	      (error "can't (re)initialize multisample-framebuffer"))
	    (gl:bind-framebuffer :framebuffer 0)
	    (setf *screen-fbo* framebuffer))))


      
      (loop until (glfw:window-should-close-p)
            do (render)
            do (glfw:swap-buffers)
            do (glfw:poll-events)))))


(basic-window-example)
